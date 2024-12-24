import 'package:data_table_2/data_table_2.dart';
import 'package:feastly_dashboard/models/dash_user_model.dart';
import 'package:feastly_dashboard/widgets/custom_snackbar.dart';
import 'package:feastly_dashboard/widgets/header_widget.dart';
import 'package:feastly_dashboard/widgets/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_kit/overlay_kit.dart';


class UserController extends GetxController{

  var roleList = ['Admin','User'];
  var selectedRole = Rxn<String>();

  var nameTxt = TextEditingController();
  var userNameTxt = TextEditingController();
  var phoneTxt = TextEditingController();
  var passwordTxt = TextEditingController();
  var addressTxt = TextEditingController();

  var columList = const [
    DataColumn2(label: Text('SLNO.'),size: ColumnSize.S),
    DataColumn2(label: Text('Name'),size: ColumnSize.M),
    DataColumn2(label: Text('User Name'),size: ColumnSize.M),
    DataColumn2(label: Text('Phone'),size: ColumnSize.M),
    DataColumn2(label: Text('Address'),size: ColumnSize.L),
  ];

  var usersList = <DashUserModel>[];


  getUsers()async{
    var data = await DashUserModel().getAllUsers();
    if(data != null){
      if(data['code'] == 200){
        usersList = (data['data'] as List).map((e)=>DashUserModel.fromJson(e)).toList();
      }
    }
    update(['user_list']);
  }

  clearForm(){
     selectedRole.value = null;

     nameTxt.clear();
     userNameTxt.clear();
     phoneTxt.clear();
     passwordTxt.clear();
     addressTxt.clear();
  }

  addUserDialog(){
    clearForm();
    Get.dialog(Dialog(
      child: Container(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             HeaderWidget(title: 'Add User',onTap: (){Get.back();},),
             Container(
               padding: EdgeInsets.all(10.0),
               child: Column(
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text('Name*',style: Get.textTheme.titleMedium),
                       TextField(
                         controller: nameTxt,
                         style: Get.textTheme.bodyMedium,
                       )
                     ],
                   ),
                   Row(
                     children: [
                       Expanded(child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text('Phone/Mobile',style: Get.textTheme.titleMedium),
                           TextField(
                             controller: phoneTxt,
                             style: Get.textTheme.bodyMedium,
                           )
                         ],
                       ),),
                       const SizedBox(width: 5.0),
                       Expanded(child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text('Role*',style: Get.textTheme.titleMedium),
                           Container(
                             decoration: BoxDecoration(
                               border: Border.all(color: Colors.grey),
                               borderRadius: BorderRadius.circular(5.0),
                             ),
                             child: DropdownButtonHideUnderline(child: Obx(
                                 ()=> DropdownButton(
                                   value: selectedRole.value,
                                   padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 3.0),
                                   hint: Text("Select Role"),
                                   style: Get.textTheme.bodyMedium,
                                   isDense: true,
                                   isExpanded: true,
                                   items: roleList.map((e){
                                     return DropdownMenuItem(
                                       value: e,
                                         child: Text(e));
                                   }).toList(), onChanged: (val){
                                     selectedRole.value = val;
                                 }),
                             )),
                           ),
                         ],
                       ),),
                     ],
                   ),
                   Row(
                     children: [
                       Expanded(child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text('User name*',style: Get.textTheme.titleMedium),
                           TextField(
                             controller: userNameTxt,
                             style: Get.textTheme.bodyMedium,
                           )
                         ],
                       ),),
                       const SizedBox(width: 5.0),
                       Expanded(child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text('Password*',style: Get.textTheme.titleMedium),
                           TextField(
                             controller: passwordTxt,
                             style: Get.textTheme.bodyMedium,
                           )
                         ],
                       ),),
                     ],
                   ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text('Address',style: Get.textTheme.titleMedium),
                       TextField(
                         controller: addressTxt,
                         style: Get.textTheme.bodyMedium,
                         maxLines: 4,
                       )
                     ],
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         FilledButton(onPressed: (){Get.back();}, child: Text('Close')),
                         const SizedBox(width: 10.0),
                         FilledButton(onPressed: (){addUserApi();}, child: Text('Add User')),
                       ],
                     ),
                   )
                 ],
               ),
             )
          ],
        ),
      ),
    ));
  }

  addUserApi()async{
    if(nameTxt.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter name');
    }
    else if(userNameTxt.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter user name');
    }
    else if(passwordTxt.text.trim().isEmpty){
      customSnack(type: 'e',title: 'Error',msg: 'Enter password');
    }
    else if(selectedRole.value == null){
      customSnack(type: 'e',title: 'Error',msg: 'Select Role');
    }
    else{
      OverlayLoadingProgress.start(barrierDismissible: true,widget: const CustomLoadingProgress());
      var model = {
        "name": nameTxt.text.trim(),
        "phone":phoneTxt.text.trim(),
        "user_name": userNameTxt.text.trim(),
        "password": passwordTxt.text.trim(),
        "address": addressTxt.text.trim(),
        "created_user": '',
        "role": selectedRole.value,
      };
      var data = await DashUserModel().addUsers(model);
      OverlayLoadingProgress.stop();
      if(data != null) {
        if (data['code'] == 200) {
          getUsers();
          Get.back();
          customSnack(title: 'Success',type: 's',msg: '${data['data']['msg']}');
        }
        else{
          customSnack(title: 'Error',type: 'e',msg: '${data['data']['msg']}');
        }
      }
    }
  }
}