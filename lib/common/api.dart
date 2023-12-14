import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:ya_meet/common/common.dart';
import 'package:ya_meet/common/routes.dart';
import 'package:ya_meet/common/urls.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'meet.dart';

class API {
  static bool showResponseLog = true;

  static String get HOST => URLS.apiHost;

  static String get NAVER_HOST => URLS.naverDomain;

  static String get OK => "success";
  static String get ERROR => "error";

  static Future<void> callWithAction(String api,
      {Map<String, String>? parameters,
      List<MultipartFile>? files,
      Function(Map<String, dynamic>)? onSuccess,
      Function(Map<String, dynamic>)? onFail}) async {
    String resultNotConnect =
        "{ \"result_type\": \"error\", \"result_code\": \"100\", \"result_msg\": \"${Consts.msgErrorNotConnect}\" }";

    String resultTimeOut =
        "{ \"result_type\": \"error\", \"result_code\": \"99\", \"result_msg\": \"${Consts.msgErrorTimeout}\" }";

    String resultUnknown =
        "{ \"result_type\": \"error\", \"result_code\": \"98\", \"result_msg\": \"${Consts.msgErrorUnknown}\" }";

    String resultNoInternet =
        "{ \"result_type\": \"error\", \"result_code\": \"97\", \"result_msg\": \"${Consts.msgErrorNoInternet}\" }";

    meetlog('$api API Call : $parameters');
    Uri uri = Uri.parse('${URLS.host}$api');
    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({'User-Agent': 'MEET'});
      if (parameters != null) request.fields.addAll(parameters);
      if (files != null) request.files.addAll(files);

      var response = await request.send().timeout(Duration(seconds: Consts.timeoutNetwork));
      if (response.statusCode == 200) {
        var apiResult = await response.stream.bytesToString();
        if (showResponseLog) {
          meetlog("$api API Response : $apiResult");
        }
        if (onSuccess != null) {
          var json = jsonDecode(apiResult) as Map<String, dynamic>;

          onSuccess(json);
        }
      } else {
        meetlog('API $HOST$api API Response Header : ${response.headers}');
        meetlog("$api API Request failed with status: ${response.statusCode}.");
        if (onFail != null) {
          onFail(jsonDecode(resultUnknown) as Map<String, dynamic>);
        }
      }
    } on SocketException {
      meetlog("$api API Request failed with SocketException.");
      if (onFail != null) {
        onFail(jsonDecode(resultNotConnect) as Map<String, dynamic>);
      }
    }
  }

  static Future<void> callNaverApi(String api,
      {Map<String, String>? parameters,
      Function(Map<String, dynamic>)? onSuccess,
      Function(Map<String, dynamic>)? onFail}) async {
    String resultNotConnect =
        "{ \"result_type\": \"error\", \"result_code\": \"100\", \"result_msg\": \"${Consts.msgErrorNotConnect}\" }";

    String resultTimeOut =
        "{ \"result_type\": \"error\", \"result_code\": \"99\", \"result_msg\": \"${Consts.msgErrorTimeout}\" }";

    String resultUnknown =
        "{ \"result_type\": \"error\", \"result_code\": \"98\", \"result_msg\": \"${Consts.msgErrorUnknown}\" }";

    String resultNoInternet =
        "{ \"result_type\": \"error\", \"result_code\": \"97\", \"result_msg\": \"${Consts.msgErrorNoInternet}\" }";

    meetlog('$api API Call : $parameters');
    String queryParams = "";
    if (parameters != null) queryParams = "?${generateQueryString(parameters)}";
    Uri uri = Uri.parse('$api$queryParams');
    try {
      var request = http.Request('GET', uri);

      //TODO: key 값 사용 확인
      request.headers.addAll({
        'X-NCP-APIGW-API-KEY-ID': dotenv.env['naver_map_client_id']!,
        'X-NCP-APIGW-API-KEY': dotenv.env['naver_map_client_secret']!
      });

      var response = await request.send().timeout(Duration(seconds: Consts.timeoutNetwork));
      if (response.statusCode == 200) {
        var apiResult = await response.stream.bytesToString();
        if (showResponseLog) {
          meetlog("$api API Response : $apiResult");
        }
        if (onSuccess != null) {
          var json = jsonDecode(apiResult) as Map<String, dynamic>;

          onSuccess(json);
        }
      } else {
        meetlog('API $NAVER_HOST$api API Response Header : ${response.headers}');
        meetlog("$api API Request failed with status: ${response.statusCode}.");
        if (onFail != null) {
          onFail(jsonDecode(resultUnknown) as Map<String, dynamic>);
        }
      }
    } on SocketException {
      meetlog("$api API Request failed with SocketException.");
      if (onFail != null) {
        onFail(jsonDecode(resultNotConnect) as Map<String, dynamic>);
      }
    }
  }
}

String generateQueryString(Map<String, dynamic> params) {
  List queryString = [];
  params.forEach((key, value) {
    if (value != null) {
      queryString.add('$key=$value');
    }
  });
  return queryString.join('&');
}
