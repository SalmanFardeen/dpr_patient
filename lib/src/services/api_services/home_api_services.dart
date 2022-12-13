import 'dart:convert';

import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/doctor_response_model.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/utils/constants.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class HomeAPIServices {

  final Logger _logger = Logger();

  Future<ResponseObject> getNearbyDoctor(double lat, double lon) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/nearby-doctors');
      final request = http.MultipartRequest("GET", uri);
      // header data for api
      _logger.d("accessToken: ${UserData.accessToken}");
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = "Bearer ${UserData.accessToken}";
      // form data for api
      request.fields['lat'] = lat.toString();
      request.fields['long'] = lon.toString();

      final _response = await request.send();
      final responseData = await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: DoctorResponseModel.fromJson(decodedJson));
        } else {
          _logger.d("status false");
          return ResponseObject(
              id: ResponseCode.FAILED, object: ErrorResponse.fromJson(decodedJson)
          );
        }
      } else {
        _logger.d("failed");
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

  Future<ResponseObject> getOnlineDoctor() async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/online-doctors');
      final request = http.MultipartRequest("GET", uri);
      // header data for api
      _logger.d("accessToken: ${UserData.accessToken}");
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = "Bearer ${UserData.accessToken}";

      final _response = await request.send();
      final responseData = await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: DoctorResponseModel.fromJson(decodedJson));
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
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }
}