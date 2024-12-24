
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/side_menu_items.dart';


class AddCustomers extends StatelessWidget {
  const AddCustomers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: SideMenuItems()),
          Expanded(
            flex: flexValue,
            child: Scaffold(
              appBar: AppBar(),
              body: Center(child: Text('AddItems'),),
            ),
          ),
        ],
      ),
    );
  }
}
