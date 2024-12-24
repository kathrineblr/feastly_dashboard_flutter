import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/models/inventory/sub_category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_kit/overlay_kit.dart';

import '../../models/inventory/category_model.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/loading_progress.dart';


class SubCategoryController extends GetxController{

  var subCategoryName = TextEditingController();

  var listOfCategories = <CategoryModel>[];
  var selectedCategory = Rxn<String>();

  SubCategoryModel? selectSubCategoryFromList;

  var enableUpdate = false.obs;

  var columList = const [
    DataColumn2(label: Text('SLNO.'),size: ColumnSize.S),
    DataColumn2(label: Text('Code'),size: ColumnSize.M),
    DataColumn2(label: Text('Name'),size: ColumnSize.L),
    DataColumn2(label: Text('Category'),size: ColumnSize.L),
  ];

  var subCategoryList = <SubCategoryModel>[];

  getListOfCategory()async{
    var data = await CategoryModel().getAllCategories();
    if(data != null){
      if(data['code'] == 200) {
        listOfCategories = (data['data'] as List).map((e)=>CategoryModel.fromJson(e)).toList();
      }
    }
    update(['cat_list']);
  }

  getListOfSubCategory()async{
    var data = await SubCategoryModel().getAllSubCategories();
    if(data != null){
      if(data['code'] == 200) {
        subCategoryList = (data['data'] as List).map((e)=>SubCategoryModel.fromJson(e)).toList();
      }
    }
    update(['sub_cat_list']);
  }

  clearFrom(){
    subCategoryName.clear();
    selectedCategory.value = null;
    selectSubCategoryFromList = null;
    enableUpdate.value = false;
    update(['sub_cat_list']);
  }

  addSubCategoryApi()async{
    if(selectedCategory.value == null){
      customSnack(type: 'e',title: 'Error',msg: 'Select Category');
    }
    else if(subCategoryName.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter sub category name');
    }
    else{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        "category":selectedCategory.value,
        "name": subCategoryName.text.trim(),
      };
      var data = await SubCategoryModel().addSubCategory(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          getListOfSubCategory();
          clearFrom();
          customSnack(title: 'Success',type: 's',msg: '${data['data']['msg']}');
        }
        else{
          customSnack(title: 'Error',type: 'e',msg: '${data['data']['msg']}');
        }
      }
    }
  }


  updateSubCategoryApi()async{
    if(selectedCategory.value == null){
      customSnack(type: 'e',title: 'Error',msg: 'Select Category');
    }
    else if(subCategoryName.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter sub category name');
    }
    else{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        "code":selectSubCategoryFromList!.code,
        "category":selectedCategory.value,
        "name": subCategoryName.text.trim(),
      };
      var data = await SubCategoryModel().updateSubCategory(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          getListOfSubCategory();
          clearFrom();
          customSnack(title: 'Success',type: 's',msg: '${data['data']['msg']}');
        }
        else{
          customSnack(title: 'Error',type: 'e',msg: '${data['data']['msg']}');
        }
      }
    }
  }

  selectSubCategoryFunc(index){
    selectSubCategoryFromList = subCategoryList[index];
    selectedCategory.value = subCategoryList[index].code!;
    subCategoryName.text = subCategoryList[index].name!;
    enableUpdate.value = true;
    update(['sub_cat_list']);
  }
}