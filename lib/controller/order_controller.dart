import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController{

  var columList = const [
    DataColumn2(label: Text('SLNO.'), size: ColumnSize.S),
    DataColumn2(label: Text('Order ID'), size: ColumnSize.M),
    DataColumn2(label: Text('Date'), size: ColumnSize.M),
    DataColumn2(label: Text('Customer'), size: ColumnSize.M),
    DataColumn2(label: Text('Payment Mode'), size: ColumnSize.M),
    DataColumn2(label: Text('Order Status'), size: ColumnSize.M),
    DataColumn2(label: Text('Delivery Address'), size: ColumnSize.M),
  ];

  loadProject() async {
    update(['listOfOrders']);
  }

  var rowPerPage = 50;

  rowChangedPerPage(int newPerPage) {
    // print('New Per Page: $newPerPage');
    rowPerPage = newPerPage;
    // update(['listOfCalls']);
  }
}