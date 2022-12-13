import 'dart:io';

import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:flutter/material.dart';

enum ImageType { Network, Asset, File }

class ProfileAvatarWidget extends StatelessWidget {
  final String? url;
  final String userName;
  final double radius;
  final ImageType? imageType;

  const ProfileAvatarWidget({Key? key, this.url, required this.userName, required this.radius, this.imageType});

  @override
  Widget build(BuildContext context) {
    return getProfileImageWidget(imageType);
  }

  Widget getProfileImageWidget(ImageType? imageType) {
    if (imageType == ImageType.Asset && url != null && url != '') {
      return Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          image: DecorationImage(image: AssetImage(url!), fit: BoxFit.cover),
        ),
      );
    } else if (imageType == ImageType.File && url != null && url != '') {
      return Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          image: DecorationImage(image: Image.file(File(url!)).image, fit: BoxFit.cover),
        ),
      );
    }
    else if (imageType == ImageType.Network && url != null && url != '') {
      return Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          image: DecorationImage(
              image: Image.network(url!).image,
              fit: BoxFit.cover
          ),
        ),
      );
    } else {
      return Container(
        height: radius,
        width: radius,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle
        ),
        alignment: Alignment.center,
        child: Text(
          userName.characters.first,
          style: const TextStyle(
            color: kWhiteColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
