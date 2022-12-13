import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:flutter/material.dart';

abstract class PlatformPasswordFieldWithPrefixIcon {
  factory PlatformPasswordFieldWithPrefixIcon(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
        return BorderedIOSPasswordField();
      default:
        return BorderedAndroidPasswordField();
    }
  }

  Widget build(
      {required BuildContext context,
        onChanged,
        required String label,
        required String hint,
        required Color backgroundColor,
        required Color textColor,
        required double borderRadius,
        required Color borderColor,
        required TextEditingController controller,
        required VoidCallback onPressed,
        required bool obscurePassword,
        required IconButton suffixIcon,
        required Widget prefixIcon,
        required String? Function(String?)? validator,
      });
}

class BorderedAndroidPasswordField implements PlatformPasswordFieldWithPrefixIcon {
  @override
  Widget build(
      {required BuildContext context,
        onChanged,
        required String label,
        required String hint,
        required Color backgroundColor,
        required Color textColor,
        required double borderRadius,
        required Color borderColor,
        required TextEditingController controller,
        required VoidCallback onPressed,
        required bool obscurePassword,
        required IconButton suffixIcon,
        required Widget prefixIcon,
        required String? Function(String?)? validator,
      }) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        onChanged: onChanged,
        cursorColor: kBlackColor,
        controller: controller,
        validator: validator,
        obscureText: obscurePassword,
        decoration: InputDecoration(
            hintText: hint,
            label: label == '' ? null : Text(label),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 28, vertical: 5),
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor, width: 0.0),
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon
        ),
      ),
    );
  }
}

class BorderedIOSPasswordField implements PlatformPasswordFieldWithPrefixIcon {
  @override
  Widget build(
      {required BuildContext context,
        onChanged,
        required String label,
        required String hint,
        required Color backgroundColor,
        required Color textColor,
        required double borderRadius,
        required Color borderColor,
        required TextEditingController controller,
        required VoidCallback onPressed,
        required bool obscurePassword,
        required IconButton suffixIcon,
        required Widget prefixIcon,
        required String? Function(String?)? validator,
      }) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        onChanged: onChanged,
        cursorColor: kBlackColor,
        controller: controller,
        validator: validator,
        obscureText: obscurePassword,
        decoration: InputDecoration(
            hintText: hint,
            label: label == '' ? null : Text(label),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 28, vertical: 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor, width: 0.0),
            ),
            suffixIcon: suffixIcon,
          prefixIcon: prefixIcon
        ),
      ),
    );
  }
}
