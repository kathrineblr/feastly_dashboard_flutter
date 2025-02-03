import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/controller/inventory/sub_category_controller.dart';
import 'package:feastly_dashboard/views/sub_category/sub_category_form_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/side_menu_items.dart';


class SubCategoryPage extends StatelessWidget {
   SubCategoryPage({super.key});

   final SubCategoryController scc = Get.put(SubCategoryController());

  @override
  Widget build(BuildContext context) {
    scc.getListOfCategory();
    scc.getListOfSubCategory();
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: SideMenuItems()),
          Expanded(
              flex: flexValue,
              child: Column(
                children: [
                  const HeaderWidget(title: "Sub Categories"),
                  Expanded(child: SubCategoryFormPage())
                ],
              ))
        ],
      ),
    );
  }
}
