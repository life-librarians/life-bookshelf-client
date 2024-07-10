class Login {
  final String accessToken;

  Login({required this.accessToken});

  // JSON에서 객체를 생성
  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      accessToken: json['accessToken'] as String,
    );
  }
}