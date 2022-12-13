import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:flutter/material.dart';

abstract class PlatformIconTextField2 {
  factory PlatformIconTextField2(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
        return PrefixIconIOSTextField();
      default:
        return PrefixIconAndroidTextField();
    }
  }

  Widget build({
    required BuildContext context,
    required String label,
    required String hint,
    required Widget icon,
    required Color backgroundColor,
    required Color textColor,
    required double borderRadius,
    required Color borderColor,
    required TextEditingController controller,
    required VoidCallback onPressed,
    required String? Function(String?)? validator,
  });
}

class PrefixIconAndroidTextField implements PlatformIconTextField2 {
  @override
  Widget build({
    required BuildContext context,
    required String label,
    required String hint,
    required Widget icon,
    required Color backgroundColor,
    required Color textColor,
    required double borderRadius,
    required Color borderColor,
    required TextEditingController controller,
    required VoidCallback onPressed,
    required String? Function(String?)? validator,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        validator: validator,
        cursorColor: kBlackColor,
        decoration: InputDecoration(
            hintText: hint,
            label: label == '' ? null : Text(label),
            prefixIcon: icon,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor),
            )),
      ),
    );
  }
}

class PrefixIconIOSTextField implements PlatformIconTextField2 {
  @override
  Widget build({
    required BuildContext context,
    required String label,
    required String hint,
    required Widget icon,
    required Color backgroundColor,
    required Color textColor,
    required double borderRadius,
    required Color borderColor,
    required TextEditingController controller,
    required VoidCallback onPressed,
    required String? Function(String?)? validator,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        validator: validator,
        cursorColor: kBlackColor,
        decoration: InputDecoration(
            hintText: hint,
            label: label == '' ? null : Text(label),
            prefixIcon: icon,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor),
            )),
      ),
    );
  }
}
