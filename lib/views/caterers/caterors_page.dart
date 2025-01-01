import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../controller/caterer_controller.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/side_menu_items.dart';


class CaterersPage extends StatelessWidget {
   CaterersPage({super.key});

   final CatererController cc = Get.put(CatererController());
  @override
  Widget build(BuildContext context) {
    cc.getCaterers();
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: SideMenuItems()),
          Expanded(
              flex: flexValue,
              child: Column(
                children: [
                  const HeaderWidget(title: 'Caterers'),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilledButton.icon(onPressed: (){
                                  cc.addCatererDialog();
                                }, label: Text('Add Caterer'),icon: Icon(Icons.add),)
                              ],
                            ),
                            Expanded(
                              child: GetBuilder<CatererController>(
                                  id: 'caterer_list',
                                  builder: (con) {
                                    return Card(
                                      child: DataTable2                                                                                                    (
                                          columnSpacing: 12,
                                          horizontalMargin: 12,
                                          minWidth: 1000,
                                          headingRowHeight: 30,
                                          dataRowHeight: 30,
                                          dataTextStyle: Get.textTheme.bodySmall!,
                                          headingRowColor: WidgetStatePropertyAll(yellowColor),
                                          headingRowDecoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey)
                                          ),
                                          headingTextStyle: Get.textTheme.titleSmall!
                                              .copyWith(fontWeight: FontWeight.bold),
                                          empty: const Center(child: Text('No Data Found')),
                                          border: const TableBorder(verticalInside: BorderSide(
                                              color: Colors.grey, width: 0.2)),
                                          isHorizontalScrollBarVisible: true,
                                          isVerticalScrollBarVisible: true,
                                          columns: con.columList,
                                          rows: List.generate(con.catererList.length, (index){
                                            var data = con.catererList[index];
                                            return DataRow(cells: [
                                              DataCell(Column(children: [Text('${index+1}')],)),
                                              DataCell(Column(children: [Text('${data.code}')],)),
                                              DataCell(Column(children: [Text('${data.name}')],)),
                                              DataCell(Column(children: [Text('${data.ownerName}')],)),
                                              DataCell(Column(children: [Text('${data.ownerPhone}')],)),
                                              DataCell(Column(children: [Text('${data.address}')],)),
                                              DataCell(Column(children: [IconButton(onPressed: (){
                                                cc.modifyCatererDialog(model: data);
                                              }, icon: Icon(Icons.edit))],)),
                                            ]);
                                          })),
                                    );
                                  }
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ))
        ],
      ),
    );
  }
}
