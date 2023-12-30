import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../common/api.dart';
import '../../common/common.dart';
import '../../common/constants.dart';
import '../../common/meet.dart';
import '../../common/routes.dart';
import '../../common/urls.dart';
import '../chat/do.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isLoading = false;

  List<Chat> chatList = [];

  List<ChatFireBase> chatFireBaseList = [];

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  late  Stream<QuerySnapshot> chatStream;



  @override
  void initState() {
    chatStream = fireStore.collection("chat_collection").where('users', arrayContains: Meet.user.loginId).orderBy('lastUpdateTime', descending: true).snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return SafeArea(
      child: _isLoading
          ? const CircularProgressIndicator()
          : Padding(
              padding: EdgeInsets.fromLTRB(0, Consts.marginPage, 0, Consts.marginPage),
              child: StreamBuilder<QuerySnapshot>( stream: chatStream, builder: (context, snapshot) {
                if(snapshot.hasData){
                  final List<ChatFireBase> result = [];
                  for(var doc in snapshot.data!.docs){
                    result.add(ChatFireBase.fromSnapshot(doc));
                  }
                  return ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (BuildContext context, int index) {
                      return item(result[index]);
                    },
                  );
                }else{
                  return const Center(child: CircularProgressIndicator());
                }
              },),
            ),
    );
  }

  Widget item(ChatFireBase chat) {
    Widget status;

    bool isMyOwner = chat.createdUser == Meet.user.loginId;

    switch (chat.status) {
      case "W":
        status = const Text("대기중", style: TextStyle(color: Colors.red));
        break;
      case "A":
        status = const Text("거래중", style: TextStyle(color: Colors.blue));
        break;
      case "C":
        status = Text(isMyOwner ? "거절됨" : "거절함", style: const TextStyle(color: Colors.red));
        break;
      default:
        status = const Text("종료", style: TextStyle(color: Colors.grey));
        break;
    }

    return InkWell(
      onTap: () {
        if (chat.status == "C") {
          // 취소된
          Meet.alert(context, "알림", "취소된 거래입니다.");
        } else if (chat.status == "A") {
          Navigator.pushNamed(context, ROUTES.CHAT_EDIT, arguments: {'chatRoomId': chat.chatRoomId, 'firebaseChat': chat});
        } else {
          // W : 대기중
          Navigator.pushNamed(context, ROUTES.CHAT_EDIT, arguments: {'chatRoomId': chat.chatRoomId, 'firebaseChat': chat});
        }
      },
      //TODO : hover 효과 넣기
      child: Container(
        height: 150.h,
        width: double.infinity,
        decoration: const ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(), shadows: []),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  // side: BorderSide(width: 2.w, color: widget.borderColor),
                  borderRadius: BorderRadius.circular(32.r),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0x14000000),
                    blurRadius: 32.r,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  )
                ]),
            child: Row(
              children: [
                Icon(
                  Icons.adb_rounded,
                  size: 100.r,
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(chat.users.firstWhere((element){
                            return element != Meet.user.loginId;
                          }),
                            style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd aa hh:mm', 'ko').format(chat.lastUpdateTime),
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 5,
                            child: Text(
                                chat.lastMessage,
                                style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.normal,
                                ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(child: status,),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> apiGetChatList() async {

    FirebaseFirestore fireStore = FirebaseFirestore.instance;



    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await fireStore.collection('chat_collection')
      .where('users', arrayContains: Meet.user.loginId)
      .orderBy('lastUpdateTime', descending: true)
      .get();


    List<ChatFireBase> result = [];

    for (var element in querySnapshot.docs) {
      ChatFireBase a = ChatFireBase.fromJson(element.data());
      a.chatRoomId = element.id;
      result.add(a);
    }

    chatFireBaseList.addAll(result);


/*    await API.callGetApi(
      URLS.getChatList,
      parameters: {
        "id": Meet.user.loginId,
      },
      onSuccess: (successData) {
        if (successData['status'] == "200") {
          if (successData['count'] > 0) {
            List chatTempList = successData['data'];
            List<Chat> generatedList = [];
            for (var element in chatTempList) {
              generatedList.add(Chat.fromJson(element));
            }

            chatList.addAll(generatedList);
          }
        } else {}
      },
      onFail: (failData) {},
    );*/
  }
}
