import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/constants.dart';

// ignore: must_be_immutable
class MeetButton extends StatefulWidget {
  MeetButton({
    super.key,
    this.backgroundColor,
    this.disableBackgroundColor = const Color(0xFFF0F0F0),
    this.borderColor = Colors.transparent,
    this.borderWidth,
    this.titleColor = Colors.white,
    this.disableTitleColor = const Color(0xFFAAAAAA),
    this.disableBorderColor = Colors.transparent,
    this.width,
    this.height,
    this.titleSize,
    this.titleWeight = FontWeight.w800,
    this.titleHeight,
    this.elevation = 0,
    this.enabled = true,
    required this.radius,
    required this.title,
    this.onPressed,
    this.isPaddingZero = false,
  });

  final bool enabled;
  Color? backgroundColor;
  final Color disableBackgroundColor;
  final Color borderColor;
  double? borderWidth;
  final Color disableBorderColor;
  final Color titleColor;
  final Color disableTitleColor;
  final double? width;
  final double? height;
  final double radius;
  final String title;
  final double elevation;
  double? titleSize;
  final VoidCallback? onPressed;
  final FontWeight? titleWeight;
  final double? titleHeight;
  final bool isPaddingZero;

  @override
  State<MeetButton> createState() => _MeetButtonState();
}

class _MeetButtonState extends State<MeetButton> {
  double titleSize = 30.sp;
  double imageDistance = 12.w;
  double borderWidth = 1.0;

  @override
  void initState() {
    super.initState();
    titleSize = widget.titleSize ?? titleSize;
    borderWidth = widget.borderWidth ?? borderWidth;
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: widget.elevation,
      backgroundColor: widget.backgroundColor ?? Consts.primaryColor,
      disabledBackgroundColor: widget.disableBackgroundColor,
      padding: widget.isPaddingZero ? EdgeInsets.zero : null,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: widget.enabled ? widget.borderColor : widget.disableBorderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(widget.radius),
      ),
    );

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: ElevatedButton(
          style: style,
          onPressed: widget.enabled ? widget.onPressed : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.enabled ? widget.titleColor : widget.disableTitleColor,
                  fontSize: titleSize,
                  fontWeight: widget.titleWeight,
                  height: widget.titleHeight,
                ),
              ),
            ],
          )),
    );
  }
}
