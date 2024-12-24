

import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/constants/colors.dart';
import 'package:feastly_dashboard/controller/user_controller.dart';
import 'package:feastly_dashboard/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../widgets/side_menu_items.dart';

class UsersPage extends StatelessWidget {
   UsersPage({super.key});
   final UserController uc = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    uc.getUsers();
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: SideMenuItems()),
          Expanded(
              flex: flexValue,
              child: Column(
                children: [
                  const HeaderWidget(title: 'Users'),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilledButton.icon(onPressed: (){
                                  uc.addUserDialog();
                                }, label: Text('Add User'),icon: Icon(Icons.add),)
                              ],
                            ),
                            Expanded(
                              child: GetBuilder<UserController>(
                                id: 'user_list',
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
                                    rows: List.generate(con.usersList.length, (index){
                                      var userData = con.usersList[index];
                                      return DataRow(cells: [
                                        DataCell(Column(children: [Text('${index+1}')],)),
                                        DataCell(Column(children: [Text('${userData.name}')],)),
                                        DataCell(Column(children: [Text('${userData.userName}')],)),
                                        DataCell(Column(children: [Text('${userData.phone}')],)),
                                        DataCell(Column(children: [Text('${userData.address}')],)),
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
