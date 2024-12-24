
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants/colors.dart';

class CustomLoadingProgress extends StatelessWidget {
 final Color? color;
  const CustomLoadingProgress({super.key,this.color});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.fourRotatingDots(color: color ?? yellowColor, size: 30);
  }
}
