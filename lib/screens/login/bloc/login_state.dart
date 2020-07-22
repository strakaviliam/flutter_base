part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class VerifyEmailReady extends LoginState {

  @override
  String toString() => 'VerifyEmailReady { }';
}

class VerifyEmailInProgress extends LoginState {

  final String email;

  VerifyEmailInProgress(this.email);

  @override
  String toString() => 'VerifyEmailInProgress { email: $email }';

  @override
  List<Object> get props => [email];
}

class LoginError extends LoginState {
  final String error;
  final Map<String, String> message;
  final String key;

  LoginError(this.error, {this.message, this.key = ""});

  @override
  String toString() => 'LoginError { error: $error, message: $message }';

  @override
  List<Object> get props => [error, message, key];
}

class VerifyEmailDone extends LoginState {

  final String email;
  final bool existingEmail;

  VerifyEmailDone(this.email, this.existingEmail);

  @override
  String toString() => 'VerifyEmailDone { email: $email, existingEmail: $existingEmail }';

  @override
  List<Object> get props => [email, existingEmail];
}

class LoginDone extends LoginState {

  @override
  String toString() => 'LoginDone { }';
}
