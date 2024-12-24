import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/models/inventory/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_kit/overlay_kit.dart';

import '../../widgets/custom_snackbar.dart';
import '../../widgets/loading_progress.dart';

class UnitController extends GetxController{

  var unitName = TextEditingController();
  UnitModel? selectedUnit;

  var enableUpdate = false.obs;

  var columList = const [
    DataColumn2(label: Text('SLNO.'),size: ColumnSize.S),
    DataColumn2(label: Text('Code'),size: ColumnSize.M),
    DataColumn2(label: Text('Name'),size: ColumnSize.L),
  ];

  var unitList = <UnitModel>[];

  getListOfUnits()async{
    var data = await UnitModel().getAllUnits();
    if(data != null){
      if(data['code'] == 200) {
        unitList = (data['data'] as List).map((e)=>UnitModel.fromJson(e)).toList();
      }
    }
    update(['unit_list']);
  }

  clearFrom(){
    unitName.clear();
    selectedUnit = null;
    enableUpdate.value = false;
    update(['unit_list']);
  }

  addUnitApi()async{
    if(unitName.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter Unit');
    }
    else{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        "name": unitName.text.trim(),
      };
      var data = await UnitModel().addUnit(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          getListOfUnits();
          clearFrom();
          customSnack(title: 'Success',type: 's',msg: '${data['data']['msg']}');
        }
        else{
          customSnack(title: 'Error',type: 'e',msg: '${data['data']['msg']}');
        }
      }
    }
  }

  updateUnitApi()async{
    if(unitName.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter Unit');
    }
    else{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        "code":selectedUnit!.code,
        "name": unitName.text.trim(),
      };
      var data = await UnitModel().updateUnit(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          getListOfUnits();
          clearFrom();
          customSnack(title: 'Success',type: 's',msg: '${data['data']['msg']}');
        }
        else{
          customSnack(title: 'Error',type: 'e',msg: '${data['data']['msg']}');
        }
      }
    }
  }

  selectUnitFunc(index){
    selectedUnit = unitList[index];
    unitName.text = unitList[index].name!;
    enableUpdate.value = true;
    update(['unit_list']);
  }
}