// To parse this JSON data, do
//
//     final itemMasterModel = itemMasterModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:feastly_dashboard/models/inventory/brand_model.dart';
import 'package:feastly_dashboard/models/inventory/category_model.dart';
import 'package:feastly_dashboard/models/inventory/sub_category_model.dart';
import 'package:feastly_dashboard/models/inventory/unit_model.dart';

import '../../api/api_service.dart';
import '../../shared_services.dart';
import '../../widgets/auth_failed.dart';

ItemMasterModel itemMasterModelFromJson(String str) => ItemMasterModel.fromJson(json.decode(str));

String itemMasterModelToJson(ItemMasterModel data) => json.encode(data.toJson());

class ItemMasterModel {
  String? code;
  String? name;
  String? shortDesc;
  String? desc;
  CategoryModel? category;
  SubCategoryModel? subCategory;
  BrandModel? brand;
  UnitModel? unit;
  String? ratio;
  String? ratioValue;
  String? price;
  String? ourPrice;
  String? discount;
  String? mrp;
  bool? nonVeg;
  bool? itemEnable;
  double? cookingTime;
  double? extraTime;
  String? createdUser;
  String? createdTime;

  ItemMasterModel({
    this.code,
    this.name,
    this.shortDesc,
    this.desc,
    this.category,
    this.subCategory,
    this.brand,
    this.unit,
    this.ratioValue,
    this.ratio,
    this.price,
    this.ourPrice,
    this.discount,
    this.mrp,
    this.nonVeg,
    this.itemEnable,
    this.cookingTime,
    this.extraTime,
    this.createdUser,
    this.createdTime,
  });

  factory ItemMasterModel.fromJson(Map<String, dynamic> json) => ItemMasterModel(
    code: json["code"],
    name: json["name"],
    shortDesc: json["short_desc"],
    desc: json["desc"],
    category: json["category"] == null ? null : CategoryModel.fromJson(json["category"]),
    subCategory: json["sub_category"] == null ? null : SubCategoryModel.fromJson(json["sub_category"]),
    brand: json["brand"] == null ? null : BrandModel.fromJson(json["brand"]),
    unit: json["unit"] == null ? null : UnitModel.fromJson(json["unit"]),
    ratio: json["ratio"].toString(),
    ratioValue: json["ratio_value"] == null ? '0' : json["ratio_value"].toString(),
    price: json["price"].toString(),
    ourPrice: json["our_price"] == null ? '0' : json["our_price"].toString(),
    discount: json["discount"].toString(),
    mrp: json["mrp"].toString(),
    nonVeg:json['non_veg'] ?? false,
    itemEnable: json["item_enable"],
    cookingTime: json["cooking_time"] ?? 0,
    extraTime: json["extra_time"] ?? 0 ,
    createdUser: json["created_user"],
    createdTime: json["created_time"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "short_desc": shortDesc,
    "desc": desc,
    "category": category?.toJson(),
    "sub_category": subCategory?.toJson(),
    "brand": brand?.toJson(),
    "unit": unit?.toJson(),
    "ratio": ratio,
    "ratio_value": ratioValue,
    "price": price,
    "our_price": ourPrice,
    "discount": discount,
    "mrp": mrp,
    "non_veg":nonVeg,
    "item_enable": itemEnable,
    "cooking_time": cookingTime,
    "extra_time": extraTime,
    "created_user": createdUser,
    "created_time": createdTime,
  };

  Future<Map<String, dynamic>?> getAllItems(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).get('/inventory/listOfItems',
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


  Future<Map<String, dynamic>?> searchItemByName(name) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).get('/inventory/searchItemByName',
          queryParameters: {'name':name},
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



  Future<Map<String, dynamic>?> addItem(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).post('/inventory/addItem',
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

  Future<Map<String, dynamic>?> updateItem(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).post('/inventory/updateItem',
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


  Future<Map<String, dynamic>?> uploadImage(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var formData = FormData.fromMap(model);
      var data = await Dio(ApiService().options).post('/inventory/addItemImage',
          data: formData,
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


  Future<Map<String, dynamic>?> listOfImagesByItemCode(itemCode) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).get('/inventory/listOfItemImageByItemCode',
          queryParameters: {'item_code':itemCode},
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

  Future<Map<String, dynamic>?> deleteImageByItemCode(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).delete('/inventory/deleteItemImageByItemCode',
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

