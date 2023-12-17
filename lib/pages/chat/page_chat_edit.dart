import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ya_meet/common/common.dart';
import 'package:ya_meet/custom/sub_appbar.dart';

import '../../common/constants.dart';

class EditChatPage extends StatefulWidget {
  const EditChatPage({super.key});

  @override
  State<EditChatPage> createState() => _EditChatPageState();
}

class _EditChatPageState extends State<EditChatPage> {
  final TextEditingController myEditingController = TextEditingController();
  final TextEditingController otherEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MeetSubAppBar(
        title: "ㅇㅇ님",
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  if (index % 2 == 0) {
                    return messageItem(isMine: false);
                  } else {
                    return messageItem();
                  }
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              height: 90.h,
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: myEditingController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '(상대방) 메세지를 입력하세요.',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      meetlog("상대방 메시지 전송");
                    },
                    icon: Icon(Icons.send),
                  )
                ],
              ),
            ),
            Container(
              height: 90.h,
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: myEditingController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '(내) 메세지를 입력하세요.',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      meetlog("내 메시지 전송");
                    },
                    icon: Icon(Icons.send),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget messageItem({bool isMine = true}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(Consts.marginPage, 5.h, Consts.marginPage, 0),
    child: Container(
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
              Text("오후 11:20"),
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
                  "메세지1111111111111111111111111111111111111",
                  style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                  maxLines: 99,
                ),
              ),
            ],
          ),
          if (isMine) ...[
            SizedBox(
              width: 10.w,
            ),
            Icon(Icons.account_circle_rounded, size: 80.r),
          ],
        ],
      ),
    ),
  );
}
