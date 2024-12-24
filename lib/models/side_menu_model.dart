// To parse this JSON data, do
//
//     final sideMenuModel = sideMenuModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

SideMenuModel sideMenuModelFromJson(String str) => SideMenuModel.fromJson(json.decode(str));

String sideMenuModelToJson(SideMenuModel data) => json.encode(data.toJson());

class SideMenuModel {
  String name;
  String value;
  Icon icon;

  SideMenuModel({
    required this.name,
    required this.value,
    required this.icon,
  });

  factory SideMenuModel.fromJson(Map<String, dynamic> json) => SideMenuModel(
    name: json["name"],
    value: json["value"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
    "icon": icon,
  };
}
