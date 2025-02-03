import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/controller/inventory/brand_controller.dart';
import 'package:feastly_dashboard/views/brands/brand_form_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/side_menu_items.dart';


class BrandsPage extends StatelessWidget {
   BrandsPage({super.key});

   final BrandController cc = Get.put(BrandController());

  @override
  Widget build(BuildContext context) {
    cc.getListOfBrands();
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: SideMenuItems()),
          Expanded(
              flex: flexValue,
              child: Column(
                children: [
                  const HeaderWidget(title: "Brands"),
                  Expanded(child: BrandFormPage())
                ],
              ))
        ],
      ),
    );
  }
}
