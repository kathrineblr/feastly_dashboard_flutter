import 'package:feastly_dashboard/constants/colors.dart';
import 'package:feastly_dashboard/constants/strings.dart';
import 'package:feastly_dashboard/controller/login_controller.dart';
import 'package:feastly_dashboard/routes/string_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class LoginPage extends StatelessWidget {
   LoginPage({super.key});

   LoginController lc = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal:context.width * 0.35),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: context.height * 0.3,
                  decoration: BoxDecoration(
                    color: yellowColor,
                    image: DecorationImage(image: AssetImage(Strings.appLogoPath)),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0))
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('User Login',style: Get.textTheme.titleMedium!.copyWith(color: themeColor,fontWeight: FontWeight.w600),),
                      ),
                      TextField(
                        controller: lc.userName,
                        autofocus: true,
                        decoration: InputDecoration(
                          label: Text('User name'),
                        ),
                        onEditingComplete: (){
                          lc.loginUser();
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Obx(
                        ()=> TextField(
                          controller: lc.passwordName,
                          obscureText: lc.visibilityHide.value,
                          decoration: InputDecoration(
                            label: Text('Password'),
                            suffixIcon: IconButton(onPressed: (){
                              lc.visibilityHide.value = !lc.visibilityHide.value;
                            }, icon: lc.visibilityHide.value ? Icon(Icons.visibility) : Icon(Icons.visibility_off))
                          ),
                          onEditingComplete: (){
                            lc.loginUser();
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(child: FilledButton(onPressed: (){
                            lc.loginUser();
                          }, child: Text(' Login ')))
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:20),
                            child: Obx(()=> Text('Version: ${lc.versionString.value}',style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),)),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
