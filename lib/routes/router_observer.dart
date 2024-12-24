import '../controller/side_bar_controller.dart';
import '../routes/string_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


class RouterObserver extends GetObserver{

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final SideBarController sideBarController = Get.put(SideBarController());

    if(previousRoute != null){
      if(previousRoute.settings.name != null){
      for(var routeName in StringRouts.sideBarMenuItems){
        if(previousRoute.settings.name == routeName.name){

          sideBarController.activeItem.value = routeName.name;
        }
      }
      }
    }
  }

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final SideBarController sideBarController = Get.put(SideBarController());

    if(route != null){
      if(route.settings.name != null){
      for(var routeName in StringRouts.sideBarMenuItems) {
        if (route.settings.name!.toLowerCase() == routeName.name) {
          sideBarController.activeItem.value = routeName.name;
        }
      }
      }
    }
  }
}