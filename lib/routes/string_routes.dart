
import 'package:flutter/material.dart';

import '../models/side_menu_model.dart';

class StringRouts{

  static String login = '/login';
  static String dashboard = '/dashboard';
  static String users = '/users';
  static String customers = '/customers';
  static String categories = '/categories';
  static String subCategories = '/subcategories';
  static String units = '/units';
  static String brands = '/brands';
  static String itemMasters = '/items';
  static String caterersDetails = '/caterers';
  static String orders = '/orders';
  static String settings = '/settings';


  static List<SideMenuModel> sideBarMenuItems = [
    SideMenuModel(name: dashboard, value: 'Dashboard', icon: const Icon(Icons.dashboard_outlined)),
    SideMenuModel(name: users, value: 'Users', icon: const Icon(Icons.person_2_outlined)),
    SideMenuModel(name: caterersDetails, value: 'Caterers', icon: const Icon(Icons.coffee_outlined)),
    SideMenuModel(name: customers, value: 'Customers', icon: const Icon(Icons.people_outline)),
    SideMenuModel(name: categories, value: 'Categories', icon: const Icon(Icons.category_outlined)),
    SideMenuModel(name: subCategories, value: 'Sub Categories', icon: const Icon(Icons.category_outlined)),
    SideMenuModel(name: units, value: 'Units', icon: const Icon(Icons.ad_units_outlined)),
    SideMenuModel(name: brands, value: 'Brands', icon: const Icon(Icons.branding_watermark_outlined)),
    SideMenuModel(name: itemMasters, value: 'Items', icon: const Icon(Icons.list_alt_outlined)),
    SideMenuModel(name: orders, value: 'Orders', icon: const Icon(Icons.shopping_cart)),
    SideMenuModel(name: settings, value: 'Settings', icon: const Icon(Icons.settings_outlined)),
  ];
}