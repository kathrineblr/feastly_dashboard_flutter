
import 'package:feastly_dashboard/routes/string_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../shared_services.dart';

var isDialogOpened = false;

authFailedFunc({msg}) {
  if (!isDialogOpened) {
    isDialogOpened = true;
    Get.defaultDialog(
        content: Text(
          msg,
          style: Get.textTheme.bodySmall,
        ),
        barrierDismissible: false,
        contentPadding: const EdgeInsets.all(10.0),
        onConfirm: () {
          isDialogOpened = false;
          Get.back();
          SharedServices.logOut().then((value) {
            Get.toNamed(StringRouts.login);
          });
        });
  }
}

