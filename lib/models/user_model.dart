class User {
  final int? id;
  final String? username;
  final String? email;
  final String? password;
  final String? token;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      token: json['token'],
    );
  }
}
