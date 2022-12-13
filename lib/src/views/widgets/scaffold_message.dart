import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showScaffoldMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

void launchURLMethod(String _url) async {
  Uri url = Uri.parse(_url);
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

