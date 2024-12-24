import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/controller/inventory/brand_controller.dart';
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
                  Expanded(child: Row(
                    children: [
                      Expanded(
                          flex:2,
                          child: Container(
                            margin:const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)
                            ),
                            child: GetBuilder<BrandController>(
                                id: 'brand_list',
                                builder: (con) {
                                  return DataTable2                                                                                                    (
                                      columnSpacing: 12,
                                      horizontalMargin: 12,
                                      minWidth: 800,
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
                                      rows: List.generate(con.brandList.length, (index){
                                        var userData = con.brandList[index];
                                        return DataRow2(
                                            color: cc.selectedBrand?.name == userData.name  ? WidgetStatePropertyAll(Colors.grey.shade300) : null,
                                            onTap: (){
                                              cc.selectBrandFunc(index);
                                            },
                                            cells: [
                                              DataCell(Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [Text('${index+1}')],)),
                                              DataCell(Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text('${userData.code}')],)),
                                              DataCell(Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text('${userData.name}'),],)),
                                            ]);
                                      }));
                                }
                            ),
                          )),
                      Expanded(child:Container(
                        margin:const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
                        padding:const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 8.0),
                              child: Text('Brand',style: Get.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w700)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Brand Name',style: Get.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 2.0,),
                                  TextField(
                                    controller: cc.brandName,
                                    style: Get.textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FilledButton(onPressed: (){
                                    cc.clearFrom();
                                  }, child: Text('Clear')),
                                  const SizedBox(width: 10.0),
                                  FilledButton(onPressed: (){
                                    if(cc.enableUpdate.value){
                                      cc.updateBrandApi();
                                    }
                                    else {
                                      cc.addBrandApi();
                                    }
                                  }, child: Text('Create'))
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                    ],
                  ))
                ],
              ))
        ],
      ),
    );
  }
}
