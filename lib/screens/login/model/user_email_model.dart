
import 'package:equatable/equatable.dart';

class UserEmailModel extends Equatable {
  String email;
  bool exist;

  UserEmailModel();

  UserEmailModel.fromMap(Map<String, dynamic> map) {
    email = map["email"];
    exist = map["exist"];
  }

  @override
  String toString() => 'UserEmailModel { '
      'email: $email, '
      'exist: $exist }';

  @override
  List<Object> get props => [email, exist];
}
