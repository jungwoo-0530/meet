import 'package:flutter/material.dart';

import '../../common/constants.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Consts.marginPage),
        child: Text("Chat"),
      ),
    );
  }
}
