
class OnUserModel {
  String name;
  String bornedAt;
  String gender;
  bool hasChildren;
  String occupation;
  String education_level;
  String marital_status;


  OnUserModel({
    required this.name,
    required this.bornedAt,
    required this.gender,
    required this.hasChildren,
    required this.occupation,
    required this.education_level,
    required this.marital_status,
  });

  // JSON 생성을 위한 메서드
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bornedAt': bornedAt,
      'gender': gender,
      'hasChildren': hasChildren,
      'occupation': occupation,
      'education_level': education_level,
      'marital_status': marital_status,
    };
  }
}
