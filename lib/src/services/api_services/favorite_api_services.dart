import 'dart:convert';

import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/fav_doc_model.dart';
import 'package:dpr_patient/src/business_logics/models/fav_med_model.dart';
import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class FavouriteAPIServices {

  final Logger _logger = Logger();

  Future<ResponseObject> getFavDocList() async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/patient-fav-doctor');
      final request = http.MultipartRequest("GET", uri);
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
              object: FavDocModel.fromJson(decodedJson));
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

  Future<ResponseObject> getFavMedList() async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/patient-fav-med-list');
      final request = http.MultipartRequest("GET", uri);
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
              object: FavMedModel.fromJson(decodedJson));
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
}