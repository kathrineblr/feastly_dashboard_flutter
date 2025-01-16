// To parse this JSON data, do
//
//     final catererItemModel = catererItemModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../api/api_service.dart';
import '../shared_services.dart';
import '../widgets/auth_failed.dart';

CatererItemModel catererItemModelFromJson(String str) => CatererItemModel.fromJson(json.decode(str));

String catererItemModelToJson(CatererItemModel data) => json.encode(data.toJson());

class CatererItemModel {
  String? catererCode;
  String? itemName;
  String? itemCode;

  CatererItemModel({
    this.catererCode,
    this.itemName,
    this.itemCode,
  });

  factory CatererItemModel.fromJson(Map<String, dynamic> json) => CatererItemModel(
    catererCode: json["caterer_code"],
    itemName: json["item_name"],
    itemCode: json["item_code"],
  );

  Map<String, dynamic> toJson() => {
    "caterer_code": catererCode,
    "item_name": itemName,
    "item_code": itemCode,
  };

  Future<Map<String, dynamic>?> getAllCategories(catererCode) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).get('/caterers/listOfItemsByCaterer',
          queryParameters: {'caterer_code': catererCode},
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
