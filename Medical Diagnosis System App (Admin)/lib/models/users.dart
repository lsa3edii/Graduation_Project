class UserModel {
  final String email;

  UserModel({required this.email});

  factory UserModel.fromJson(jsonData) {
    return UserModel(email: jsonData['email']);
  }
}

final class UserFields {
  static const String email = 'email';
  static const String password = 'password';
  static const String uid = 'uid';
  static const String userRole = 'userRole';
  static const String username = 'username';
}
