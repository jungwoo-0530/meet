import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:ya_meet/common/common.dart';
import 'package:ya_meet/custom/sub_appbar.dart';

import '../../common/constants.dart';
import '../../common/meet.dart';
import 'do.dart';

class EditChatPage extends StatefulWidget {
  const EditChatPage({super.key, required this.arguments});

  final Map<String, dynamic>? arguments;

  @override
  State<EditChatPage> createState() => _EditChatPageState();
}

class _EditChatPageState extends State<EditChatPage> {
  bool _isLoading = false;

  final TextEditingController myEditingController = TextEditingController();
  final TextEditingController otherEditingController = TextEditingController();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  final ScrollController _scrollController = ScrollController();

  late Stream<QuerySnapshot> chatStream;

  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> streamSubscription;

  late ChatFireBase chatFireBase;

  late DocumentSnapshot lastSnapshot;

  final int _limit = 15;

  int messageCount = 15;

  @override
  void initState() {
    chatStream = fireStore
        .collection("chat_collection")
        .doc(widget.arguments?['chatRoomId'].toString())
        .collection("messages")
        .orderBy('createdTime')
        .limitToLast(messageCount)
        .snapshots();

    // chatFireBase = widget.arguments?['firebaseChat'] as ChatFireBase;

    _isLoading = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.position.atEdge) {
          bool isTop = _scrollController.position.pixels != 0;
          if (isTop) {
            chatStream = fireStore
                .collection("chat_collection")
                .doc(widget.arguments?['chatRoomId'].toString())
                .collection("messages")
                .orderBy('createdTime', descending: false)
                .limitToLast(messageCount + _limit)
                .snapshots();

            setState(() {});
          }
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    myEditingController.dispose();
    otherEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MeetSubAppBar(
        title: widget.arguments?['otherId'],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: chatStream,
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          List<MessageFireBase> result = [];
                          for (var doc in snapshot.data!.docs) {
                            result.add(MessageFireBase.fromSnapshot(doc));
                          }
                          messageCount = result.length;

                          updateReadYn();

                          return Stack(
                            children: [
                              GroupedListView(
                                elements: result,
                                groupBy: (element) => DateFormat('yyyy-MM-dd EEE', 'ko').format(element.createdTime),
                                reverse: true,
                                order: GroupedListOrder.DESC,
                                controller: _scrollController,
                                groupSeparatorBuilder: (String groupByValue) => Container(
                                  padding: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Divider(
                                        color: const Color(0xFFE2E2E2),
                                        thickness: 1.w,
                                        height: 0,
                                      )),
                                      Text(
                                        groupByValue,
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Expanded(
                                          child: Divider(
                                        color: const Color(0xFFE2E2E2),
                                        thickness: 1.w,
                                        height: 0,
                                      )),
                                    ],
                                  ),
                                ),
                                itemBuilder: (context, element) =>
                                    messageItem(element.sender == Meet.user.loginId ? true : false, element),
                              ),
                              /*if(_isNewMessage)...[
                          Positioned(child: Text("test"), bottom: 0, ),
                        ]*/
                            ],
                          );
                        } else {
                          return const Center(
                            child: Text("상대방에게 메시지를 보내보세요."),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Divider(color: const Color(0xFFE2E2E2), thickness: 1.w, height: 0),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    height: 70.h,
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(Consts.marginPage, 0, Consts.marginPage, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: myEditingController,
                            decoration: InputDecoration(
                              hintText: '메세지를 입력하세요.',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.r),
                                borderSide: const BorderSide(
                                  width: 0.1,
                                  style: BorderStyle.none,
                                ),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 70.h / 2),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            meetlog("메시지 전송");

                            fireStore
                                .collection("chat_collection")
                                .doc(widget.arguments?['chatRoomId'].toString())
                                .collection("messages")
                                .add({
                              'content': myEditingController.text,
                              'createdTime': DateTime.now(),
                              'sender': Meet.user.loginId,
                              'readYn': "N",
                            }).then((value) {
                              fireStore
                                  .collection("chat_collection")
                                  .doc(widget.arguments?['chatRoomId'].toString())
                                  .update({
                                'lastMessage': myEditingController.text,
                                'lastUpdateTime': DateTime.now(),
                              });
                              myEditingController.text = "";
                            });
                          },
                          icon: const Icon(Icons.send),
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  void updateReadYn() {
    fireStore
        .collection('chat_collection')
        .doc(widget.arguments?['chatRoomId'].toString())
        .collection('messages')
        .where('sender', isNotEqualTo: Meet.user.loginId)
        .where('readYn', isEqualTo: 'N')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        fireStore
            .collection('chat_collection')
            .doc(widget.arguments?['chatRoomId'].toString())
            .collection('messages')
            .doc(doc.id)
            .update({
          'readYn': 'Y',
        });
      }
    });
  }
}

Widget messageItem(bool isMine, MessageFireBase message) {
  return Padding(
    padding: EdgeInsets.fromLTRB(15.w, 5.h, 15.w, 5.h),
    child: Row(
      mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMine) ...[
          Icon(Icons.account_circle_rounded, size: 80.r),
          SizedBox(
            width: 10.w,
          ),
        ],
        Column(
          crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isMine) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (message.readYn == "N") ...[
                        Text(
                          "안 읽음",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                      Text(
                        DateFormat('aa hh:mm', 'ko').format(message.createdTime),
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
                Container(
                  width: 350.w,
                  padding: EdgeInsets.all(10.r),
                  decoration: ShapeDecoration(
                    color: Colors.cyanAccent,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFFE2E2E2)),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                    maxLines: 99,
                  ),
                ),
                if (!isMine) ...[
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    DateFormat('aa hh:mm', 'ko').format(message.createdTime),
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.normal),
                  ),
                ]
              ],
            ),
          ],
        ),
        /*if (isMine) ...[
          SizedBox(
            width: 10.w,
          ),
          Icon(Icons.account_circle_rounded, size: 80.r),
        ],*/
      ],
    ),
  );
}
