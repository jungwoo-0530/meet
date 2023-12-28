import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/api.dart';
import '../../common/common.dart';
import '../../common/constants.dart';
import '../../common/meet.dart';
import '../../common/urls.dart';
import '../../custom/meet_button.dart';
import '../../custom/sub_appbar.dart';
import 'do.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;

  late Member member;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _handPhoneController = TextEditingController();

  File? profileImageFile;

  bool _isNameChange = false;
  bool _checkDuplicateName = true;

  @override
  void initState() {
    getMember().then(
      (value) => setState(() {
        _isLoading = false;
      }),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MeetSubAppBar(
        title: '프로필',
        actions: [
          InkWell(
            onTap: () {
              meetlog("수정");
              updateMember();
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  "수정",
                  style: TextStyle(fontSize: 30.sp, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: Consts.marginPage),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 80.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.withOpacity(0.2),
                                    ),
                                    child: Icon(Icons.people, size: 180.r),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () async {
                                        meetlog("프로필 사진 변경");
                                        if (await Meet.permissionPhotosRequest() == false) {
                                          return;
                                        }

                                        final ImagePicker picker = ImagePicker();
                                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                        if (image == null) return;
                                        setState(() {
                                          profileImageFile = null;
                                          // photo = "";
                                          profileImageFile = File(image.path);
                                        });
                                      },
                                      child: Container(
                                        width: 60.r,
                                        height: 60.r,
                                        decoration: ShapeDecoration(
                                          shape: const OvalBorder(),
                                          color: Colors.white,
                                          shadows: [
                                            BoxShadow(
                                              color: const Color(0x14000000),
                                              blurRadius: 4.r,
                                              offset: const Offset(0, 2),
                                              spreadRadius: 1,
                                            )
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 45.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            "아이디",
                            style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Container(
                            height: 90.h,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 30.w),
                            decoration: ShapeDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFFE2E2E2)),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: TextField(
                              autofocus: false,
                              canRequestFocus: true,
                              enabled: false,
                              keyboardType: TextInputType.name,
                              controller: _idController,
                              maxLength: 20,
                              style: TextStyle(
                                color: const Color(0xff222222),
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w400,
                                decorationThickness: 0,
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: "아이디를 입력해주세요.",
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                counterText: "",
                                hintStyle: TextStyle(
                                  color: const Color(0xff999999),
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                isCollapsed: true,
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              onSubmitted: (value) {},
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            "비밀번호",
                            style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Container(
                            height: 90.h,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 30.w),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFFE2E2E2)),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: TextField(
                              controller: _passwordController,
                              autofocus: false,
                              canRequestFocus: true,
                              enabled: true,
                              keyboardType: TextInputType.name,
                              maxLength: 20,
                              style: TextStyle(
                                color: const Color(0xff222222),
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w400,
                                decorationThickness: 0,
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: "비밀번호를 입력해 주세요.",
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                counterText: "",
                                hintStyle: TextStyle(
                                  color: const Color(0xff999999),
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                isCollapsed: true,
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              onSubmitted: (value) {},
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            "이름",
                            style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 5,
                                  fit: FlexFit.tight,
                                  child: Container(
                                    height: 90.h,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(width: 1, color: Color(0xFFE2E2E2)),
                                        borderRadius: BorderRadius.circular(16.r),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _nameController,
                                      autofocus: false,
                                      canRequestFocus: true,
                                      enabled: true,
                                      keyboardType: TextInputType.name,
                                      maxLength: 20,
                                      style: TextStyle(
                                        color: const Color(0xff222222),
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w400,
                                        decorationThickness: 0,
                                      ),
                                      textAlignVertical: TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        hintText: "이름을 입력해 주세요.",
                                        border: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        counterText: "",
                                        hintStyle: TextStyle(
                                          color: const Color(0xff999999),
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        isCollapsed: true,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _checkDuplicateName = false;
                                          if (value == member.name) {
                                            _isNameChange = false;
                                            _checkDuplicateName = true;
                                          } else {
                                            _isNameChange = true;
                                          }
                                        });
                                      },
                                      onSubmitted: (value) {},
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: MeetButton(
                                    onPressed: () {
                                      if (_nameController.text.isEmpty) {
                                        Meet.alert(context, "알림", "이름을 입력해주세요.");
                                        return;
                                      }

                                      if (_nameController.text == member.name) {
                                        // 기존과 같은 이름일 경우 스킵
                                        return;
                                      }

                                      API.callGetApi(
                                        URLS.checkName,
                                        parameters: {
                                          "name": _nameController.text,
                                        },
                                        onSuccess: (successData) {
                                          if (successData['status'] == '200') {
                                            _checkDuplicateName = true;
                                            Meet.alert(context, "알림", successData['message']);
                                          } else {
                                            Meet.alert(context, "알림", successData['message']);
                                          }
                                        },
                                        onFail: (errorData) {},
                                      );
                                    },
                                    title: "중복확인",
                                    height: 90.h,
                                    width: double.infinity,
                                    radius: 10.r,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            "이메일",
                            style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Container(
                            height: 90.h,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 30.w),
                            decoration: ShapeDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFFE2E2E2)),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: TextField(
                              autofocus: false,
                              canRequestFocus: true,
                              enabled: false,
                              controller: _emailController,
                              keyboardType: TextInputType.name,
                              maxLength: 20,
                              style: TextStyle(
                                color: const Color(0xff222222),
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w400,
                                decorationThickness: 0,
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: "이메일을 입력해 주세요.",
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                counterText: "",
                                hintStyle: TextStyle(
                                  color: const Color(0xff999999),
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                isCollapsed: true,
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              onSubmitted: (value) {},
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            "핸드폰",
                            style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Container(
                            height: 90.h,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 30.w),
                            decoration: ShapeDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: Color(0xFFE2E2E2)),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: TextField(
                              autofocus: false,
                              canRequestFocus: true,
                              enabled: false,
                              controller: _handPhoneController,
                              keyboardType: TextInputType.name,
                              maxLength: 20,
                              style: TextStyle(
                                color: const Color(0xff222222),
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w400,
                                decorationThickness: 0,
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: "핸드폰을 입력해 주세요.",
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                counterText: "",
                                hintStyle: TextStyle(
                                  color: const Color(0xff999999),
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                isCollapsed: true,
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              onSubmitted: (value) {},
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> getMember() async {
    await API.callGetApi(
      URLS.getMemberInfo,
      parameters: {
        "id": Meet.user.userSeq.toString(),
      },
      onSuccess: (successData) {
        if (successData['status'] == '200') {
          member = Member.fromJson(successData['data']);

          _idController.text = successData['data']['loginId'];
          _emailController.text = successData['data']['email'];
          _handPhoneController.text = successData['data']['telephone'];

          _nameController.text = successData['data']['name'];

          setState(() {});
          // Meet.alert(context, "알림", successData['message']);
        } else {
          Meet.alert(context, "알림", successData['message']);
        }
      },
      onFail: (errorData) {},
    );
  }

  Future<void> updateMember() async {
    if (_checkDuplicateName == false) {
      Meet.alert(context, "알림", "이름 중복확인을 해주세요.");
      return;
    }

    String password = _passwordController.text;

    await API.callPostApi(
      URLS.updateMemberInfo,
      parameters: {
        "id": member.memberId.toString(),
        "name": _nameController.text,
        "password": password,
      },
      onSuccess: (successData) {
        if (successData['status'] == '200') {
          Meet.alert(context, "알림", "수정되었습니다.").then((value) {
            Navigator.pop(context);
          });

          setState(() {});

          // Meet.alert(context, "알림", successData['message']);
        } else {
          Meet.alert(context, "알림", successData['message']);
        }
      },
      onFail: (errorData) {},
    );
  }
}
