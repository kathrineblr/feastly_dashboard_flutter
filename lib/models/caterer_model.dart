// To parse this JSON data, do
//
//     final catererModel = catererModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../api/api_service.dart';
import '../shared_services.dart';
import '../widgets/auth_failed.dart';

CatererModel catererModelFromJson(String str) => CatererModel.fromJson(json.decode(str));

String catererModelToJson(CatererModel data) => json.encode(data.toJson());

class CatererModel {
  String? code;
  String? name;
  String? address;
  String? shopImage;
  String? ownerName;
  String? ownerPhone;
  String? createdAt;
  String? createdBy;

  CatererModel({
    this.code,
    this.name,
    this.address,
    this.shopImage,
    this.ownerName,
    this.ownerPhone,
    this.createdAt,
    this.createdBy,
  });

  factory CatererModel.fromJson(Map<String, dynamic> json) => CatererModel(
    code: json["code"],
    name: json["name"],
    address: json["address"],
    shopImage: json["shop_image"],
    ownerName: json["owner_name"],
    ownerPhone: json["owner_phone"],
    createdAt: json["created_at"],
    createdBy: json["created_by"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "address": address,
    "shop_image": shopImage,
    "owner_name": ownerName,
    "owner_phone": ownerPhone,
    "created_at": createdAt,
    "created_by": createdBy,
  };

  Future<Map<String, dynamic>?> listOfCaterer(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();

      var data = await Dio(ApiService().options).get('/caterers/allCaterers',
          queryParameters: model,
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


  Future<Map<String, dynamic>?> addCaterer(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
       model['created_by'] = logData!.userName;
      var data = await Dio(ApiService().options).post('/caterers/registerCaterer',
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

  Future<Map<String, dynamic>?> uploadCatererShopImage(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
       var fromData = FormData.fromMap(model);
      var data = await Dio(ApiService().options).post('/caterers/addShopImage',
          data: fromData,
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

  Future<Map<String, dynamic>?> updateCaterer(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();

      var data = await Dio(ApiService().options).post('/caterers/updateCaterer',
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
