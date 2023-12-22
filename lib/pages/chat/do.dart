class Chat {
  int chatId = -1;
  int locationId = -1;
  String ownerId = "";
  String otherId = "";
  String useYn = "";
  String status = "";

  Chat.empty();

  Chat({
    required this.chatId,
    required this.locationId,
    required this.ownerId,
    required this.otherId,
    required this.useYn,
    required this.status,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    try {
      return Chat(
        chatId: json['id'] ?? -1,
        locationId: json['locationId'] ?? -1,
        ownerId: json['ownerId'] ?? "",
        otherId: json['otherId'] ?? "",
        useYn: json['useYn'] ?? "",
        status: json['status'] ?? "",
      );
    } catch (e) {
      return Chat.empty();
    }
  }
}
