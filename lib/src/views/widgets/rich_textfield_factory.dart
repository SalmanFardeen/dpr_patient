import 'package:flutter/material.dart';

abstract class PlatformRichTextField {
  factory PlatformRichTextField(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
        return RichTextFieldAndroid();
      default:
        return RichTextFieldIOS();
    }
  }

  Widget build(
      {required BuildContext context,
      required String text1,
      required String text2,
      required Color text1Color,
      required Color text2Color,
      required VoidCallback onTap});
}

class RichTextFieldIOS implements PlatformRichTextField {
  @override
  Widget build(
      {required BuildContext context,
      required String text1,
      required String text2,
      required Color text1Color,
      required Color text2Color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: text1,
          style: TextStyle(color: text1Color),
          children: <TextSpan>[
            TextSpan(
                text: text2,
                style: TextStyle(
                    color: text2Color,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class RichTextFieldAndroid implements PlatformRichTextField {
  @override
  Widget build(
      {required BuildContext context,
      required String text1,
      required String text2,
      required Color text1Color,
      required Color text2Color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: text1,
          style: TextStyle(color: text1Color),
          children: <TextSpan>[
            TextSpan(
                text: text2,
                style: TextStyle(
                    color: text2Color,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}