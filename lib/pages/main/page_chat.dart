import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/api.dart';
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
  bool _isLoading = true;

  List<Chat> chatList = [];

  @override
  void initState() {
    apiGetChatList().then((value) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? const CircularProgressIndicator()
          : Padding(
              padding: EdgeInsets.fromLTRB(0, Consts.marginPage, 0, Consts.marginPage),
              child: ListView(
                children: [
                  if (chatList.isNotEmpty) ...[
                    for (int i = 0; i < chatList.length; i++) ...[
                      item(chatList[i]),
                    ],
                  ] else ...[
                    SizedBox(
                      height: 500.h,
                    ),
                    Center(child: Text("등록된 채팅이 없습니다.")),
                  ]
                ],
              ),
            ),
    );
  }

  Widget item(Chat chat) {
    Widget status;

    bool isMyOwner = chat.ownerId == Meet.user.loginId;

    switch (chat.status) {
      case "W":
        status = Text("대기중", style: TextStyle(color: Colors.red));

        break;
      case "A":
        status = Text("거래중", style: TextStyle(color: Colors.blue));
        break;
      case "C":
        status = Text(isMyOwner ? "거절됨" : "거절함", style: TextStyle(color: Colors.red));
        break;
      default:
        status = Text("종료", style: TextStyle(color: Colors.grey));
        break;
    }

    return InkWell(
      onTap: () {
        if (chat.status == "C") {
          // 취소된
          Meet.alert(context, "알림", "취소된 거래입니다.");
        } else if (chat.status == "A") {
          Navigator.pushNamed(context, ROUTES.CHAT_EDIT);
        } else {
          // W : 대기중
          Navigator.pushNamed(context, ROUTES.CHAT_EDIT);
        }
      },
      //TODO : hover 효과 넣기
      child: Container(
        height: 150.h,
        width: double.infinity,
        decoration: ShapeDecoration(color: Colors.grey, shape: const RoundedRectangleBorder(), shadows: []),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
          child: Container(
            color: Colors.blue,
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
                          Text(chat.otherId, style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold)),
                          Text("오후 11:20", style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.normal))
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("마지막 대화", style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.normal)),
                          status,
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
    await API.callGetApi(
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
    );
  }
}
