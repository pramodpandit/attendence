import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../utils/enums.dart';
import 'api_exception.dart';


class ApiService {
  final Dio dio;
  ApiService(this.dio);
  // static const host = "https://krishnadeep.com/toxmo_electric/";
  static const host = "https://freeze.talocare.co.in/";

  static const _baseUrl = "${host}api/";

  static const serverToken = "AAAA8zNwuew:APA91bGbcY3KKWPSu87KUq9BmHxt-Te7W-Psr8ZHRsJCTOMJWy38mwzUN9DOi3MjRZhz5l31b6UCwJAmUsHu0dZ10_nLAiJNnQJ1O1xIO6g3xl4T9NMGcMZRxuE9Eye5TJgbcnJchH0c";

  dynamic postRequest(String subUrl, Map<String, dynamic> inputData, {bool withFile = false, bool requireToken=false, bool cacheRequest = true, bool forceRefresh = false}) async {
    try {
      String url = "$_baseUrl$subUrl";
      debugPrint('---POST1 url $url');
      debugPrint('---Params $inputData');
      Options option = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: requireToken ? {
          'token': true,
        } : {},
      );


      Response res = await dio.post(
        "$url",
        data: withFile ? FormData.fromMap(inputData) : inputData,
        options: option,
        // options: cacheRequest ? buildCacheOptions(
        //   const Duration(minutes: 30),
        //   maxStale: const Duration(days: 2),
        //   forceRefresh: forceRefresh,
        //   options: option,
        // ) : option,
      );

      if (res.statusCode == 200) {
        var rData = res.data;
        debugPrint('---RESULT: $rData');
        log('---RESULT FULL: $rData');
        debugPrint('---RESULT END');
        return rData;
      } else {
        throw ApiException.fromString("Error Occurred. ${res.statusCode}");
      }
    } on SocketException {
      throw ApiException.fromString("No Internet Connection!");
    } on DioError catch (dioError) {
      throw ApiException.fromDioError(dioError);
    }
  }

  dynamic getRequest(String subUrl, {Map<String, dynamic> data = const {}, bool requireToken = false, bool cacheRequest = true, bool forceRefresh = false}) async {
    try {
      String url = "$_baseUrl$subUrl";
      debugPrint('---GET1 url $url');
      debugPrint('---Params $data');

      Options option = Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: requireToken ? {
          'token': true,
        } : {},
      );
      Response res = await dio.get(
        url,
        queryParameters: data,
        options: option,
        // options: cacheRequest ? buildCacheOptions(
        //   const Duration(minutes: 30),
        //   maxStale: const Duration(days: 2),
        //   forceRefresh: forceRefresh,
        //   options: option,
        // ) : option,
      );
      debugPrint('---RESULT: ${res.data}');
      log('---RESULT FULL: ${res.data}');
      if (res.statusCode == 200) {
        var rData = res.data;
        debugPrint('---RESULT END');
        return rData;
      } else {
        throw ApiException.fromString("Error Occurred. ${res.statusCode}");
      }
    } on SocketException {
      throw ApiException.fromString("No Internet Connection!");
    } on DioError catch (dioError) {
      throw ApiException.fromDioError(dioError);
    }
  }

  dynamic sendNotificationRequest(Map<String, dynamic> inputData, {bool withFile = false, bool requireToken=false, bool cacheRequest = true, bool forceRefresh = false}) async {
    try {
      String url = "https://fcm.googleapis.com/fcm/send";
      debugPrint('---POST1 url $url');
      debugPrint('---Params $inputData');
      Options option = Options(
        contentType: Headers.jsonContentType,
        headers: {
          "Authorization" : "key=AAAA8zNwuew:APA91bGbcY3KKWPSu87KUq9BmHxt-Te7W-Psr8ZHRsJCTOMJWy38mwzUN9DOi3MjRZhz5l31b6UCwJAmUsHu0dZ10_nLAiJNnQJ1O1xIO6g3xl4T9NMGcMZRxuE9Eye5TJgbcnJchH0c"
        },
      );


      Response res = await dio.post(
        "$url",
        data: jsonEncode(inputData),
        options: option,
      );

      if (res.statusCode == 200) {
        var rData = res.data;
        debugPrint('---RESULT: $rData');
        log('---RESULT FULL: $rData');
        debugPrint('---RESULT END');
        return rData;
      } else {
        throw ApiException.fromString("Error Occurred. ${res.statusCode}");
      }
    } on SocketException {
      throw ApiException.fromString("No Internet Connection!");
    } on DioError catch (dioError) {
      throw ApiException.fromDioError(dioError);
    }
  }
}
