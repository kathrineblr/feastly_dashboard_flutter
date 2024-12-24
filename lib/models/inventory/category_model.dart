// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../api/api_service.dart';
import '../../shared_services.dart';
import '../../widgets/auth_failed.dart';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  String? code;
  String? name;
  String? createdUser;

  CategoryModel({
    this.code,
    this.name,
    this.createdUser,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    code: json["code"],
    name: json["name"],
    createdUser: json["created_user"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "created_user": createdUser,
  };

  Future<Map<String, dynamic>?> getAllCategories() async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).get('/inventory/listOfCategories',
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

  Future<Map<String, dynamic>?> addCategory(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).post('/inventory/addCategory',
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

  Future<Map<String, dynamic>?> updateCategory(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).post('/inventory/updateCategory',
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
}
