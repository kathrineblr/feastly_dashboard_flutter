// To parse this JSON data, do
//
//     final subCategoryModel = subCategoryModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:feastly_dashboard/models/inventory/category_model.dart';

import '../../api/api_service.dart';
import '../../shared_services.dart';
import '../../widgets/auth_failed.dart';

SubCategoryModel subCategoryModelFromJson(String str) => SubCategoryModel.fromJson(json.decode(str));

String subCategoryModelToJson(SubCategoryModel data) => json.encode(data.toJson());

class SubCategoryModel {
  String? code;
  CategoryModel? category;
  String? name;
  String? createdUser;

  SubCategoryModel({
    this.code,
    this.category,
    this.name,
    this.createdUser,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
    code: json["code"],
    category: json["category"] == null ? null : CategoryModel.fromJson(json["category"]),
    name: json["name"],
    createdUser: json["created_user"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "category": category?.toJson(),
    "name": name,
    "created_user": createdUser,
  };

  Future<Map<String, dynamic>?> getAllSubCategories() async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).get('/inventory/listOfSubCategories',
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

  Future<Map<String, dynamic>?> addSubCategory(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).post('/inventory/addSubCategory',
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

  Future<Map<String, dynamic>?> updateSubCategory(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).post('/inventory/updateSubCategory',
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

