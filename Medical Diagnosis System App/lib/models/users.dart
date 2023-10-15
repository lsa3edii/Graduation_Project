class UserModel {
  final String email;

  UserModel({
    required this.email,
  });
  factory UserModel.fromJson(jsonData) {
    return UserModel(email: jsonData['email']);
  }
}
