import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final Function()? onTap;
  const HeaderWidget({super.key,required this.title,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(title,style: Get.textTheme.titleLarge!.copyWith(color: Colors.grey,fontWeight: FontWeight.w600),),
        ),
        if(onTap != null) IconButton(onPressed: onTap, icon: Icon(Icons.close))
      ],
    );
  }
}
