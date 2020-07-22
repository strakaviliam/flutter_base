part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PrepareVerifyEmail extends LoginEvent {

  @override
  String toString() => 'PrepareVerifyEmail { }';
}

class VerifyEmail extends LoginEvent {

  final String email;

  VerifyEmail(this.email);

  @override
  String toString() => 'VerifyEmail { email: $email }';

  @override
  List<Object> get props => [email];
}

class LoginUser extends LoginEvent {

  final String email;
  final String password;

  LoginUser(this.email, this.password);

  @override
  String toString() => 'LoginUser { email: $email, password: **** }';

  @override
  List<Object> get props => [email, password];
}

class RegisterUser extends LoginEvent {

  final String email;
  final String password;

  RegisterUser(this.email, this.password);

  @override
  String toString() => 'RegisterUser { email: $email, password: **** }';

  @override
  List<Object> get props => [email, password];
}
