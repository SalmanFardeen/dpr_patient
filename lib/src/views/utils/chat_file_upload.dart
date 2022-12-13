import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:dpr_patient/src/services/file_manager_services/image_compression_service.dart';

class ChatFileUpload {
  static Future<List<File>> compressImage(List<File> images) async {
    int limit = 1;
    List<File> compressedImages = [];
    for (int i = 0; i < images.length; i++) {
      final fileSize = ImageCompressionService.instance.fileSize(images[i]);
      if (fileSize > limit) {
        final dir = await path_provider.getTemporaryDirectory();
        final ratioOfQuality = 100 - ((fileSize - limit) / (fileSize / 100));
        final targetPath = dir.absolute.path + "/temp.jpg";
        File file = await ImageCompressionService.instance
            .testCompressAndGetFile(
                images[i], targetPath, ratioOfQuality.floor());
        compressedImages.add(file);
      } else {
        compressedImages.add(images[i]);
      }
    }
    return compressedImages;
  }
}
