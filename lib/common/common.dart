import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

String img(String filename) {
  return "assets/images/$filename";
}

String profileImg(String fileName){
  return "assets/profile/$fileName";
}

void meetlog(String message, {String tag = 'MEET'}) {
  if (kDebugMode == false) {
    return;
  }
  var logDate = DateFormat('yyyy-MM-dd HH:mm:SSS').format(DateTime.now());
  developer.log("$tag: $logDate: $message", time: DateTime.now());
}
