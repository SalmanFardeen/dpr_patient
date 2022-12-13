import 'package:flutter/material.dart';

abstract class BorderedPlatformButton {
  factory BorderedPlatformButton(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
        return BorderedIOSRaisedButton();
      default:
        return BorderedAndroidRaisedButton();
    }
  }

  Widget build(
      {required BuildContext context,
      required String text,
      required Color backgroundColor,
      required Color textColor,
      required double borderRadius,
      required Color borderColor,
      required VoidCallback onPressed});
}

class BorderedAndroidRaisedButton implements BorderedPlatformButton {
  @override
  Widget build(
      {required BuildContext context,
      required String text,
      required Color backgroundColor,
      required Color textColor,
      required double borderRadius,
      required Color borderColor,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: textColor,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 8),
          side: BorderSide(color: borderColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius), // <-- Radius
          ),
        ),
      ),
    );
  }
}

class BorderedIOSRaisedButton implements BorderedPlatformButton {
  @override
  Widget build(
      {required BuildContext context,
      required String text,
      required Color backgroundColor,
      required Color textColor,
      required double borderRadius,
      required Color borderColor,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: textColor,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 8),
          side: BorderSide(color: borderColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius), // <-- Radius
          ),
        ),
      ),
    );
  }
}
