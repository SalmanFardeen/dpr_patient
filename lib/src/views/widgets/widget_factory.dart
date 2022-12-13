import 'package:dpr_patient/src/views/widgets/dropdown_factory.dart';
import 'package:dpr_patient/src/views/widgets/icon_textfield_factory_2.dart';
import 'package:dpr_patient/src/views/widgets/passwordfield_factory.dart';
import 'package:dpr_patient/src/views/widgets/passwordfield_prefix_icon_factory.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/rich_textfield_factory.dart';
import 'package:dpr_patient/src/views/widgets/textfield_factory.dart';
import 'package:flutter/material.dart';

import 'bordered_button_factory.dart';
import 'button_factory.dart';
import 'icon_textfield_factory.dart';

class WidgetFactory {
  static Widget buildButton(
      {required BuildContext context,
      required Widget child,
      required Color backgroundColor,
      required double borderRadius,
      required VoidCallback onPressed}) {
    return PlatformButton(Theme.of(context).platform).build(
        context: context,
        child: child,
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius);
  }

  static Widget buildBorderedButton(
      {required BuildContext context,
      required String text,
      required Color backgroundColor,
      required double borderRadius,
      required Color textColor,
      required Color borderColor,
      required VoidCallback onPressed}) {
    return BorderedPlatformButton(Theme.of(context).platform).build(
        context: context,
        text: text,
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        borderColor: borderColor,
        textColor: textColor);
  }

  static Widget buildTextField(
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
    return PlatformTextField(Theme.of(context).platform).build(
      context: context,
      validator: validator,
      label: label,
      hint: hint,
      controller: controller,
      onPressed: onPressed,
      borderRadius: borderRadius,
      borderColor: borderColor,
      textInputType: textInputType,
      textInputAction: textInputAction,
    );
  }

  static Widget buildPrefixIconTextField({
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
    return PlatformIconTextField2(Theme.of(context).platform).build(
        context: context,
        validator: validator,
        label: label,
        hint: hint,
        icon: icon,
        controller: controller,
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        borderColor: borderColor,
        textColor: textColor);
  }

  static Widget buildIconTextField(
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
    return PlatformIconTextField(Theme.of(context).platform).build(
        context: context,
        label: label,
        hint: hint,
        icon: icon,
        controller: controller,
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        borderColor: borderColor,
        textColor: textColor);
  }

  static Widget buildDropDown(
      {required BuildContext context,
      required List<DropdownMenuItem<Object>>? items,
      required String hint,
      required Object? value,
      required Function() onTap,
      required Function(Object?)? onChanged}) {
    return PlatformDropDown(Theme.of(context).platform).build(
      hint: hint,
      items: items,
      value: value,
      onTap: onTap,
      onChanged: onChanged,
      context: context,
    );
  }

  static Widget buildPasswordField({
    required BuildContext context,
    required TextInputAction textInputAction,
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
    required String? Function(String?)? validator,
  }) {
    return PlatformPasswordField(Theme.of(context).platform).build(
        context: context,
        textInputAction: textInputAction,
        validator: validator,
        label: label,
        hint: hint,
        controller: controller,
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        borderColor: borderColor,
        textColor: textColor,
        obscurePassword: obscurePassword,
        suffixIcon: suffixIcon);
  }

  static Widget buildPrefixPasswordField({
    required BuildContext context,
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
    return PlatformPasswordFieldWithPrefixIcon(Theme.of(context).platform)
        .build(
            context: context,
            onChanged: onChanged,
            validator: validator,
            label: label,
            hint: hint,
            controller: controller,
            onPressed: onPressed,
            backgroundColor: backgroundColor,
            borderRadius: borderRadius,
            borderColor: borderColor,
            textColor: textColor,
            obscurePassword: obscurePassword,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon);
  }

  static Widget buildRichText({
    required BuildContext context,
      required String text1,
      required String text2,
      required Color text1Color,
      required Color text2Color,
      required VoidCallback onTap
  }) {
    return PlatformRichTextField(Theme.of(context).platform)
        .build(
            context: context,
            text1: text1,
            text2: text2,
            text1Color: text1Color,
            text2Color: text2Color,
            onTap: onTap
        );
  }

  static Widget buildProfileAvatar({
    required BuildContext context,
    required String userName,
    required double radius,
    String? url,
    ImageType? imageType
  }) {
    return ProfileAvatarWidget(
      userName: userName,
      radius: radius,
      imageType: imageType,
      url: url,
    ).build(context);
  }
}
