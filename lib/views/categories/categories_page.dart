import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/views/categories/category_form_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../controller/inventory/category_controller.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/side_menu_items.dart';


class CategoriesPage extends StatelessWidget {
   CategoriesPage({super.key});

   final CategoryController cc = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    cc.getListOfCategory();
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: SideMenuItems()),
          Expanded(
              flex: flexValue,
              child: Column(
                children: [
                  const HeaderWidget(title: "Categories"),
                  Expanded(child: CategoryFormPage())
                ],
              ))
        ],
      ),
    );
  }
}
