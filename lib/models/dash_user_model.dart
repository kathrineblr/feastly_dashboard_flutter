// To parse this JSON data, do
//
//     final dashUserModel = dashUserModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../api/api_service.dart';
import '../shared_services.dart';
import '../widgets/auth_failed.dart';

DashUserModel dashUserModelFromJson(String str) => DashUserModel.fromJson(json.decode(str));

String dashUserModelToJson(DashUserModel data) => json.encode(data.toJson());

class DashUserModel {
  String? code;
  String? name;
  String? phone;
  String? userName;
  String? password;
  String? address;
  String? token;
  String? role;
  String? createdUser;
  bool? active;

  DashUserModel({
    this.code,
    this.name,
    this.phone,
    this.userName,
    this.password,
    this.address,
    this.token,
    this.role,
    this.createdUser,
    this.active,
  });

  factory DashUserModel.fromJson(Map<String, dynamic> json) => DashUserModel(
    code: json["code"],
    name: json["name"],
    phone: json['phone'],
    userName: json["user_name"],
    password: json["password"],
    address: json["address"],
    token: json["token"],
    role: json["role"],
    createdUser: json["created_user"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "phone":phone,
    "user_name": userName,
    "password": password,
    "address": address,
    "token": token,
    "role": role,
    "created_user": createdUser,
    "active": active,
  };

  Future<Map<String, dynamic>?> loginApi(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();

      var data = await Dio(ApiService().options).post('/dashUsers/login',
          data: model,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            // HttpHeaders.authorizationHeader: "Bearer ${ServerIp.staticToken}"
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

  Future<Map<String, dynamic>?> addUsers(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();

      var data = await Dio(ApiService().options).post('/dashUsers/addUser',
          data: model,
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

  Future<Map<String, dynamic>?> getAllUsers() async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).get('/dashUsers/allUsers',
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
}
