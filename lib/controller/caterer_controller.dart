import 'dart:typed_data';

import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/models/caterer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_kit/overlay_kit.dart';

import '../widgets/custom_snackbar.dart';
import '../widgets/header_widget.dart';
import '../widgets/loading_progress.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';


class CatererController extends GetxController{

  var nameTxt = TextEditingController();
  var addressTxt = TextEditingController();
  var ownerNameTxt = TextEditingController();
  var ownerPhoneTxt = TextEditingController();
  var shopImage = Rxn<Uint8List>();

  var columList = const [
    DataColumn2(label: Text('SLNO.'),size: ColumnSize.S),
    DataColumn2(label: Text('Code'),size: ColumnSize.M),
    DataColumn2(label: Text('Catering Name'),size: ColumnSize.M),
    DataColumn2(label: Text('Owner Name'),size: ColumnSize.M),
    DataColumn2(label: Text('Owner Phone'),size: ColumnSize.M),
    DataColumn2(label: Text('Address'),size: ColumnSize.L),
    DataColumn2(label: Text('Action'),size: ColumnSize.S),
  ];

  var catererList = <CatererModel>[];


  getCaterers()async{
    var model  = {
      "skip":0,
      "limit":500
    };
    var data = await CatererModel().listOfCaterer(model);
    if(data != null){
      if(data['code'] == 200){
        catererList = (data['data'] as List).map((e)=>CatererModel.fromJson(e)).toList();
      }
    }
    update(['caterer_list']);
  }

  clearForm(){
    nameTxt.clear();
    addressTxt.clear();
    ownerNameTxt.clear();
    ownerPhoneTxt.clear();
    shopImage.value = null;
  }

  addCatererDialog(){
    clearForm();
    Get.dialog(Dialog(
      child: Container(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderWidget(title: 'Add Caterer',onTap: (){Get.back();},),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Catering Name*',style: Get.textTheme.titleMedium),
                      TextField(
                        controller: nameTxt,
                        style: Get.textTheme.bodyMedium,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Owner Phone/Mobile',style: Get.textTheme.titleMedium),
                          TextField(
                            controller: ownerPhoneTxt,
                            style: Get.textTheme.bodyMedium,
                          )
                        ],
                      ),),
                      const SizedBox(width: 5.0),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Owner Name',style: Get.textTheme.titleMedium),
                          TextField(
                            controller: ownerNameTxt,
                            style: Get.textTheme.bodyMedium,
                          )
                        ],
                      ),),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address',style: Get.textTheme.titleMedium),
                      TextField(
                        controller: addressTxt,
                        style: Get.textTheme.bodyMedium,
                        maxLines: 4,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(onPressed: (){Get.back();}, child: Text('Close')),
                        const SizedBox(width: 10.0),
                        FilledButton(onPressed: (){
                          addCatererApi();
                          }, child: Text('Add Caterer')),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  addCatererApi()async{
    if(nameTxt.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter catering name');
    }
    else if(addressTxt.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter address');
    }
    else if(ownerPhoneTxt.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter Owner Phone');
    }
    else if(ownerNameTxt.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter Owner Name');
    }
    else{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        "name": nameTxt.text.trim(),
        "owner_name": ownerNameTxt.text.trim(),
        "owner_phone": ownerPhoneTxt.text.trim(),
        "address": addressTxt.text.trim(),
      };
      var data = await CatererModel().addCaterer(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          if(shopImage.value != null){
            addShopImageApi();
          }
          else{
          getCaterers();
          Get.back();
          customSnack(title: 'Success',type: 's',msg: '${data['data']['msg']}');
          }
        }
        else{
          customSnack(title: 'Error',type: 'e',msg: '${data['data']['msg']}');
        }
      }
    }
  }

  addShopImageApi()async{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        "owner_phone": ownerPhoneTxt.text.trim(),
        "shop_image": dio.MultipartFile.fromBytes(shopImage.value!,filename: 'shop_image.png',contentType: MediaType('image','png'))
      };
      var data = await CatererModel().uploadCatererShopImage(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          getCaterers();
          Get.back();
          customSnack(title: 'Success',type: 's',msg: '${data['data']['msg']}');
        }
        else{
          customSnack(title: 'Error',type: 'e',msg: '${data['data']['msg']}');
        }
      }
    }


  modifyCatererDialog({required CatererModel model}){
    nameTxt.text = model.name!;
    addressTxt.text = model.address!;
    ownerNameTxt.text = model.ownerName!;
    ownerPhoneTxt.text = model.ownerPhone!;

    Get.dialog(Dialog(
      child: Container(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderWidget(title: 'Modify Caterer',onTap: (){Get.back();},),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Catering Name*',style: Get.textTheme.titleMedium),
                      TextField(
                        controller: nameTxt,
                        style: Get.textTheme.bodyMedium,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Owner Phone/Mobile',style: Get.textTheme.titleMedium),
                          TextField(
                            controller: ownerPhoneTxt,
                            readOnly: true,
                            style: Get.textTheme.bodyMedium,
                          )
                        ],
                      ),),
                      const SizedBox(width: 5.0),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Owner Name',style: Get.textTheme.titleMedium),
                          TextField(
                            controller: ownerNameTxt,
                            style: Get.textTheme.bodyMedium,
                          )
                        ],
                      ),),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address',style: Get.textTheme.titleMedium),
                      TextField(
                        controller: addressTxt,
                        style: Get.textTheme.bodyMedium,
                        maxLines: 4,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(onPressed: (){Get.back();}, child: Text('Close')),
                        const SizedBox(width: 10.0),
                        FilledButton(onPressed: (){
                          updateCatererApi(model.code);
                        }, child: Text('Update')),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  updateCatererApi(code)async{
    if(nameTxt.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter catering name');
    }
    else if(addressTxt.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter address');
    }
    else if(ownerPhoneTxt.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter Owner Phone');
    }
    else if(ownerNameTxt.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter Owner Name');
    }
    else{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        "code":code,
        "name": nameTxt.text.trim(),
        "owner_name": ownerNameTxt.text.trim(),
        "owner_phone": ownerPhoneTxt.text.trim(),
        "address": addressTxt.text.trim(),
      };
      var data = await CatererModel().updateCaterer(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          if(shopImage.value != null){
            addShopImageApi();
          }
          else{
            getCaterers();
            Get.back();
            customSnack(title: 'Success',type: 's',msg: '${data['data']['msg']}');
          }
        }
        else{
          customSnack(title: 'Error',type: 'e',msg: '${data['data']['msg']}');
        }
      }
    }
  }
}