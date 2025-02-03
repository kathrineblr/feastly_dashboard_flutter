// To parse this JSON data, do
//
//     final rangeSettingModel = rangeSettingModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../api/api_service.dart';
import '../../shared_services.dart';
import '../../widgets/auth_failed.dart';

RangeSettingModel rangeSettingModelFromJson(String str) => RangeSettingModel.fromJson(json.decode(str));

String rangeSettingModelToJson(RangeSettingModel data) => json.encode(data.toJson());

class RangeSettingModel {
  String? code;
  String? rangeInKm;
  String? cancellationTimeInHours;
  String? cancellationChargeInPerc;
  String? createdUser;
  String? createdTime;

  RangeSettingModel({
    this.code,
    this.rangeInKm,
    this.cancellationTimeInHours,
    this.cancellationChargeInPerc,
    this.createdUser,
    this.createdTime,
  });

  factory RangeSettingModel.fromJson(Map<String, dynamic> json) => RangeSettingModel(
    code: json["code"],
    rangeInKm: json["range_in_km"] == null ? '0' : json["range_in_km"].toString(),
    cancellationTimeInHours: json["cancellation_time_in_hours"] == null ? '0' : json["cancellation_time_in_hours"].toString(),
    cancellationChargeInPerc: json["cancellation_charge_in_perc"] == null ? '0' : json["cancellation_charge_in_perc"].toString(),
    createdUser: json["created_user"],
    createdTime: json["created_time"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "range_in_km": rangeInKm,
    "cancellation_time_in_hours": cancellationTimeInHours,
    "cancellation_charge_in_perc": cancellationChargeInPerc,
    "created_user": createdUser,
    "created_time": createdTime,
  };

  Future<Map<String, dynamic>?> getRangeSettings() async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).get('/settings/getRangeSettings',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${logData!.token}"
          }));

      if (data.statusCode == 200) {
        jsonResp = {'code': data.statusCode, 'data': data.data};
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if(e.response!.statusCode == 401 || e.response!.statusCode == 403){
          authFailedFunc(msg: e.response!.data['msg']);
        }else {
          jsonResp = {'code': e.response!.statusCode, 'data': e.response!.data};
        }
      } else {
        jsonResp = {
          'code': 500,
          'data': {'msg': 'Something error try again'}
        };
      }
    }
    return jsonResp;
  }

  Future<Map<String, dynamic>?> updateRangeInKm(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      model['user_name'] = logData!.userName;
      var data = await Dio(ApiService().options).post('/settings/updateRangeInKm',
          data: model,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${logData.token}"
          }));

      if (data.statusCode == 200) {
        jsonResp = {'code': data.statusCode, 'data': data.data};
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if(e.response!.statusCode == 401 || e.response!.statusCode == 403){
          authFailedFunc(msg: e.response!.data['msg']);
        }else {
          jsonResp = {'code': e.response!.statusCode, 'data': e.response!.data};
        }
      } else {
        jsonResp = {
          'code': 500,
          'data': {'msg': 'Something error try again'}
        };
      }
    }
    return jsonResp;
  }

  Future<Map<String, dynamic>?> updateCancellationTimeInHours(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      model['user_name'] = logData!.userName;
      var data = await Dio(ApiService().options).post('/settings/updateCancellationTimeInHours',
          data: model,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${logData.token}"
          }));

      if (data.statusCode == 200) {
        jsonResp = {'code': data.statusCode, 'data': data.data};
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if(e.response!.statusCode == 401 || e.response!.statusCode == 403){
          authFailedFunc(msg: e.response!.data['msg']);
        }else {
          jsonResp = {'code': e.response!.statusCode, 'data': e.response!.data};
        }
      } else {
        jsonResp = {
          'code': 500,
          'data': {'msg': 'Something error try again'}
        };
      }
    }
    return jsonResp;
  }

  Future<Map<String, dynamic>?> updateCancellationChargeInPerc(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      model['user_name'] = logData!.userName;
      var data = await Dio(ApiService().options).post('/settings/updateCancellationChargeInPerc',
          data: model,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${logData.token}"
          }));

      if (data.statusCode == 200) {
        jsonResp = {'code': data.statusCode, 'data': data.data};
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if(e.response!.statusCode == 401 || e.response!.statusCode == 403){
          authFailedFunc(msg: e.response!.data['msg']);
        }else {
          jsonResp = {'code': e.response!.statusCode, 'data': e.response!.data};
        }
      } else {
        jsonResp = {
          'code': 500,
          'data': {'msg': 'Something error try again'}
        };
      }
    }
    return jsonResp;
  }

}
