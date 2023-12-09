import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/constants.dart';

class MeetSubAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MeetSubAppBar({
    Key? key,
    this.title,
    this.backButtonAction,
    this.actions,
    this.hideBackIcon = false,
    this.hideMessageIcon = false,
    this.hideNotificationIcon = false,

    /// 로고를 눌렀을때 뒤로가기 차단여부
    this.blockLogoPop = false,
  }) : super(key: key);

  final bool hideBackIcon;
  final VoidCallback? backButtonAction;
  final bool hideMessageIcon;
  final bool hideNotificationIcon;
  final bool blockLogoPop;

  final String? title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => Size.fromHeight(100.h);

  @override
  State<MeetSubAppBar> createState() => _MeetSubAppBarState();
}

class _MeetSubAppBarState extends State<MeetSubAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: widget.hideBackIcon
          ? null
          : IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                if (widget.backButtonAction != null) {
                  widget.backButtonAction!();
                  return;
                }
                Navigator.pop(context, true);
              }),
      automaticallyImplyLeading: widget.hideBackIcon ? false : true,
      toolbarHeight: 100.h,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: Color(0xFF222222),
      ),
      title: Text(
        widget.title ?? "",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF222222),
          fontSize: Consts.fontSizeSubAppbarTitle,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: widget.actions?.isNotEmpty == true ? widget.actions : [Container()],
    );
  }
}
