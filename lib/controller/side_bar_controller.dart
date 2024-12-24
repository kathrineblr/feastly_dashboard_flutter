
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/dash_user_model.dart';
import '../routes/string_routes.dart';
import '../shared_services.dart';

class SideBarController extends GetxController{

  var activeItem = StringRouts.dashboard.obs;

  var dashUserModel = Rxn<DashUserModel>();


  getDashUserData()async{
    dashUserModel.value = await SharedServices.loginDetails();
  }

  @override
  void onInit() {
    getDashUserData();
    super.onInit();
  }


  logout(){
    Get.defaultDialog(
        content: Text('Are you sure want to logout?',style: Get.textTheme.titleMedium,),
        contentPadding: const EdgeInsets.all(10.0),
        actions: [
          FilledButton(onPressed: (){Get.back();}, child: const Text(' No ')),
          FilledButton(onPressed: (){
            Get.back();
            SharedServices.logOut().then((val){
              Get.offAllNamed(StringRouts.login);
            });
          }, child: const Text('Logout'))
        ]
    );
  }
}