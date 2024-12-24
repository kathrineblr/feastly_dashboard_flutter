import 'package:feastly_dashboard/routes/string_routes.dart';
import 'package:feastly_dashboard/shared_services.dart';
import 'package:feastly_dashboard/widgets/custom_snackbar.dart';
import 'package:feastly_dashboard/widgets/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/dash_user_model.dart';


class LoginController extends GetxController{

  var userName = TextEditingController();
  var passwordName = TextEditingController();
  var visibilityHide = true.obs;

  var versionString = ''.obs;

  getVersion()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionString.value = packageInfo.version;
  }


  loginUser()async{
    if(userName.text.trim().isEmpty){
      customSnack(title: 'Error',type: 'e',msg: 'Enter user name');
    }
    else if(userName.text.trim().isEmpty){
      customSnack(title: 'Error',type: 'e',msg: 'Enter password');
    }
    else{
      OverlayLoadingProgress.start(widget: const CustomLoadingProgress(),barrierDismissible: true);
      var model = {
        "user_name":userName.text.trim(),
        "password":passwordName.text.trim()
      };
      var data = await DashUserModel().loginApi(model);
      OverlayLoadingProgress.stop();
      if(data != null){
        if(data['code'] == 200){
          await SharedServices.setLoginDetails(DashUserModel.fromJson(data['data']['data']));
          Get.offAllNamed(StringRouts.dashboard);
        }
        else{
          customSnack(title: 'Error',type: 'e',msg: "${data['data']['msg']}");
        }
      }
    }
  }

  @override
  void onInit() {
    getVersion();
    super.onInit();
  }
}