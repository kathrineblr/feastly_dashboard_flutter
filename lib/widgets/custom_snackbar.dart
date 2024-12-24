import 'package:flutter/material.dart';
import 'package:get/get.dart';


   customSnack({title,type,msg}){
     Get.snackbar(title, msg,
       snackPosition: SnackPosition.BOTTOM,
       colorText: Colors.white,
       duration: 2.seconds,
       maxWidth: Get.context!.width * 0.4,
       backgroundColor: type == 'e' ? Colors.red : Colors.green
     );
   }