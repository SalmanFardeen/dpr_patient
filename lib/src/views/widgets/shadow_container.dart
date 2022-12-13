import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;
  Color? color;
  EdgeInsets? padding;
  EdgeInsets? margin;
  final double radius;
  final LinearGradient? gradient;

  ShadowContainer(
      {Key? key,
      required this.child,
      required this.radius,
      this.padding,
      this.margin,
      this.color = kWhiteColor,
      this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
          color: color,
          gradient: gradient,
          boxShadow: const [
            BoxShadow(
              color: kDarkGreyColor,
              spreadRadius: 0.2,
              blurRadius: 1,
              offset: Offset(0, 0.1),
            )
          ],
          borderRadius: BorderRadius.circular(radius)),
      child: child,
    );
  }
}
