import 'dart:typed_data';

import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/models/caterer/caterer_item_image_model.dart';
import 'package:feastly_dashboard/models/caterer/caterer_item_model.dart';
import 'package:feastly_dashboard/models/caterer/caterer_model.dart';
import 'package:feastly_dashboard/views/caterers/caterer_item_images_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_kit/overlay_kit.dart';

import '../../models/inventory/brand_model.dart';
import '../../models/inventory/category_model.dart';
import '../../models/inventory/sub_category_model.dart';
import '../../models/inventory/unit_model.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/loading_progress.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';


class CatererItemController extends GetxController{


  var selectedCaterer = Rxn<CatererModel>();

  var itemNameTxt = TextEditingController();
  var shortDescTxt = TextEditingController();
  var longDescTxt = TextEditingController();

  var listOfCategory = <CategoryModel>[];
  var selectedCategory = Rxn<String>();

  var listOfSubCategory = <SubCategoryModel>[];
  var selectedSubCategory = Rxn<String>();

  var listOfUnit = <UnitModel>[];
  var selectedUnit = Rxn<String>();

  var listOfBrand = <BrandModel>[];
  var selectedBrand = Rxn<String>();

  var ratioValueTxt = TextEditingController();
  var ratioTxt = TextEditingController();
  var priceTxt = TextEditingController();
  var discountTxt = TextEditingController();
  var mrpTxt = TextEditingController();
  var ourPriceTxt = TextEditingController();
  var cookingTimeTxt = TextEditingController();
  var extraTimeTxt = TextEditingController();
  var enableItems = true.obs;
  var isNonVeg = true.obs;

  var columList = const [
    DataColumn2(label: Text('SLNO.'), size: ColumnSize.S),
    DataColumn2(label: Text('Code'), size: ColumnSize.M),
    DataColumn2(label: Text('Item Name'), size: ColumnSize.M),
    DataColumn2(label: Text('Category'), size: ColumnSize.M),
    DataColumn2(label: Text('Sub Category'), size: ColumnSize.M),
    DataColumn2(label: Text('Unit'), size: ColumnSize.M),
    DataColumn2(label: Text('Brand'), size: ColumnSize.M),
    DataColumn2(label: Text('Price'), size: ColumnSize.M),
    DataColumn2(label: Text('MRP'), size: ColumnSize.M),
    DataColumn2(label: Text('Ratio'), size: ColumnSize.L),
    DataColumn2(label: Text('Enable'), size: ColumnSize.L),
    DataColumn2(label: Text('Action'), size: ColumnSize.S),
    DataColumn2(label: Text('Action'), size: ColumnSize.S),
  ];


  loadProject() async {
    update(['listOfItems']);
  }

  var rowPerPage = 50;

  rowChangedPerPage(int newPerPage) {
    // print('New Per Page: $newPerPage');
    rowPerPage = newPerPage;
    // update(['listOfCalls']);
  }

  initiateLists() {
    listOfCategoryApi();
    listOfUnitApi();
    listOfBrandApi();
  }

  clearForm() {
    itemNameTxt.clear();
    shortDescTxt.clear();
    longDescTxt.clear();
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    selectedUnit.value = null;
    selectedBrand.value = null;
    ratioTxt.clear();
    priceTxt.clear();
    discountTxt.clear();
    mrpTxt.clear();
    ratioValueTxt.clear();
    ourPriceTxt.clear();
    enableItems.value = true;
    update(['listOfItems']);
  }

  listOfCategoryApi() async {
    var data = await CategoryModel().getAllCategories();
    if (data != null) {
      if (data['code'] == 200) {
        listOfCategory = (data['data'] as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();
      }
    }
    update(['listOfCategory']);
  }

  listOfSubCategoryApi({bool fromUpdate = false,subCategoryCode}) async {
    var data = await SubCategoryModel().getAllSubCategoriesByCategoryCode(
        selectedCategory.value);
    if (data != null) {
      if (data['code'] == 200) {
        if(fromUpdate == false) {
          selectedSubCategory.value = null;
        }
        else{
          selectedSubCategory.value = subCategoryCode;
        }
        listOfSubCategory = (data['data'] as List)
            .map((e) => SubCategoryModel.fromJson(e))
            .toList();
      }
    }
    update(['listOfSubCategory']);
  }

  listOfUnitApi() async {
    var data = await UnitModel().getAllUnits();
    if (data != null) {
      if (data['code'] == 200) {
        listOfUnit =
            (data['data'] as List).map((e) => UnitModel.fromJson(e)).toList();
      }
    }
    update(['listOfUnit']);
  }


  listOfBrandApi() async {
    var data = await BrandModel().getAllBrands();
    if (data != null) {
      if (data['code'] == 200) {
        listOfBrand =
            (data['data'] as List).map((e) => BrandModel.fromJson(e)).toList();
      }
    }
    update(['listOfBrand']);
  }


  addOpenItemDialog() {
    clearForm();
    Get.dialog(Dialog(
        child: Container(
            height: Get.height * 0.8,
            width: Get.width * 0.33,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                    children: [
                      HeaderWidget(title: 'Add Items', onTap: () {
                        Get.back();
                      },),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: itemNameTxt,
                          decoration:const InputDecoration(
                            labelText: 'Item Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: shortDescTxt,
                          decoration:const InputDecoration(
                            labelText: 'Short Description',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: longDescTxt,
                          maxLines: 5,
                          decoration:const InputDecoration(
                            labelText: 'Long Description',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(() {
                                return DropdownButtonFormField<String>(
                                  value: selectedCategory.value,
                                  onChanged: (val) {
                                    selectedCategory.value = val;
                                    listOfSubCategoryApi();
                                  },
                                  items: listOfCategory.map((e) =>
                                      DropdownMenuItem(
                                          value: e.code, child: Text(e
                                          .name!))).toList(),
                                  decoration:const InputDecoration(
                                    labelText: 'Category',
                                    border: OutlineInputBorder(),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GetBuilder<CatererItemController>(
                                  id: 'listOfSubCategory',
                                  builder: (logic) {
                                    return Obx(() {
                                      return DropdownButtonFormField<String>(
                                        value: selectedSubCategory.value,
                                        onChanged: (val) {
                                          selectedSubCategory.value = val;
                                        },
                                        items: listOfSubCategory.map((e) =>
                                            DropdownMenuItem(
                                                value: e.code, child: Text(e
                                                .name!))).toList(),
                                        decoration:const InputDecoration(
                                          labelText: 'Sub Category',
                                          border: OutlineInputBorder(),
                                        ),
                                      );
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(() {
                                return DropdownButtonFormField<String>(
                                  value: selectedUnit.value,
                                  onChanged: (val) {
                                    selectedUnit.value = val;
                                  },
                                  items: listOfUnit.map((e) =>
                                      DropdownMenuItem(
                                          value: e.code, child: Text(e
                                          .name!))).toList(),
                                  decoration: const InputDecoration(
                                    labelText: 'Unit',
                                    border: OutlineInputBorder(),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(() {
                                return DropdownButtonFormField<String>(
                                  value: selectedBrand.value,
                                  onChanged: (val) {
                                    selectedBrand.value = val;
                                  },
                                  items: listOfBrand.map((e) =>
                                      DropdownMenuItem(
                                          value: e.code, child: Text(e
                                          .name!))).toList(),
                                  decoration: const InputDecoration(
                                    labelText: 'Brand',
                                    border: OutlineInputBorder(),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [


                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: ratioValueTxt,
                                  decoration:const InputDecoration(
                                    labelText: 'Ratio Value',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),

                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: ratioTxt,
                                  decoration:const InputDecoration(
                                    labelText: 'Ratio',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),

                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: priceTxt,
                                  decoration: const InputDecoration(
                                    labelText: 'Price',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),

                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: ourPriceTxt,
                                  decoration: const InputDecoration(
                                    labelText: 'Our Price',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [

                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: discountTxt,
                                  decoration: const InputDecoration(
                                    labelText: 'Discount',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),

                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: mrpTxt,
                                  decoration: const InputDecoration(
                                    labelText: 'MRP',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [

                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: cookingTimeTxt,
                                  decoration: const InputDecoration(
                                    labelText: 'Cooking Time (In Hours)',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),

                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: extraTimeTxt,
                                  decoration: const InputDecoration(
                                    labelText: 'Extra Time (In Hours)',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),

                        ],
                      ),
                      Padding(padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Obx(() {
                                return Checkbox(value: isNonVeg.value,
                                    onChanged: (val) {
                                      isNonVeg.value = val!;
                                    },activeColor: Colors.redAccent);
                              }),
                              const Text('Non Veg')
                            ],
                          )),
                      Padding(padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Obx(() {
                                return Checkbox(value: enableItems.value,
                                    onChanged: (val) {
                                      enableItems.value = val!;
                                    });
                              }),
                              Text('Enable')
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(onPressed: () {
                              Get.back();
                            }, child: Text('Close')),
                            const SizedBox(width: 10.0),
                            ElevatedButton(onPressed: () {
                              addItemApi();
                            }, child: Text('Create'))
                          ],
                        ),
                      )
                    ]),

              ),
            )
        )));
  }

  updateOpenItemDialog({required CatererItemModel model}) {
    itemNameTxt.text = model.name!;
    shortDescTxt.text = model.shortDesc!;
    longDescTxt.text = model.desc!;
    selectedCategory.value = model.category?.code;
    listOfSubCategoryApi(fromUpdate: true,subCategoryCode: model.subCategory?.code);
    // selectedSubCategory.value = model.subCategory?.code;
    selectedUnit.value = model.unit?.code;
    selectedBrand.value = model.brand?.code;
    ratioTxt.text = model.ratio!;
    ratioValueTxt.text = model.ratioValue!;
    priceTxt.text = model.price!;
    ourPriceTxt.text = model.ourPrice!;
    discountTxt.text = model.discount!;
    mrpTxt.text = model.mrp!;
    enableItems.value = model.itemEnable!;
    cookingTimeTxt.text = model.cookingTime.toString();
    extraTimeTxt.text = model.extraTime.toString();
    isNonVeg.value = model.nonVeg!;

    Get.dialog(Dialog(
        child: Container(
            height: Get.height * 0.8,
            width: Get.width * 0.33,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                    children: [
                      HeaderWidget(title: 'Modify Items', onTap: () {
                        Get.back();
                      },),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: itemNameTxt,
                          decoration:const InputDecoration(
                            labelText: 'Item Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: shortDescTxt,
                          decoration:const InputDecoration(
                            labelText: 'Short Description',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: longDescTxt,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: 'Long Description',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(() {
                                return DropdownButtonFormField<String>(
                                  value: selectedCategory.value,
                                  onChanged: (val) {
                                    selectedCategory.value = val;
                                    listOfSubCategoryApi();
                                  },
                                  items: listOfCategory.map((e) =>
                                      DropdownMenuItem(
                                          value: e.code, child: Text(e
                                          .name!))).toList(),
                                  decoration: const InputDecoration(
                                    labelText: 'Category',
                                    border: OutlineInputBorder(),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(() {
                                return DropdownButtonFormField<String>(
                                  value: selectedSubCategory.value,
                                  onChanged: (val) {
                                    selectedSubCategory.value = val;
                                  },
                                  items: listOfSubCategory.map((e) =>
                                      DropdownMenuItem(
                                          value: e.code, child: Text(e
                                          .name!))).toList(),
                                  decoration: const InputDecoration(
                                    labelText: 'Sub Category',
                                    border: OutlineInputBorder(),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(() {
                                return DropdownButtonFormField<String>(
                                  value: selectedUnit.value,
                                  onChanged: (val) {
                                    selectedUnit.value = val;
                                  },
                                  items: listOfUnit.map((e) =>
                                      DropdownMenuItem(
                                          value: e.code, child: Text(e
                                          .name!))).toList(),
                                  decoration: const InputDecoration(
                                    labelText: 'Unit',
                                    border: OutlineInputBorder(),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Obx(() {
                                return DropdownButtonFormField<String>(
                                  value: selectedBrand.value,
                                  onChanged: (val) {
                                    selectedBrand.value = val;
                                  },
                                  items: listOfBrand.map((e) =>
                                      DropdownMenuItem(
                                          value: e.code, child: Text(e
                                          .name!))).toList(),
                                  decoration: const InputDecoration(
                                    labelText: 'Brand',
                                    border: OutlineInputBorder(),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [


                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: ratioValueTxt,
                                  decoration: const InputDecoration(
                                    labelText: 'Ratio Value',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),

                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: ratioTxt,
                                  decoration: const InputDecoration(
                                    labelText: 'Ratio',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),

                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: priceTxt,
                                  decoration: const InputDecoration(
                                    labelText: 'Price',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),

                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: ourPriceTxt,
                                  decoration: const InputDecoration(
                                    labelText: 'Our Price',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [

                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: discountTxt,
                                  decoration: const InputDecoration(
                                    labelText: 'Discount',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),

                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: mrpTxt,
                                  decoration: const InputDecoration(
                                    labelText: 'MRP',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [

                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: cookingTimeTxt,
                                  decoration: const InputDecoration(
                                    labelText: 'Cooking Time (In Hours)',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: extraTimeTxt,
                                  decoration: const InputDecoration(
                                    labelText: 'Extra Time (In Hours)',
                                    border: OutlineInputBorder(),
                                  ),
                                )),
                          ),

                        ],
                      ),
                      Padding(padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Obx(() {
                                return Checkbox(value: isNonVeg.value,
                                    onChanged: (val) {
                                      isNonVeg.value = val!;
                                    },activeColor: Colors.redAccent);
                              }),
                              const Text('Non Veg')
                            ],
                          )),
                      Padding(padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Obx(() {
                                return Checkbox(value: enableItems.value,
                                    onChanged: (val) {
                                      enableItems.value = val!;
                                    });
                              }),
                              Text('Enable')
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(onPressed: () {
                              clearForm();
                            }, child: Text('Clear')),
                            SizedBox(width: 10.0),
                            ElevatedButton(onPressed: () {
                              updateItemApi(model.code);
                            }, child: Text('Update'))
                          ],
                        ),
                      )
                    ]),

              ),
            )
        )));
  }

  addItemApi() async {
    if (itemNameTxt.text
        .trim()
        .isEmpty) {
      customSnack(title: "Error", type: 'e', msg: 'Enter Item Name');
    }
    else if (shortDescTxt.text
        .trim()
        .isEmpty) {
      customSnack(title: "Error", type: 'e', msg: 'Enter Short Description');
    }
    else if (longDescTxt.text
        .trim()
        .isEmpty) {
      customSnack(title: "Error", type: 'e', msg: 'Enter Long Description');
    }
    else if (selectedCategory.value == null) {
      customSnack(title: "Error", type: 'e', msg: 'Select Category');
    }
    else if (selectedSubCategory.value == null) {
      customSnack(title: "Error", type: 'e', msg: 'Select Sub Category');
    }
    else if (selectedUnit.value == null) {
      customSnack(title: "Error", type: 'e', msg: 'Select Unit');
    }
    else if (ratioTxt.text
        .trim()
        .isEmpty) {
      customSnack(title: "Error", type: 'e', msg: 'Enter Ratio');
    }
    else if(ratioValueTxt.text.trim().isEmpty){
      customSnack(title: "Error", type: 'e', msg: 'Enter Ratio Value');
    }
    else if (priceTxt.text
        .trim()
        .isEmpty) {
      customSnack(title: "Error", type: 'e', msg: 'Enter Price');
    }
    else if (discountTxt.text
        .trim()
        .isEmpty) {
      customSnack(title: "Error", type: 'e', msg: 'Enter Discount');
    }
    else if (mrpTxt.text
        .trim()
        .isEmpty) {
      customSnack(title: "Error", type: 'e', msg: 'Enter MRP');
    }
    else {
      OverlayLoadingProgress.start(
          barrierDismissible: true, widget: const CustomLoadingProgress());
      var model = {
        "caterer_code":selectedCaterer.value!.code,
        "name": itemNameTxt.text.trim(),
        "short_desc": shortDescTxt.text.trim(),
        "desc": longDescTxt.text.trim(),
        "category": selectedCategory.value,
        "sub_category": selectedSubCategory.value,
        "unit": selectedUnit.value,
        "brand":selectedBrand.value,
        "ratio": ratioTxt.text.trim(),
        "ratio_value": ratioValueTxt.text.trim().isEmpty ? '0' : ratioValueTxt.text.trim(),
        "price": priceTxt.text.trim(),
        "our_price": ourPriceTxt.text.trim().isEmpty ? '0' : ourPriceTxt.text.trim(),
        "discount": discountTxt.text.trim(),
        "cooking_time": cookingTimeTxt.text.trim().isEmpty ? '0' : cookingTimeTxt.text.trim(),
        "extra_time": extraTimeTxt.text.trim().isEmpty ? '1' : extraTimeTxt.text.trim(),
        "mrp": mrpTxt.text.trim(),
        "non_veg": isNonVeg.value,
        "item_enable": enableItems.value,
      };
      var data = await CatererItemModel().addItemByCaterer(model);
      OverlayLoadingProgress.stop();
      if (data != null) {
        if (data['code'] == 200) {
          clearForm();
          loadProject();
          Get.back();
          customSnack(
              title: 'Success', type: 's', msg: '${data['data']['msg']}');
        }
        else {
          customSnack(title: 'Error', type: 'e', msg: '${data['data']['msg']}');
        }
      }
    }
  }

  updateItemApi(itemCode) async {
    if (itemNameTxt.text
        .trim()
        .isEmpty) {
      customSnack(title: "Error", type: 'e', msg: 'Enter Item Name');
    }
    else if (shortDescTxt.text
        .trim()
        .isEmpty) {
      customSnack(title: "Error", type: 'e', msg: 'Enter Short Description');
    }
    else if (longDescTxt.text
        .trim()
        .isEmpty) {
      customSnack(title: "Error", type: 'e', msg: 'Enter Long Description');
    }
    else if (selectedCategory.value == null) {
      customSnack(title: "Error", type: 'e', msg: 'Select Category');
    }
    else if (selectedSubCategory.value == null) {
      customSnack(title: "Error", type: 'e', msg: 'Select Sub Category');
    }
    else if (selectedUnit.value == null) {
      customSnack(title: "Error", type: 'e', msg: 'Select Unit');
    }
    else if (ratioTxt.text
        .trim()
        .isEmpty) {
      customSnack(title: "Error", type: 'e', msg: 'Enter Ratio');
    }
    else if(ratioValueTxt.text.trim().isEmpty){
      customSnack(title: "Error", type: 'e', msg: 'Enter Ratio Value');
    }
    else if (priceTxt.text
        .trim()
        .isEmpty) {
      customSnack(title: "Error", type: 'e', msg: 'Enter Price');
    }
    else if (discountTxt.text
        .trim()
        .isEmpty) {
      customSnack(title: "Error", type: 'e', msg: 'Enter Discount');
    }
    else if (mrpTxt.text
        .trim()
        .isEmpty) {
      customSnack(title: "Error", type: 'e', msg: 'Enter MRP');
    }
    else {
      OverlayLoadingProgress.start(
          barrierDismissible: true, widget: const CustomLoadingProgress());
      var model = {
        "caterer_code":selectedCaterer.value!.code,
        "code": itemCode,
        "name": itemNameTxt.text.trim(),
        "short_desc": shortDescTxt.text.trim(),
        "desc": longDescTxt.text.trim(),
        "category": selectedCategory.value,
        "sub_category": selectedSubCategory.value,
        "unit": selectedUnit.value,
        "brand":selectedBrand.value,
        "ratio": ratioTxt.text.trim(),
        "ratio_value": ratioValueTxt.text.trim().isEmpty ? '0' : ratioValueTxt.text.trim(),
        "price": priceTxt.text.trim(),
        "our_price": ourPriceTxt.text.trim().isEmpty ? '0' : ourPriceTxt.text.trim(),
        "discount": discountTxt.text.trim(),
        "mrp": mrpTxt.text.trim(),
        "non_veg": isNonVeg.value,
        "cooking_time": cookingTimeTxt.text.trim().isEmpty ? '0' : cookingTimeTxt.text.trim(),
        "extra_time": extraTimeTxt.text.trim().isEmpty ? '1' : extraTimeTxt.text.trim(),
        "item_enable": enableItems.value,
      };
      var data = await CatererItemModel().updateItemByCaterer(model);
      OverlayLoadingProgress.stop();
      if (data != null) {
        if (data['code'] == 200) {
          clearForm();
          loadProject();
          Get.back();
          customSnack(
              title: 'Success', type: 's', msg: '${data['data']['msg']}');
        }
        else {
          customSnack(title: 'Error', type: 'e', msg: '${data['data']['msg']}');
        }
      }
    }
  }

 Future<List<CatererModel>> getAllCaterers(name) async {
   List<CatererModel> catererList = [];
    var response = await CatererModel().listOfCatererBySearchName(name);
    if(response != null){
      if(response['code'] == 200){
        catererList = (response['data'] as List).map((e) => CatererModel.fromJson(e)).toList();
      }
    }
    return catererList;
    }

  var loadingImages = false;
  var itemImages = <CatererItemImagesModel>[];

  openImageDialog({itemCode, itemName,catererCode}) {
    Get.dialog(Dialog(
      child: CatererItemImagesPage(itemCode: itemCode,itemName: itemName,catererCode: catererCode,),
    ));
  }

  pickItemImages(itemCode,catererCode)async{
    var result = await FilePicker.platform.pickFiles(allowedExtensions: ['jpg','jpeg','png'],type: FileType.custom,withData: true);
    if(result != null){
      uploadItemImage(itemCode, result.files.first.bytes!,catererCode);
    }
  }

  getItemImages({required itemCode,required catererCode})async{
    loadingImages = true;
    update(['item_images']);
    var data = await CatererItemModel().listOfImagesByItemCode(itemCode,catererCode);
    if(data != null){
      if(data['code'] == 200){
        itemImages = (data['data'] as List).map((e) => CatererItemImagesModel.fromJson(e)).toList();
      }
    }
    loadingImages = false;
    update(['item_images']);
  }

  uploadItemImage(itemCode,Uint8List image,catererCode)async{
    var model = {
      'item_code': itemCode,
      'caterer_code': catererCode,
      'image': dio.MultipartFile.fromBytes(image,filename: 'image.png',contentType: MediaType('image','png'))
    };
    OverlayLoadingProgress.start(
        barrierDismissible: true, widget: const CustomLoadingProgress());
    var data = await CatererItemModel().uploadImage(model);
    OverlayLoadingProgress.stop();
    if(data != null){
      if(data['code'] == 200){
        customSnack(title: 'Success', type: 's', msg: '${data['data']['msg']}');
        getItemImages(itemCode: itemCode, catererCode: catererCode);
      }
      else{
        customSnack(title: 'Error', type: 'e', msg: '${data['data']['msg']}');
      }
    }
  }

  confirmImageDeletion({required itemCode,required imageCode,required catererCode})async{
    Get.defaultDialog(
        title: 'Confirm',
        middleText: 'Are you sure you want to delete this image?',
        textConfirm: 'Yes',
        textCancel: 'No',
        onConfirm: (){
          Get.back();
          deleteItemImages(itemCode: itemCode,imageCode: imageCode,catererCode: catererCode);
        }
    );
  }

  deleteItemImages({required itemCode,required imageCode,required catererCode})async{
    var model = {
      'item_code': itemCode,
      'code': imageCode
    };
    OverlayLoadingProgress.start(
        barrierDismissible: true, widget: const CustomLoadingProgress());
    var data = await CatererItemModel().deleteImageByItemCode(model);
    OverlayLoadingProgress.stop();
    if(data != null){
      if(data['code'] == 200){
        customSnack(title: 'Success', type: 's', msg: '${data['data']['msg']}');
        getItemImages(itemCode: itemCode, catererCode: catererCode);
      }
      else{
        customSnack(title: 'Error', type: 'e', msg: '${data['data']['msg']}');
      }
    }
  }
  }
