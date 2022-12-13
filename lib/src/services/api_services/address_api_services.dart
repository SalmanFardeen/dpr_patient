import 'dart:convert';

import 'package:dpr_patient/src/business_logics/models/add_address_model.dart';
import 'package:dpr_patient/src/business_logics/models/address_list_model.dart';
import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/update_address_model.dart';
import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/utils/constants.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class AddressAPIServices {

  final Logger _logger = Logger();

  Future<ResponseObject> getAddresses() async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/address');
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
              object: AddressListModel.fromJson(decodedJson));
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

  Future<ResponseObject> addAddress(String name, String area, String address) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/address');
      final request = http.Request("POST", uri);
      // header data for api
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      String? accessToken = UserData.accessToken;
      _logger.d("accessToken: $accessToken");
      request.headers['Authorization'] = "Bearer $accessToken";

      request.body = jsonEncode({
        'name': name,
        'area': area,
        'address': address
      });

      _logger.d('body: ${request.body}');

      final _response = await request.send();
      final responseData = await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          // _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: AddAddressModel.fromJson(decodedJson));
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

  Future<ResponseObject> updateAddress(int id, String name, String area, String address) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/address/$id');
      final request = http.Request("PUT", uri);
      // header data for api

      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      String? accessToken = UserData.accessToken;
      _logger.d("accessToken: $accessToken");
      request.headers['Authorization'] = "Bearer $accessToken";

      request.body = jsonEncode({
        'name': name,
        'area': area,
        'address': address
      });

      final _response = await request.send();
      final responseData = await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          // _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: UpdateAddressModel.fromJson(decodedJson));
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