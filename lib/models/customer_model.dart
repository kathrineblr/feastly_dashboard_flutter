// To parse this JSON data, do
//
//     final customerModel = customerModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../api/api_service.dart';
import '../shared_services.dart';
import '../widgets/auth_failed.dart';

CustomerModel customerModelFromJson(String str) => CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  String? code;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  Address? address;
  String? phone;

  CustomerModel({
    this.code,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.address,
    this.phone,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    code: json["code"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    password: json["password"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "password": password,
    "address": address?.toJson(),
    "phone": phone,
  };

  Future<Map<String, dynamic>?> getAllCustomers(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).get('/customers/allCustomers',
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
}

class Address {
  String? street;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? lat;
  String? lng;

  Address({
    this.street,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.lat,
    this.lng,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street: json["street"],
    city: json["city"],
    state: json["state"],
    zip: json["zip"],
    country: json["country"],
    lat: json["lat"],
    lng: json["lng"],
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "city": city,
    "state": state,
    "zip": zip,
    "country": country,
    "lat": lat,
    "lng": lng,
  };


}
