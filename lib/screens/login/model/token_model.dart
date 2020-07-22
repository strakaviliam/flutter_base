import 'package:equatable/equatable.dart';

class TokenModel extends Equatable {
  String token;
  DateTime tokenExpire;

  TokenModel();

  TokenModel.fromMap(Map<String, dynamic> map) {
    int expire = map["expire"] - 10;
    token = map["token"];
    tokenExpire = DateTime.now().add(Duration(seconds: expire));
  }

  @override
  String toString() => 'TokenModel { '
      'token: $token, '
      'tokenExpire: $tokenExpire }';

  @override
  List<Object> get props => [token, tokenExpire];
}
