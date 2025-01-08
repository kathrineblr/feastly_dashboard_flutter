// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../api/api_service.dart';
import '../shared_services.dart';
import '../widgets/auth_failed.dart';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  String? orderId;
  String? customerId;
  String? orderDate;
  String? orderStatus;
  String? taxTotal;
  String? orderTotal;
  String? payMode;
  String? orderPaymentStatus;
  OrderShippingAddress? orderShippingAddress;

  OrderModel({
    this.orderId,
    this.customerId,
    this.orderDate,
    this.orderStatus,
    this.taxTotal,
    this.orderTotal,
    this.payMode,
    this.orderPaymentStatus,
    this.orderShippingAddress,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    orderId: json["order_id"],
    customerId: json["customer_id"],
    orderDate: json["order_date"],
    orderStatus: json["order_status"],
    taxTotal: json["tax_total"],
    orderTotal: json["order_total"],
    payMode: json["pay_mode"],
    orderPaymentStatus: json["order_payment_status"],
    orderShippingAddress: json["order_shipping_address"] == null ? null : OrderShippingAddress.fromJson(json["order_shipping_address"]),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "customer_id": customerId,
    "order_date": orderDate,
    "order_status": orderStatus,
    "tax_total": taxTotal,
    "order_total": orderTotal,
    "pay_mode": payMode,
    "order_payment_status": orderPaymentStatus,
    "order_shipping_address": orderShippingAddress?.toJson(),
  };

  Future<Map<String, dynamic>?> getAllOrders(model) async {
    Map<String, dynamic>? jsonResp;
    try {
      var logData = await SharedServices.loginDetails();
      var data = await Dio(ApiService().options).get('/orders/allOrders',
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

class OrderShippingAddress {
  String? street;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? lat;
  String? lng;

  OrderShippingAddress({
    this.street,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.lat,
    this.lng,
  });

  factory OrderShippingAddress.fromJson(Map<String, dynamic> json) => OrderShippingAddress(
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
