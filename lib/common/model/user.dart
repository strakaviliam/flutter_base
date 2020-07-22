
class User {
  String username;
  String name;
  String email;
  String phone;
  bool emailVerified;
  bool phoneVerified;
  bool passwordGenerated;
  bool isTest;

  User.fromMap(Map<String, dynamic> map) {
    username = map["username"];
    name = map["name"];
    email = map["email"];
    phone = map["phone"];
    emailVerified = map["emailVerified"];
    phoneVerified = map["phoneVerified"];
    passwordGenerated = map["passwordGenerated"];
    isTest = map["isTest"];
  }

  @override
  String toString() => 'User { '
      'username: $username, '
      'name: $name, '
      'email: $email, '
      'phone: $phone, '
      'emailVerified: $emailVerified, '
      'phoneVerified: $phoneVerified, '
      'passwordGenerated: $passwordGenerated, '
      'isTest: $isTest }';
}
