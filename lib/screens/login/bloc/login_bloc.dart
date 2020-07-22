import 'dart:async';
import 'package:base/screens/login/model/user_email_model.dart';
import 'package:base/screens/login/repository/login_repository.dart';
import 'package:base/tools/api/result.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final LoginRepository repository;

  LoginBloc(this.repository) : super(VerifyEmailReady());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is PrepareVerifyEmail) {
      yield* _mapPrepareVerifyEmailToState();
    } else if (event is VerifyEmail) {
      yield* _mapVerifyEmailToState(event);
    } else if (event is LoginUser) {
      yield* _mapLoginUserToState(event);
    } else if (event is RegisterUser) {
      yield* _mapRegisterUserToState(event);
    }
  }

  Stream<LoginState> _mapPrepareVerifyEmailToState() async* {
    yield VerifyEmailReady();
  }

  Stream<LoginState> _mapVerifyEmailToState(VerifyEmail event) async* {
    if (event.email.isEmpty) {
      return;
    }
    yield VerifyEmailInProgress(event.email);
    try {
      UserEmailModel userEmailModel = await repository.verifyEmail(event.email);
      if (state is VerifyEmailInProgress && (state as VerifyEmailInProgress).email == event.email) {
        yield VerifyEmailDone(userEmailModel.email, userEmailModel.exist);
      }
    } on ErrorResult catch (ex) {
      yield LoginError(ex.result.error, key: ex.result.key);
    }
  }

  Stream<LoginState> _mapLoginUserToState(LoginUser event) async* {
    try {
      await repository.login(event.email, event.password);
      yield LoginDone();
    } on ErrorResult catch (ex) {
      yield LoginError(ex.result.error, message: ex.result.message, key: ex.result.key);
    }
  }

  Stream<LoginState> _mapRegisterUserToState(RegisterUser event) async* {
    try {
      await repository.register(event.email, event.password);
      yield LoginDone();
    } on ErrorResult catch (ex) {
      yield LoginError(ex.result.error, key: ex.result.key);
    }
  }
}
