class Member {
  int memberId = -1;
  String name = "";
  String loginId = "";
  String email = "";
  String profileImg = "";
  String telephone = "";

  Member.empty();

  Member({
    required this.memberId,
    required this.name,
    required this.loginId,
    required this.email,
    required this.profileImg,
    required this.telephone,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    try {
      return Member(
        memberId: json['id'] ?? -1,
        name: json['name'] ?? "",
        loginId: json['loginId'] ?? "",
        email: json['email'] ?? "",
        profileImg: json['imgUri'] ?? "",
        telephone: json['telephone'] ?? "",
      );
    } catch (e) {
      return Member.empty();
    }
  }
}
