import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/controller/inventory/unit_controller.dart';
import 'package:feastly_dashboard/views/unit/unit_form_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/side_menu_items.dart';


class UnitPage extends StatelessWidget {
   UnitPage({super.key});
 final UnitController uc = Get.put(UnitController());

  @override
  Widget build(BuildContext context) {
    uc.getListOfUnits();
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: SideMenuItems()),
          Expanded(
              flex: flexValue,
              child: Column(
                children: [
                  const HeaderWidget(title: "Units"),
                  Expanded(child: UnitFormPage())
                ],
              ))
        ],
      ),
    );
  }
}
