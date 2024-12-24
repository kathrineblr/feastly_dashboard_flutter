import '../constants/colors.dart';
import '../constants/strings.dart';
import '../controller/side_bar_controller.dart';
import '../routes/string_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SideMenuItems extends StatelessWidget {
   SideMenuItems({super.key});
   final SideBarController sideBarController = Get.find<SideBarController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowColor,
      body: Column(
        children: [
          Image.asset(Strings.appLogoPath,height: 120,width: context.width,),
          Obx(
                ()=> Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Hi!, ${sideBarController.dashUserModel.value == null ? '' : sideBarController.dashUserModel.value!.name}',style: Get.textTheme.titleMedium,),
                ),
              ],
            ),
          ),
          Expanded(child: ListView.builder(
              itemCount: StringRouts.sideBarMenuItems.length,
              itemBuilder: (context,index){
                var items = StringRouts.sideBarMenuItems[index];
                Color tileColor = items.name == sideBarController.activeItem.value ? themeColor : yellowColor;
                Color iconColor = items.name == sideBarController.activeItem.value ? yellowColor : themeColor;
                Color textColor = items.name == sideBarController.activeItem.value ? yellowColor : themeColor;
                return Column(
                  children: [
                if(items.value == 'Settings')  Divider(endIndent: 10.0,indent: 10.0,thickness: 0.07,color: themeColor.withOpacity(0.7),),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ListTile(
                        title: Text(items.value,style: Get.textTheme.bodyMedium!.copyWith(color:  textColor),),
                        onTap: (){
                          Get.toNamed(items.name);
                        },
                        iconColor: iconColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        leading: items.icon,
                        tileColor: tileColor,
                      ),
                    ),
                  ],
                );
              })),
          ListTile(
            title: Text('Logout',style: Get.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),),
            onTap: (){
              sideBarController.logout();
            },
            leading: Icon(Icons.logout),
          )
        ],
      ),
    );
  }
}
