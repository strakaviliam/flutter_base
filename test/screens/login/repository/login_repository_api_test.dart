import 'package:base/application/app_cache.dart';
import 'package:base/screens/login/model/user_email_model.dart';
import 'package:base/screens/login/repository/login_repository_api.dart';
import 'package:base/tools/api/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test_tools.dart';

void main() {
  group('LoginRepositoryApi', () {
    MockApi checkEmailApi;
    MockApi loginApi;
    MockApi registerApi;
    LoginRepositoryApi loginRepositoryApi;

    setUp(() {
      commonSetup();
      checkEmailApi = MockApi();
      loginApi = MockApi();
      registerApi = MockApi();
      loginRepositoryApi = LoginRepositoryApi(checkEmailApi: checkEmailApi, loginApi: loginApi, registerApi: registerApi);
    });

    test('after call verifyEmail error response throw ErrorResult', () async {
      when(checkEmailApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(Result.fail("error", "")));

      try {
        await loginRepositoryApi.verifyEmail("");
      } catch (ex) {
        expect(ex, isInstanceOf<ErrorResult>());
      }
    });

    test('after call login error response throw ErrorResult', () async {
      when(loginApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(Result.fail("error", "")));

      try {
        await loginRepositoryApi.login("", "");
      } catch (ex) {
        expect(ex, isInstanceOf<ErrorResult>());
      }
    });

    test('after call register error response throw ErrorResult', () async {
      when(registerApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(Result.fail("error", "")));

      try {
        await loginRepositoryApi.register("", "");
      } catch (ex) {
        expect(ex, isInstanceOf<ErrorResult>());
      }
    });

    test('after call verifyEmail success response return UserEmailModel', () async {
      Map<String, dynamic> json = (await mockedJson("user_email_model"))["body"];
      Result result = Result.success(json, "");

      when(checkEmailApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(result));

      expect(await loginRepositoryApi.verifyEmail(""), UserEmailModel.fromMap(json));
    });

    test('after call login success setup token', () async {
      Map<String, dynamic> json = (await mockedJson("token_model"))["body"];
      Result result = Result.success(json, "");

      when(loginApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(result));

      await loginRepositoryApi.login("", "");
      verify(AppCache.instance.setupToken(any)).called(1);
    });

    test('after call register success setup token', () async {
      Map<String, dynamic> json = (await mockedJson("token_model"))["body"];
      Result result = Result.success(json, "");

      when(registerApi.call(parameters: anyNamed("parameters"))).thenAnswer((_) => Future.value(result));

      await loginRepositoryApi.register("", "");
      verify(AppCache.instance.setupToken(any)).called(1);
    });
  });
}


//TokenModel tokenModel = TokenModel.fromMap(Map<String, dynamic>.of(result.data));
//AppCache.instance.setupToken(tokenModel);