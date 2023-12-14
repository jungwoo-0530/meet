import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constants.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, Consts.marginPage, 0, Consts.marginPage),
        child: ListView(
          children: [
            for (int i = 0; i < 10; i++) ...[
              InkWell(
                onTap: () {},
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
                                    Text("닉네임", style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold)),
                                    Text("오후 11:20", style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.normal))
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text("마지막 대화", style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.normal)),
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
              ),
            ],
          ],
        ),
      ),
    );
  }
}
