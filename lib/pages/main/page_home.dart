import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constants.dart';
import '../../common/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Consts.marginPage),
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ROUTES.LOGIN);
                },
                child: const Text("로그인"),
              ),
              SizedBox(
                height: 30.h,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ROUTES.JOIN);
                },
                child: const Text("회원가입"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
