import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

final picker = ImagePicker();

Future getImage(BuildContext context, XFile imageFile) async {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
          title: const Text('Upload Image'),
          content: Container(
            height: 130,
            margin: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.camera),
                    title: const Text('Camera'),
                    onTap: () async {
                      Navigator.pop(context);
                      final pickedFile =
                      await picker.pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        imageFile = pickedFile;
                      }
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.images),
                    title: const Text('Gallery'),
                    onTap: () async {
                      Navigator.pop(context);
                      final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        imageFile = pickedFile;
                      }
                    },
                  ),
                ),
              ],
            ),
          )));
}