
class OnUserModel {
  String name;
  String bornedAt;
  String gender;
  bool hasChildren;

  OnUserModel({
    required this.name,
    required this.bornedAt,
    required this.gender,
    required this.hasChildren,
  });

  // JSON 생성을 위한 메서드
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bornedAt': bornedAt,
      'gender': gender,
      'hasChildren': hasChildren,
    };
  }
}
