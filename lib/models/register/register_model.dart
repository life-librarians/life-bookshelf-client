class Register {
  final String email;
  final String password;

  Register({
    required this.email,
    required this.password,
  });

  // JSON으로부터 객체 생성
  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  // 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}