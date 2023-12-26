import 'package:cloud_firestore/cloud_firestore.dart';

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


class ChatFireBase{
  String lastMessage;
  String lastUpdateTime;
  List<MessageFireBase> messages;

  ChatFireBase({
    required this.lastMessage,
    required this.lastUpdateTime,
    required this.messages
  });

  factory ChatFireBase.fromJson(Map<String, dynamic> json) {
    try {
      return ChatFireBase(
        lastMessage: json['lastMessage'] ?? "",
        lastUpdateTime: json['lastUpdateTime'] ?? "",
        messages: json['messages'].map((message) => MessageFireBase.fromJson(message)).toList(),
      );
    } catch (e) {
      return ChatFireBase(
        lastMessage: "",
        lastUpdateTime: "",
        messages: [],
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'lastMessage': lastMessage,
    'lastUpdateTime': lastUpdateTime,
    'messages': messages.map((message) => message.toJson()).toList(),
  };

  factory ChatFireBase.fromSnapshot(DocumentSnapshot snapshot) {

    final List<MessageFireBase> messages = [];
    final messageSnapshots = List<Map>.from(snapshot['messages'] as List);

    for(var e in messageSnapshots){
      messages.add(MessageFireBase.fromJson(e as Map<String, dynamic>));
    }

    return ChatFireBase(
      lastMessage: snapshot['lastMessage'] ?? "",
      lastUpdateTime: snapshot['lastUpdateTime'] ?? "",
      messages: messages,
    );
  }
}

class MessageFireBase {
  String content;
  String sender;
  String createdTime;

  MessageFireBase({
    required this.content,
    required this.sender,
    required this.createdTime,
  });

  factory MessageFireBase.fromJson(Map<String, dynamic> json) {
    try {
      return MessageFireBase(
        content: json['content'] ?? "",
        sender: json['sender'] ?? "",
        createdTime: json['createdTime'] ?? "",
      );
    } catch (e) {
      return MessageFireBase(
        content: "",
        sender: "",
        createdTime: "",
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'content': content,
    'sender': sender,
    'createdTime': createdTime,
  };

}