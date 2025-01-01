
import 'package:feastly_dashboard/views/brands/brands_page.dart';
import 'package:feastly_dashboard/views/categories/categories_page.dart';
import 'package:feastly_dashboard/views/caterers/caterors_page.dart';
import 'package:feastly_dashboard/views/item_masters/item_master_page.dart';
import 'package:feastly_dashboard/views/orders/orders_page.dart';
import 'package:feastly_dashboard/views/settings/setting_main_page.dart';
import 'package:feastly_dashboard/views/sub_category/sub_category_page.dart';
import 'package:feastly_dashboard/views/unit/unit_page.dart';
import 'package:feastly_dashboard/views/users/users_page.dart';
import 'package:get/get.dart';

import '../views/add_customers.dart';
import '../views/customer_page.dart';
import '../views/login_page.dart';
import '../views/overview_page.dart';
import 'string_routes.dart';

class Routers{

  static final List<GetPage> pages = [
    GetPage(name: StringRouts.login, page: ()=> LoginPage()),
    GetPage(name: StringRouts.dashboard, page: ()=> OverviewPage()),
    GetPage(name: StringRouts.users, page: ()=> UsersPage()),
    GetPage(name: StringRouts.caterersDetails, page: ()=> CaterersPage()),
    GetPage(name: StringRouts.customers, page: ()=> CustomerPage()),
    GetPage(name: StringRouts.categories, page: ()=> CategoriesPage()),
    GetPage(name: StringRouts.subCategories, page: ()=> SubCategoryPage()),
    GetPage(name: StringRouts.units, page: ()=> UnitPage()),
    GetPage(name: StringRouts.brands, page: ()=> BrandsPage()),
    GetPage(name: StringRouts.itemMasters, page: ()=> ItemMasterPage()),
    GetPage(name: StringRouts.orders, page: ()=> OrdersPage()),
    GetPage(name: StringRouts.settings, page: ()=> SettingMainPage()),
  ];
}