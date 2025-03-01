import 'dart:typed_data';

import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/constants/fetch_from_url.dart';
import 'package:feastly_dashboard/models/inventory/category_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_kit/overlay_kit.dart';

import '../../widgets/custom_snackbar.dart';
import '../../widgets/loading_progress.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';



class CategoryController extends GetxController{

  var categoryName = TextEditingController();
  var categoryImage = Rxn<Uint8List>();

  CategoryModel? selectedCategory;

  var columList = const [
    DataColumn2(label: Text('SLNO.'),size: ColumnSize.S),
    DataColumn2(label: Text('Code'),size: ColumnSize.M),
    DataColumn2(label: Text('Name'),size: ColumnSize.L),
  ];

  var categoryList = <CategoryModel>[];

  var enableUpdate = false.obs;

  getListOfCategory()async{
    var data = await CategoryModel().getAllCategories();
    if(data != null){
      if(data['code'] == 200) {
       categoryList = (data['data'] as List).map((e)=>CategoryModel.fromJson(e)).toList();
      }
    }
    update(['cat_list']);
  }

  clearFrom(){
    categoryName.clear();
    selectedCategory = null;
    enableUpdate.value = false;
    categoryImage.value = null;
    update(['cat_list']);
  }

  pickCategoryImage()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['jpg','jpeg','png'],withData: true);
    if(result != null){
      categoryImage.value = result.files.single.bytes;
      update(['cat_list']);
    }
  }

  addCategoryApi()async{
    if(categoryName.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter category name');
    }
    else if(categoryImage.value == null){
      customSnack(type: 'e',title: 'Error',msg: 'Select category image');
    }
    else{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        "name": categoryName.text.trim(),
        "image": dio.MultipartFile.fromBytes(categoryImage.value!,filename: 'image.png',contentType: MediaType('image', 'png')),
      };
      var data = await CategoryModel().addCategory(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          getListOfCategory();
          clearFrom();
          customSnack(title: 'Success',type: 's',msg: '${data['data']['msg']}');
        }
        else{
          customSnack(title: 'Error',type: 'e',msg: '${data['data']['msg']}');
        }
      }
    }
  }



  updateCategoryApi()async{
    if(categoryName.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter category name');
    }
    else{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        "code":selectedCategory!.code,
        "name": categoryName.text.trim(),
        "image": dio.MultipartFile.fromBytes(categoryImage.value!,filename: 'image.png',contentType: MediaType('image', 'png')),
      };
      var data = await CategoryModel().updateCategory(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          getListOfCategory();
          clearFrom();
          customSnack(title: 'Success',type: 's',msg: '${data['data']['msg']}');
        }
        else{
          customSnack(title: 'Error',type: 'e',msg: '${data['data']['msg']}');
        }
      }
    }
  }

  selectCategoryFunc(index)async{
    selectedCategory = categoryList[index];
    categoryName.text = categoryList[index].name!;
    enableUpdate.value = true;
    categoryImage.value = await FetchFromUrl().fetchImageBytesFromUrl(categoryList[index].image!);
    update(['cat_list']);
  }

}