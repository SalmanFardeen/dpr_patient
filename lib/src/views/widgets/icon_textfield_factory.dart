import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:flutter/material.dart';

abstract class PlatformIconTextField {
  factory PlatformIconTextField(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
        return SuffixIconIOSTextField();
      default:
        return SuffixIconAndroidTextField();
    }
  }

  Widget build(
      {required BuildContext context,
        required String label,
        required String hint,
        required Widget icon,
        required Color backgroundColor,
        required Color textColor,
        required double borderRadius,
        required Color borderColor,
        required TextEditingController controller,
        required VoidCallback onPressed});
}

class SuffixIconAndroidTextField implements PlatformIconTextField {
  @override
  Widget build(
      {required BuildContext context,
        required String label,
        required String hint,
        required Widget icon,
        required Color backgroundColor,
        required Color textColor,
        required double borderRadius,
        required Color borderColor,
        required TextEditingController controller,
        required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        cursorColor: kBlackColor,
        decoration: InputDecoration(
            hintText: hint,
            label: Text(label),
            suffixIcon: icon,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 28, vertical: 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor),
            )),
      ),
    );
  }
}

class SuffixIconIOSTextField implements PlatformIconTextField {
  @override
  Widget build(
      {required BuildContext context,
        required String label,
        required String hint,
        required Widget icon,
        required Color backgroundColor,
        required Color textColor,
        required double borderRadius,
        required Color borderColor,
        required TextEditingController controller,
        required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        cursorColor: kBlackColor,
        decoration: InputDecoration(
            hintText: hint,
            label: Text(label),
            suffixIcon: icon,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 28, vertical: 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor),
            )),
      ),
    );
  }
}
