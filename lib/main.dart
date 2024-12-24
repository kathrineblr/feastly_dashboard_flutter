import 'package:dynamic_path_url_strategy/dynamic_path_url_strategy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_kit/overlay_kit.dart';

import 'constants/colors.dart';
import 'routes/router_observer.dart';
import 'routes/routers.dart';
import 'routes/string_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlayKit(
      child: GetMaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
          useMaterial3: true,
          filledButtonTheme: FilledButtonThemeData(
            style: ButtonStyle(shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))))
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
            isDense: true,
            isCollapsed: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 10.0)
          )
        ),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          RouterObserver()
        ],
        getPages: Routers.pages,
        initialRoute: StringRouts.login,
        unknownRoute: GetPage(name: '/notfound', page: ()=> const Scaffold(body: Center(child: Text('Page not found'),),)),
      ),
    );
  }
}

