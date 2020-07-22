
import 'package:base/screens/login/model/user_email_model.dart';

abstract class LoginRepository {
  Future<UserEmailModel> verifyEmail(String email);
  Future<void> login(String email, String password);
  Future<void> register(String email, String password);
}
