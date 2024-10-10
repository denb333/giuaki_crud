class UserModel {

  String username;
  String email;

  UserModel({
    required this.username,
    required this.email,
  });

  // Phương thức để chuyển đổi từ Map sang UserModel
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      username: data['username'] ?? '',
      email: data['email'] ?? '',
    );
  }

  // Phương thức để chuyển đổi từ UserModel sang Map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
    };
  }
}
