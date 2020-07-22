import 'package:base/screens/login/bloc/login_bloc.dart';
import 'package:base/screens/login/model/token_model.dart';
import 'package:base/screens/login/model/user_email_model.dart';
import 'package:base/screens/login/repository/login_repository.dart';
import 'package:base/tools/api/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../test_tools.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  group('LoginBloc', () {

    LoginBloc loginBloc;
    MockLoginRepository loginRepository;

    setUp(() {
      commonSetup();
      loginRepository = MockLoginRepository();
      loginBloc = LoginBloc(loginRepository);
    });

    tearDown(() {
      loginBloc?.close();
    });

    test('after initialization bloc state is correct', () {
      expect(VerifyEmailReady(), loginBloc.state);
    });

    test('after closing bloc does not emit any states', () {
      expectLater(loginBloc, emitsInOrder([VerifyEmailReady(), emitsDone]));

      loginBloc.close();
    });

    test('after prepare verify, VerifyEmailReady state should be emited', () {

      final expectedResponse = [
        VerifyEmailReady()
      ];

      expectLater(loginBloc, emitsInOrder(expectedResponse));

      loginBloc.add(PrepareVerifyEmail());
    });

    test('after verifyEmail error, LoginError state should be emited', () {

      String testEmail = "test@test.com";
      final expectedResponse = [
        VerifyEmailReady(),
        VerifyEmailInProgress(testEmail),
        LoginError("error")
      ];

      when(loginRepository.verifyEmail(testEmail)).thenThrow(ErrorResult(Result.fail("error", "")));

      expectLater(loginBloc, emitsInOrder(expectedResponse));

      loginBloc.add(VerifyEmail(testEmail));
    });

    test('after verifyEmail exist, VerifyEmailDone state should be emited with existingEmail true', () {

      String testEmail = "test@test.com";
      UserEmailModel userEmailModel = UserEmailModel()
        ..email = testEmail
        ..exist = true;
      final expectedResponse = [
        VerifyEmailReady(),
        VerifyEmailInProgress(testEmail),
        VerifyEmailDone(testEmail, true)
      ];

      when(loginRepository.verifyEmail(testEmail)).thenAnswer((_) => Future.value(userEmailModel));

      expectLater(loginBloc, emitsInOrder(expectedResponse));

      loginBloc.add(VerifyEmail(testEmail));
    });

    test('after verifyEmail not exist, VerifyEmailDone state should be emited with existingEmail false', () {

      String testEmail = "test@test.com";
      UserEmailModel userEmailModel = UserEmailModel()
        ..email = testEmail
        ..exist = false;
      final expectedResponse = [
        VerifyEmailReady(),
        VerifyEmailInProgress(testEmail),
        VerifyEmailDone(testEmail, false)
      ];

      when(loginRepository.verifyEmail(testEmail)).thenAnswer((_) => Future.value(userEmailModel));

      expectLater(loginBloc, emitsInOrder(expectedResponse));

      loginBloc.add(VerifyEmail(testEmail));
    });

    test('after loginUser fail, LoginError state should be emited', () {

      String testEmail = "test@test.com";
      final expectedResponse = [
        VerifyEmailReady(),
        LoginError("error", message: {})
      ];

      when(loginRepository.login(testEmail, "")).thenThrow(ErrorResult(Result.fail("error", "")));

      expectLater(loginBloc, emitsInOrder(expectedResponse));

      loginBloc.add(LoginUser(testEmail, ""));
    });

    test('after loginUser success, LoginDone state should be emited', () {

      String testEmail = "test@test.com";
      TokenModel tokenModel = TokenModel();
      final expectedResponse = [
        VerifyEmailReady(),
        LoginDone()
      ];

      when(loginRepository.login(testEmail, "")).thenAnswer((realInvocation) => Future.value(tokenModel));

      expectLater(loginBloc, emitsInOrder(expectedResponse));

      loginBloc.add(LoginUser(testEmail, ""));
    });


    test('after registerUser fail, LoginError state should be emited', () {

      String testEmail = "test@test.com";
      final expectedResponse = [
        VerifyEmailReady(),
        LoginError("error")
      ];

      when(loginRepository.register(testEmail, "")).thenThrow(ErrorResult(Result.fail("error", "")));

      expectLater(loginBloc, emitsInOrder(expectedResponse));

      loginBloc.add(RegisterUser(testEmail, ""));
    });

    test('after registerUser success, LoginDone state should be emited', () {

      String testEmail = "test@test.com";
      TokenModel tokenModel = TokenModel();
      final expectedResponse = [
        VerifyEmailReady(),
        LoginDone()
      ];

      when(loginRepository.register(testEmail, "")).thenAnswer((realInvocation) => Future.value(tokenModel));

      expectLater(loginBloc, emitsInOrder(expectedResponse));

      loginBloc.add(RegisterUser(testEmail, ""));
    });
  });
}
