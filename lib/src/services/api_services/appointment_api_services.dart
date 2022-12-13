import 'dart:convert';

import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/appointment_confirmation_model.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/utils/constants.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:http/http.dart' as http;


class AppointmenyApiServices {
  Future<ResponseObject> getRecentAppointmentDetails(int id) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/patient-completed-appointment/$id');
      final request = http.MultipartRequest("GET", uri);
      // header data for api
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      String? accessToken = UserData.accessToken;
      LogDebugger.instance.d("accessToken: $accessToken");
      request.headers['Authorization'] = "Bearer $accessToken";

      final _response = await request.send();
      final responseData = await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      LogDebugger.instance.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          // _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: AppointmentConfirmationModel.fromJson(decodedJson));
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
      LogDebugger.instance.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

}