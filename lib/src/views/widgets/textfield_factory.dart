import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:flutter/material.dart';

abstract class PlatformTextField {
  factory PlatformTextField(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
        return TextFieldAndroid();
      default:
        return TextFieldIOS();
    }
  }

  Widget build(
      {required BuildContext context,
      required validator,
      required String label,
      required String hint,
      required double borderRadius,
      required Color borderColor,
      required TextEditingController controller,
      required TextInputType textInputType,
      required TextInputAction textInputAction,
      required VoidCallback onPressed});
}

class TextFieldIOS implements PlatformTextField {
  @override
  Widget build(
      {required BuildContext context,
      validator,
      required String label,
      required String hint,
      required double borderRadius,
      required Color borderColor,
      required TextEditingController controller,
      required TextInputType textInputType,
      required TextInputAction textInputAction,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        validator: validator,
        controller: controller,
        onTap: onPressed,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        cursorColor: kBlackColor,
        decoration: InputDecoration(
          hintText: hint,
          label: label == '' ? null : Text(label),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: kBlackColor, width: 0.5),
          )
        ),
      ),
    );
  }
}

class TextFieldAndroid implements PlatformTextField {
  @override
  Widget build(
      {required BuildContext context,
      validator,
      required String label,
      required String hint,
      required double borderRadius,
      required Color borderColor,
      required TextEditingController controller,
      required TextInputType textInputType,
      required TextInputAction textInputAction,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        validator: validator,
        onTap: onPressed,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        cursorColor: kBlackColor,
        decoration: InputDecoration(
            hintText: hint,
            label: label == '' ? null : Text(label),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: kBlackColor, width: 0.5),
            )
        ),
      ),
    );
  }
}
