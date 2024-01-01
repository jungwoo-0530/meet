import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/common.dart';

class User {
  String id = "";

  User.empty();

  User({required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['loginId'] ?? "",
      );
    } catch (e) {
      return User(
        id: "",
      );
    }
  }

  Map<String, dynamic> toJson() => {
        'loginId': id,
      };
}

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

class ChatFireBase {
  String lastMessage;
  DateTime lastUpdateTime;
  String status;
  String createdUser;
  List<String> users;

  List<MessageFireBase>? messages;

  String? chatRoomId;

  String useYn;

  ChatFireBase({
    required this.lastMessage,
    required this.lastUpdateTime,
    required this.users,
    required this.status,
    required this.createdUser,
    this.messages,
    this.chatRoomId,
    required this.useYn,
  });

  factory ChatFireBase.fromJson(Map<String, dynamic> json) {
    try {

      meetlog(json['messages'].toString());

      return ChatFireBase(
        lastMessage: json['lastMessage'] ?? "",
        lastUpdateTime: json['lastUpdateTime'].toDate(),
        status: json['status'] ?? "",
        createdUser: json['createdUser'] ?? "",
        users: List<String>.from(json['users'] as List),
        messages: json['messages'].map((message) => MessageFireBase.fromJson(message)).toList(),
        useYn: json['useYn'] ?? "",
      );
    } catch (e) {
      meetlog(e.toString());
      return ChatFireBase(
        lastMessage: "",
        lastUpdateTime: DateTime.now(),
        status: "",
        createdUser: "",
        users: [],
        messages: [],
        useYn: "",
      );
    }
  }

  Map<String, dynamic> toJson() => {
        'lastMessage': lastMessage,
        'lastUpdateTime': lastUpdateTime,
        'status': status,
        'users': users.map((user) => user).toList(),
        'createdUser': createdUser,
        'useYn': useYn,
      };

  factory ChatFireBase.fromSnapshot(DocumentSnapshot snapshot) {
    final List<String> users = [];
    final userSnapshots = List<String>.from(snapshot['users'] as List);



    for (var e in userSnapshots) {
      users.add(e ?? "");
      // users.add(User.fromJson(e as Map<String, dynamic>));
    }

    return ChatFireBase(
      lastMessage: snapshot['lastMessage'] ?? "",
      lastUpdateTime: snapshot['lastUpdateTime'].toDate() ?? DateTime.now(),
      status: snapshot['status'] ?? "",
      createdUser: snapshot['createdUser'] ?? "",
      users: users,
      chatRoomId: snapshot.id,
      useYn: snapshot['useYn'] ?? "",
    );
  }
}

class MessageFireBase {
  String content;
  String sender;
  DateTime createdTime;
  String readYn;

  MessageFireBase({
    required this.content,
    required this.sender,
    required this.createdTime,
    required this.readYn,
  });

  factory MessageFireBase.fromJson(Map<String, dynamic> json) {
    try {
      return MessageFireBase(
        content: json['content'] ?? "",
        sender: json['sender'] ?? "",
        createdTime: json['createdTime'].toDate(),
        readYn: json['readYn'].toDate(),
      );
    } catch (e) {
      return MessageFireBase(
        content: "",
        sender: "",
        createdTime: DateTime.now(),
        readYn: "",
      );
    }
  }

  Map<String, dynamic> toJson() => {
        'content': content,
        'sender': sender,
        'createdTime': createdTime,
        'readYn': readYn,
      };


  factory MessageFireBase.fromSnapshot(DocumentSnapshot snapshot) {

    return MessageFireBase(
      content: snapshot['content'] ?? "",
      sender: snapshot['sender'] ?? "",
      createdTime: snapshot['createdTime'].toDate() ?? DateTime.now(),
      readYn: snapshot['readYn'] ?? "",
    );
  }
}
