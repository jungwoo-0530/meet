import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constants.dart';
import '../../common/routes.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.all(Consts.marginPageHorizon),
      child: ListView(
        children: [
          for (int i = 0; i < 10; i++) ...[
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, ROUTES.MAP_DETAIL);
              },
              child: Container(
                height: 100.h,
                width: double.infinity,
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
                child: Center(
                  child: Text("$i번째 맵"),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            )
          ],
        ],
      ),
    ));
  }
}
