import 'package:flutter/material.dart';

abstract class PlatformDropDown {
  factory PlatformDropDown(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.iOS:
        return IOSDropDown();
      default:
        return AndroidDropDown();
    }
  }

  Widget build(
      {required BuildContext context,
      required List<DropdownMenuItem<Object>>? items,
      required String hint,
      required Object? value,
      required Function() onTap,
      required Function(Object?)? onChanged});
}

class AndroidDropDown implements PlatformDropDown {
  @override
  Widget build(
      {required BuildContext context,
      required List<DropdownMenuItem<Object>>? items,
      required String hint,
      required Object? value,
      required Function() onTap,
      required Function(Object?)? onChanged}) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField(
        value: value,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(right: 5, left: 20),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        hint: Text(
          hint,
          style: const TextStyle(color: Color(0xFFCBCBCB)),
        ),
        items: items,
        onTap: onTap,
        onChanged: onChanged,
        icon: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.grey,
          size: 25.0,
        ),
      ),
    );
  }
}

class IOSDropDown implements PlatformDropDown {
  @override
  Widget build(
      {required BuildContext context,
      required List<DropdownMenuItem<Object>>? items,
      required String hint,
      required Object? value,
      required Function() onTap,
      required Function(Object?)? onChanged}) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField(
        value: value,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(right: 5, left: 20),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        hint: Text(
          hint,
          style: const TextStyle(color: Color(0xFFCBCBCB)),
        ),
        items: items,
        onTap: onTap,
        onChanged: onChanged,
        icon: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.grey,
          size: 25.0,
        ),
      ),
    );
  }
}
