import 'package:cloud_firestore/cloud_firestore.dart';

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
  String lastUpdateTime;

  List<User> users;
  List<MessageFireBase> messages;

  String status;

  ChatFireBase({
    required this.lastMessage,
    required this.lastUpdateTime,
    required this.users,
    required this.messages,
    required this.status,
  });

  factory ChatFireBase.fromJson(Map<String, dynamic> json) {
    try {
      return ChatFireBase(
        lastMessage: json['lastMessage'] ?? "",
        lastUpdateTime: json['lastUpdateTime'] ?? "",
        status: json['status'] ?? "",
        users: json['users'].map((user) => User.fromJson(user)).toList(),
        messages: json['messages'].map((message) => MessageFireBase.fromJson(message)).toList(),
      );
    } catch (e) {
      return ChatFireBase(
        lastMessage: "",
        lastUpdateTime: "",
        status: "",
        users: [],
        messages: [],
      );
    }
  }

  Map<String, dynamic> toJson() => {
        'lastMessage': lastMessage,
        'lastUpdateTime': lastUpdateTime,
        'status': status,
        'users': users.map((user) => user.toJson()).toList(),
        'messages': messages.map((message) => message.toJson()).toList(),
      };

  factory ChatFireBase.fromSnapshot(DocumentSnapshot snapshot) {
    final List<MessageFireBase> messages = [];
    final messageSnapshots = List<Map>.from(snapshot['messages'] as List);

    final List<User> users = [];
    final userSnapshots = List<Map>.from(snapshot['users'] as List);

    for (var e in messageSnapshots) {
      messages.add(MessageFireBase.fromJson(e as Map<String, dynamic>));
    }

    for (var e in userSnapshots) {
      users.add(User.fromJson(e as Map<String, dynamic>));
    }

    return ChatFireBase(
      lastMessage: snapshot['lastMessage'] ?? "",
      lastUpdateTime: snapshot['lastUpdateTime'] ?? "",
      status: snapshot['status'] ?? "",
      messages: messages,
      users: users,
    );
  }
}

class MessageFireBase {
  int index;
  String content;
  String sender;
  String createdTime;

  MessageFireBase({
    required this.index,
    required this.content,
    required this.sender,
    required this.createdTime,
  });

  factory MessageFireBase.fromJson(Map<String, dynamic> json) {
    try {
      return MessageFireBase(
        index: json['index'] ?? -1,
        content: json['content'] ?? "",
        sender: json['sender'] ?? "",
        createdTime: json['createdTime'] ?? "",
      );
    } catch (e) {
      return MessageFireBase(
        index: -1,
        content: "",
        sender: "",
        createdTime: "",
      );
    }
  }

  Map<String, dynamic> toJson() => {
        'index': index,
        'content': content,
        'sender': sender,
        'createdTime': createdTime,
      };
}
