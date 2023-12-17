import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../common/common.dart';
import '../common/constants.dart';

class AppbarChange extends ChangeNotifier {
  void refresh() {
    meetlog("appbar refresh");
    notifyListeners();
  }
}

class MeetAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MeetAppBar({
    Key? key,
    this.title,
    this.backButtonAction,
    this.actions,
    this.hideLogo = false,
    this.hideBackIcon = false,
    this.hideMessageIcon = false,
    this.hideNotificationIcon = false,
    this.backgroundColor = Colors.white,

    /// 로고를 눌렀을때 뒤로가기 차단여부
    this.blockLogoPop = false,
  }) : super(key: key);

  final bool hideLogo;
  final bool hideBackIcon;
  final VoidCallback? backButtonAction;
  final bool hideMessageIcon;
  final bool hideNotificationIcon;
  final bool blockLogoPop;

  final String? title;
  final List<Widget>? actions;

  final Color? backgroundColor;

  @override
  Size get preferredSize => Size.fromHeight(100.h);

  @override
  State<MeetAppBar> createState() => _MeetAppBarState();
}

class _MeetAppBarState extends State<MeetAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppbarChange>(builder: (context, appbar, child) {
      return AppBar(
          centerTitle: false,
          backgroundColor: widget.backgroundColor,
          automaticallyImplyLeading: false, //widget.hideBackIcon ? false : true,
          toolbarHeight: 100.h,
          elevation: 2,
          titleSpacing: Consts.marginPage,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: !widget.hideLogo
              ? Row(
                  children: [
                    InkWell(
                        onTap: () {
                          meetlog("로고 텍스트 터치2");
                        },
                        child: Text(Consts.appTitle,
                            style: TextStyle(
                              color: const Color(0xFF222222),
                              fontSize: 34.sp,
                              fontWeight: FontWeight.w800,
                            )) //Image.asset(img('logo.png'), width: 250.w, height: 56.h),
                        ),
                  ],
                )
              : Text(
                  widget.title ?? "",
                  style: TextStyle(
                    color: const Color(0xFF222222),
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
          actions: appbarActionIcons());
    });
  }

  List<Widget> appbarActionIcons() {
    List<Widget> actions = [];

    if (widget.actions != null && widget.actions!.isNotEmpty) {
      actions.addAll(widget.actions!);
    }

    actions.add(SizedBox(
      width: Consts.marginPage,
    ));

    return actions;
  }
}

Widget appbarSelector(int index) {
  switch (index) {
    default:
      return const MeetAppBar();
  }
}
