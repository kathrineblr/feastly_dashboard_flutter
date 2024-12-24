import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../widgets/side_menu_items.dart';


class CaterorsPage extends StatelessWidget {
  const CaterorsPage({super.key});

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
                  const Text('Caterers'),
                ],
              ))
        ],
      ),
    );
  }
}
