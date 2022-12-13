import 'package:flutter/material.dart';

abstract class PlatformButton {
  factory PlatformButton(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
        return AndroidRaisedButton();
      case TargetPlatform.iOS:
        return IOSRaisedButton();
      default:
        return WebRaisedButton();
    }
  }

  Widget build(
      {required BuildContext context,
      required Widget child,
      required Color backgroundColor,
      required double borderRadius,
      required VoidCallback onPressed});
}

class AndroidRaisedButton implements PlatformButton {
  @override
  Widget build(
      {required BuildContext context,
      required Widget child,
      required Color backgroundColor,
      required double borderRadius,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

class IOSRaisedButton implements PlatformButton {
  @override
  Widget build(
      {required BuildContext context,
        required Widget child,
        required Color backgroundColor,
        required double borderRadius,
        required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

class WebRaisedButton implements PlatformButton {
  @override
  Widget build(
      {required BuildContext context,
        required Widget child,
        required Color backgroundColor,
        required double borderRadius,
        required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
