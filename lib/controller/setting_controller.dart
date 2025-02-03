import 'package:feastly_dashboard/models/settings/range_setting_model.dart';
import 'package:feastly_dashboard/widgets/custom_snackbar.dart';
import 'package:feastly_dashboard/widgets/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_kit/overlay_kit.dart';


class SettingController extends GetxController{

  var rangeInKm = TextEditingController();
  var cancellationTimeInHours = TextEditingController();
  var cancellationChargeInPerc = TextEditingController();

  getRangeSettings()async{
    var data = await RangeSettingModel().getRangeSettings();
    if(data != null){
      RangeSettingModel model = RangeSettingModel.fromJson(data['data']);
      rangeInKm.text = model.rangeInKm.toString();
      cancellationTimeInHours.text = model.cancellationTimeInHours.toString();
      cancellationChargeInPerc.text = model.cancellationChargeInPerc.toString();
    }
  }

  updateRangeInKm()async{
    if(rangeInKm.text.trim().isEmpty){
      customSnack(title: 'Error', msg: 'Range in km is required',type: 'e');
    }
    else{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        "user_name":'',
        "range_in_km": rangeInKm.text.trim(),
      };
      var data = await RangeSettingModel().updateRangeInKm(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          customSnack(
              title: 'Success', msg: '${data['data']['msg']}', type: 's');
        }
        else {
          customSnack(title: 'Error', msg: '${data['data']['msg']}', type: 'e');
        }
      }
    }
  }

  updateCancellationTimeInHours()async{
    if(cancellationTimeInHours.text.trim().isEmpty){
      customSnack(title: 'Error', msg: 'Cancellation time in hours is required',type: 'e');
    }
    else{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        'user_name':'',
        "cancellation_time_in_hours": cancellationTimeInHours.text.trim(),
      };
      var data = await RangeSettingModel().updateCancellationTimeInHours(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          customSnack(
              title: 'Success', msg: '${data['data']['msg']}', type: 's');
        }
        else {
          customSnack(title: 'Error', msg: '${data['data']['msg']}', type: 'e');
        }
      }
    }
  }

  updateCancellationChargeInPerc()async{
    if(cancellationChargeInPerc.text.trim().isEmpty){
      customSnack(title: 'Error', msg: 'Cancellation charge in percentage is required',type: 'e');
    }
    else{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        'user_name':'',
        "cancellation_charge_in_perc": cancellationChargeInPerc.text.trim(),
      };
      var data = await RangeSettingModel().updateCancellationChargeInPerc(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          customSnack(
              title: 'Success', msg: '${data['data']['msg']}', type: 's');
        }
        else {
          customSnack(title: 'Error', msg: '${data['data']['msg']}', type: 'e');
        }
      }
    }
  }
}