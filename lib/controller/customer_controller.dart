import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController{

  var columList = const [
    DataColumn2(label: Text('SLNO.'), size: ColumnSize.S),
    DataColumn2(label: Text('Code'), size: ColumnSize.M),
    DataColumn2(label: Text('First Name'), size: ColumnSize.M),
    DataColumn2(label: Text('Last Name'), size: ColumnSize.M),
    DataColumn2(label: Text('Email'), size: ColumnSize.M),
    DataColumn2(label: Text('Phone'), size: ColumnSize.M),
  ];

  loadProject() async {
    update(['listOfCustomers']);
  }

  var rowPerPage = 50;

  rowChangedPerPage(int newPerPage) {
    // print('New Per Page: $newPerPage');
    rowPerPage = newPerPage;
    // update(['listOfCalls']);
  }
}