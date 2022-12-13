import 'dart:convert';
import 'dart:io';

import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/document_upload_model.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/upload_list_model.dart';
import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/utils/constants.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/services/file_manager_services/image_compression_service.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class DocumentAPIServices {

  final Logger _logger = Logger();

  Future<ResponseObject> getDocumentList() async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/upload');
      final request = http.Request("GET", uri);
      // header data for api
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      String? accessToken = UserData.accessToken;
      _logger.d("accessToken: $accessToken");
      request.headers['Authorization'] = "Bearer $accessToken";

      final _response = await request.send();
      final responseData = await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          // _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: UploadListModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED, object: ErrorResponse.fromJson(decodedJson)
          );
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson)
        );
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> upload(String description, String date, File? file) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/upload');
      final request = http.MultipartRequest("POST", uri);
      // header data for api
      request.headers['Accept'] = 'application/json';
      // request.headers['Content-Type'] = 'application/json';

      String? accessToken = UserData.accessToken;
      _logger.d("accessToken: $accessToken");
      request.headers['Authorization'] = "Bearer $accessToken";

      if(file != null) {
        request.files.add(await _getMultipartFile('document', file));
        _logger.d(file.path);
      }
      request.fields['description'] = description;
      // request.fields['dob'] = date;

      _logger.d('body: ${request.fields}');
      _logger.d('files: ${request.files}');

      final _response = await request.send();
      final responseData = await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          // _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: DocumentUploadModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED, object: ErrorResponse.fromJson(decodedJson)
          );
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson)
        );
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<http.MultipartFile> _getMultipartFile(
      String attribute, File image) async {
    File file = File("");
    int limit = 1; //mb
    if (ImageCompressionService.instance.fileSize(image) > limit) {
      final dir = await path_provider.getTemporaryDirectory();
      final fileSize =
      ImageCompressionService.instance.fileSize(image); // 500mb
      final ratioOfQuality = 100 - ((fileSize - limit) / (fileSize / 100));
      final targetPath = dir.absolute.path + "/temp.jpg";
      file = await ImageCompressionService.instance
          .testCompressAndGetFile(image, targetPath, ratioOfQuality.floor());
      LogDebugger.instance.v(
          'original >= : ${ImageCompressionService.instance.fileSize(image)}; compressed: '
              '${ImageCompressionService.instance.fileSize(file)}');
    } else {
      file = image;
      LogDebugger.instance
          .v('original: ${ImageCompressionService.instance.fileSize(image)}');
    }
    var stream = http.ByteStream(file.openRead());
    stream.cast();
    var length = await file.length();

    final multipartFile = http.MultipartFile(
      attribute,
      stream,
      length,
      filename: basename(file.path),
    );

    return multipartFile;
  }
}