class UserModel {
  final String username;
  final String firstName;
  final String lastName;

  const UserModel({
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  toJson() {
    return {
      "username": username,
      "firstName": firstName,
      "lastName": lastName,
    };
  }

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
        username: json['username'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        );
  }
}
