import 'package:feastly_dashboard/controller/setting_controller.dart';
import 'package:feastly_dashboard/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../widgets/side_menu_items.dart';

class SettingMainPage extends StatelessWidget {
  SettingMainPage({super.key});

  final SettingController sc = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    sc.getRangeSettings();
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: SideMenuItems()),
          Expanded(
              flex: flexValue,
              child: Column(
                children: [
                 const HeaderWidget(title: 'Settings'),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                       Row(
                         children: [
                           Expanded(child: Card(
                             child: Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Text('Range in Km',style: Get.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),),
                                   ),
                                   TextField(
                                      controller: sc.rangeInKm,
                                     style: Get.textTheme.bodyMedium,
                                   ),
                                   Padding(
                                     padding: const EdgeInsets.symmetric(vertical: 20.0),
                                     child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          FilledButton(onPressed: (){
                                            sc.updateRangeInKm();
                                          }, child: const Text('Update'))
                                        ],
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           )),
                           const SizedBox(width: 10.0,),
                           Expanded(child: Card(
                             child: Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Text('Cancellation Charges ( % )',style: Get.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),),
                                   ),
                                   TextField(
                                      controller: sc.cancellationChargeInPerc,
                                     style: Get.textTheme.bodyMedium,
                                   ),
                                   Padding(
                                     padding: const EdgeInsets.symmetric(vertical: 20.0),
                                     child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          FilledButton(onPressed: (){
                                            sc.updateCancellationChargeInPerc();
                                          }, child: const Text('Update'))
                                        ],
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           )),
                            const SizedBox(width: 10.0,),
                            Expanded(child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Cancellation Time ( Hours )',style: Get.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),),
                                    ),
                                    TextField(
                                        controller: sc.cancellationTimeInHours,
                                      style: Get.textTheme.bodyMedium,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            FilledButton(onPressed: (){
                                              sc.updateCancellationTimeInHours();
                                            }, child: const Text('Update'))
                                          ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                         ],
                       )
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
