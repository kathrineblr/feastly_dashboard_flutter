
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../routes/string_routes.dart';
import '../widgets/side_menu_items.dart';


class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: SideMenuItems()),
          Expanded(
              flex: flexValue,
              child: Column(
                children: [
                  const Text('Customer Page'),
                  FilledButton(onPressed: (){
                  }, child: Text('Add Page'))
                ],
              ))
        ],
      ),
    );
  }
}
