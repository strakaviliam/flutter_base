import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:base/application/app_cache.dart';
import 'package:base/application/environment/development.dart';
import 'package:base/application/environment/environment.dart';
import 'package:base/application/environment/local.dart';
import 'package:base/application/strings.dart';
import 'package:base/tools/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'ignore_certificate_client.dart';
import 'result.dart';

enum HTTPMethod {
  get, post
}

class Api {

  Client client;
  bool printResponse = false;
  String endpoint = "";
  HTTPMethod method = HTTPMethod.get;
  bool publicAPI = false;
  int timeoutBase = 20000;

  Map<String, String> headersCommon = {
    "Content-Type": "application/json"
  };

  Api(this.endpoint, {this.method: HTTPMethod.get, this.publicAPI: false, this.client}) {
    if (client == null) {
      client = IgnoreCertificateClient();
    }
    printResponse = Environment.value is Local || Environment.value is Development;
  }

  Future<Result> call({
    Map<String,dynamic> parameters: const {},
    Map<String,String> headers: const {},
    String key,
    Uint8List uploadData
  }) async {

    key = key ?? Tools.randomString();

    //prepare headers
    Map<String,String> headersToAddInRequest = headersCommon;
    headers.forEach((key,val) => headersToAddInRequest[key] = val);

    //build url
    String url = Environment.value.path + endpoint;
    if (endpoint.startsWith("http")) {
      url = endpoint;
    }

    //parameters
    Map<String, dynamic> paramsToAddInRequest = {};

    //replace in url {...} - dynamic parts - with parameters
    if(parameters.isNotEmpty) {
      parameters.forEach((key, val) {
        if(url.contains(key) && key.startsWith("{") && key.endsWith("}")) {
          url = url.replaceAll(key, val);
        } else {
          paramsToAddInRequest[key] = val;
        }
      });
      url = url.replaceAll("://", ":///");
      url = url.replaceAll("//", "/");
    }

    //if get, create params in path
    if (method == HTTPMethod.get && paramsToAddInRequest.isNotEmpty) {

      String apiParams = "";
      paramsToAddInRequest.forEach((key,val) {
        val = Uri.encodeFull(val.toString());
        val = val.toString().replaceAll("&", "%26");
        key = Uri.encodeFull(key.toString());
        key = key.toString().replaceAll("&", "%26");
        apiParams = apiParams + "$key=$val&";
      });

      if (apiParams.endsWith("&")) {
        apiParams = apiParams.substring(0, apiParams.length - 1);
      }
      url = "$url?$apiParams";
      paramsToAddInRequest = {};
    }

    if (url.endsWith("/")) {
      url = url.substring(0, url.length - 1);
    }

    if (printResponse) {
      debugPrint("_______________ REQUEST _________________________________________");
      debugPrint("url:   $url");
      debugPrint("method:   ${method.toString()}");
      debugPrint("headers:   ${headersToAddInRequest.toString()}");
      debugPrint("params:   ${paramsToAddInRequest.toString()}");
    }

    //token management
    String token = AppCache.instance.token;
    DateTime tokenExpire = AppCache.instance.tokenExpire;

    //check if token is valid
    if (token != null && tokenExpire != null && tokenExpire.isAfter(DateTime.now())) {
      headersToAddInRequest["Authorization"] = "bearer $token";
    } else if (!publicAPI) {
      return _handleFailResponse(ClientException(S.ERROR_TOKEN, Uri.parse(url)), key);
    }

    Response response;

    try {
      switch (method) {
        case HTTPMethod.get: {
          response = await client.get(url, headers: headersToAddInRequest).timeout(Duration(milliseconds: timeoutBase));
        } break;
        case HTTPMethod.post: {
          if (uploadData != null) {
            headersToAddInRequest["Content-Type"] = "octet-stream";

            var request = MultipartRequest('POST', Uri.parse(url));
            request.headers.addAll(headersToAddInRequest);
            request.files.add(MultipartFile.fromBytes('file', uploadData, filename: "file"));
            paramsToAddInRequest.forEach((key, value) {
              request.fields[key] = value ?? "";
            });
            StreamedResponse streamedResponse = await client.send(request).timeout(Duration(milliseconds: timeoutBase));
            response = await Response.fromStream(streamedResponse);
          } else {
            response = await client.post(url, headers: headersToAddInRequest, body: json.encode(paramsToAddInRequest)).timeout(Duration(milliseconds: timeoutBase));
          }
        } break;
      }
    } catch (error) {
      if (error is TimeoutException) {
        return _handleFailResponse(ClientException(S.ERROR_TOKEN, Uri.parse(url)), key);
      } else if (error is StateError) {
        return _handleFailResponse(ClientException(error.message, Uri.parse(url)), key);
      } else if (error is ClientException) {
        return _handleFailResponse(error, key);
      } else {
        return _handleFailResponse(null, key);
      }
    }

    if (response.statusCode == 200) {
      return _handleSuccessResponse(response, key);
    } else {

      String error = S.ERROR_GENERAL;
      try {
        Map<String, dynamic> data = json.decode(response.body);
        error = data["error"];
      } catch (_) {}

      return _handleFailResponse(ClientException(error, response.request?.url ?? Uri()), key, code: response.statusCode.toString());
    }
  }

  Result<dynamic> _handleFailResponse(ClientException response, String key, {String code}) {

    Result<dynamic> result = Result<dynamic>();
    result.key = key;
    result.error = code ?? "500";
    result.status = Status.fail;

    if (response == null || response.message == null) {
      result.error = "500";
    } else {
      result.error = response.message ?? code;
    }

    if (printResponse) {
      debugPrint("_______________ ERROR _________________________________________");
      debugPrint("error:   ${result.error}");
    }

    return result;
  }

  Result<dynamic> _handleSuccessResponse(Response response, String key) {
    Result<dynamic> result = Result<dynamic>();
    result.key = key;

    Map<String, dynamic> data = json.decode(response.body);

    bool status = data["status"];

    if (status) {
      result.status = Status.success;
      result.data = data["body"];

      if (printResponse) {
        debugPrint("_______________ RESULT _________________________________________");
        debugPrint("response:   $data");
      }

    } else {
      result.status = Status.fail;

      String code = data["code"].toString();
      result.error = code;

      Map<String, dynamic> errorData = data["error"];
      errorData.forEach((key, val) {
        if (key == "message") {
          result.error = val;
        } else {
          result.message[key] = val;
        }
      });

      if (printResponse) {
        debugPrint("_______________ RESULT (ERROR) _________________________________________");
        debugPrint("response:   $data");
      }
    }

    return result;
  }
}
