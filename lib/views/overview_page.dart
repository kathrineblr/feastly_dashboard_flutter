import '../constants/colors.dart';
import '../constants/constants.dart';
import '../widgets/header_widget.dart';
import '../widgets/side_menu_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: SideMenuItems()),
          Expanded(
              flex: flexValue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderWidget(title: "Overview"),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
                      children: [
                        Card(
                          elevation:5,
                          child: Container(
                            height: 120,
                            width: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(color: yellowColor,
                                              borderRadius: const BorderRadius.only(topRight: Radius.circular(8.0),topLeft: Radius.circular(8.0))
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Customers',style: Get.textTheme.titleMedium!.copyWith(color: themeColor,fontWeight: FontWeight.w700)),
                                          )),
                                    ),
                                  ],
                                ),
                                Expanded(child: Center(child: Text('0',style: Get.textTheme.displaySmall!.copyWith(color: themeColor),),))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0,),
                        Card(
                          elevation:5,
                          child: Container(
                            height: 120,
                            width: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(color: yellowColor,
                                              borderRadius: const BorderRadius.only(topRight: Radius.circular(8.0),topLeft: Radius.circular(8.0))
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Orders',style: Get.textTheme.titleMedium!.copyWith(color: themeColor,fontWeight: FontWeight.w700)),
                                          )),
                                    ),
                                  ],
                                ),
                                Expanded(child: Center(child: Text('0',style: Get.textTheme.displaySmall!.copyWith(color: themeColor),),))
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 10.0,),
                        Card(
                          elevation:5,
                          child: Container(
                            height: 120,
                            width: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(color: yellowColor,
                                              borderRadius: const BorderRadius.only(topRight: Radius.circular(8.0),topLeft: Radius.circular(8.0))
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Caterers',style: Get.textTheme.titleMedium!.copyWith(color: themeColor,fontWeight: FontWeight.w700)),
                                          )),
                                    ),
                                  ],
                                ),
                                Expanded(child: Center(child: Text('0',style: Get.textTheme.displaySmall!.copyWith(color: themeColor),),))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
