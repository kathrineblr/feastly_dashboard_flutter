import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/models/inventory/brand_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_kit/overlay_kit.dart';

import '../../widgets/custom_snackbar.dart';
import '../../widgets/loading_progress.dart';


class BrandController extends GetxController{

  var brandName = TextEditingController();
  BrandModel? selectedBrand;

  var enableUpdate = false.obs;

  var columList = const [
    DataColumn2(label: Text('SLNO.'),size: ColumnSize.S),
    DataColumn2(label: Text('Code'),size: ColumnSize.M),
    DataColumn2(label: Text('Name'),size: ColumnSize.L),
  ];

  var brandList = <BrandModel>[];

  getListOfBrands()async{
    var data = await BrandModel().getAllBrands();
    if(data != null){
      if(data['code'] == 200) {
        brandList = (data['data'] as List).map((e)=>BrandModel.fromJson(e)).toList();
      }
    }
    update(['brand_list']);
  }

  clearFrom(){
    brandName.clear();
    selectedBrand = null;
    enableUpdate.value = false;
    update(['brand_list']);
  }

  addBrandApi()async{
    if(brandName.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter brand name');
    }
    else{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        "name": brandName.text.trim(),
      };
      var data = await BrandModel().addBrand(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          getListOfBrands();
          clearFrom();
          customSnack(title: 'Success',type: 's',msg: '${data['data']['msg']}');
        }
        else{
          customSnack(title: 'Error',type: 'e',msg: '${data['data']['msg']}');
        }
      }
    }
  }

  updateBrandApi()async{
    if(brandName.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter brand name');
    }
    else{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        "code":selectedBrand!.code,
        "name": brandName.text.trim(),
      };
      var data = await BrandModel().updateBrand(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          getListOfBrands();
          clearFrom();
          customSnack(title: 'Success',type: 's',msg: '${data['data']['msg']}');
        }
        else{
          customSnack(title: 'Error',type: 'e',msg: '${data['data']['msg']}');
        }
      }
    }
  }

  selectBrandFunc(index){
    selectedBrand = brandList[index];
    brandName.text = brandList[index].name!;
    enableUpdate.value = true;
    update(['brand_list']);
  }
}