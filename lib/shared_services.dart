 import  'dart:convert';

import 'package:feastly_dashboard/models/dash_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedServices{
  static Future<bool> isLoggedIn() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_details")!=null ? true: false;
  }
  static Future<void> setLoginDetails(DashUserModel? userModel)async{
    final prefs = await SharedPreferences.getInstance();

    if (userModel !=null){
      prefs.setString('login_details',jsonEncode(userModel.toJson()));
      return;
    }
    else{
      prefs.remove('login_details');
      return;
    }
  }
  static Future<DashUserModel?> loginDetails()async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString('login_details') != null){
      return DashUserModel.fromJson(json.decode(prefs.getString('login_details')!));
    }
    else{
      return null;
    }
  }
  static Future<void> logOut() async{
    await setLoginDetails(null);
  }

 }