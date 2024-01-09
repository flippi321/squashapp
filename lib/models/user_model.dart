class UserModel {
  final String? id;
  final String username;
  final String firstName;
  final String lastName;

  const UserModel({
    this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  toJson() {
    return {
      "id": id,
      "username": username,
      "firstName": firstName,
      "lastName": lastName,
    };
  }

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
        id: json['id'] as String?,
        username: json['username'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        );
  }
}
