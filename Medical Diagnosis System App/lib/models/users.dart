class UserModel {
  final String email;

  UserModel({
    required this.email,
  });
  factory UserModel.fromJson(jsonData) {
    return UserModel(email: jsonData['email']);
  }
}

final class UserFields {
  static String email = 'email';
  static String password = 'password';
  static String uid = 'uid';
  static String userRole = 'userRole';
  static String username = 'username';
}
