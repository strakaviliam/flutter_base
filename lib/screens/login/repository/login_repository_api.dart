
import 'package:base/application/app_cache.dart';
import 'package:base/screens/login/model/token_model.dart';
import 'package:base/screens/login/model/user_email_model.dart';
import 'package:base/screens/login/repository/login_repository.dart';
import 'package:base/tools/api/api.dart';
import 'package:base/tools/api/result.dart';

class LoginRepositoryApi implements LoginRepository {

  Api _checkEmailApi;
  Api _loginApi;
  Api _registerApi;

  LoginRepositoryApi({Api checkEmailApi, Api loginApi, Api registerApi}) {
    _checkEmailApi = checkEmailApi ?? Api("/user/check_email", method: HTTPMethod.post, publicAPI: true);
    _loginApi = loginApi ?? Api("/user/login", method: HTTPMethod.post, publicAPI: true);
    _registerApi = registerApi ?? Api("/user/register", method: HTTPMethod.post, publicAPI: true);
  }

  @override
  Future<UserEmailModel> verifyEmail(String email) async {
    Result result = await _checkEmailApi.call(parameters: {
      "email": email
    });

    if (result.status == Status.fail) {
      throw ErrorResult(result);
    }

    return UserEmailModel.fromMap(Map<String, dynamic>.of(result.data));
  }

  @override
  Future<void> login(String email, String password) async {
    Result result = await _loginApi.call(parameters: {
      "email": email,
      "password": password
    });

    if (result.status == Status.fail) {
      throw ErrorResult(result);
    }

    TokenModel tokenModel = TokenModel.fromMap(Map<String, dynamic>.of(result.data));
    AppCache.instance.setupToken(tokenModel);
  }

  @override
  Future<void> register(String email, String password) async {
    Result result = await _registerApi.call(parameters: {
      "email": email,
      "password": password
    });

    if (result.status == Status.fail) {
      throw ErrorResult(result);
    }

    TokenModel tokenModel = TokenModel.fromMap(Map<String, dynamic>.of(result.data));
    AppCache.instance.setupToken(tokenModel);
  }
}
