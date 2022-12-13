import 'dart:convert';

import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/forgot_password_model.dart';
import 'package:dpr_patient/src/business_logics/models/forgot_password_otp_model.dart';
import 'package:dpr_patient/src/business_logics/models/login_model.dart';
import 'package:dpr_patient/src/business_logics/models/reset_password_model.dart';
import 'package:dpr_patient/src/business_logics/models/signup_model.dart';
import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/models/verify_otp_model.dart';
import 'package:dpr_patient/src/business_logics/utils/constants.dart';
import 'package:dpr_patient/src/services/shared_preference_services/shared_prefs_services.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AuthAPIServices {
  final Logger _logger = Logger();

  Future<ResponseObject> signUp(
      String firstName, String lastName, String phone, String password) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/auth/register');
      final request = http.MultipartRequest("POST", uri);
      // header data for api
      request.headers['Accept'] = 'application/json';
      // form data for api
      request.fields['fname'] = firstName;
      request.fields['lname'] = lastName;
      request.fields['phone'] = phone;
      request.fields['password'] = password;

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          _logger.v('registration status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: SignUpModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> signupVerifyOtp(String phone, String otp) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/auth/verify');
      final request = http.MultipartRequest("POST", uri);
      // header data for api
      request.headers['Accept'] = 'application/json';
      // form data for api
      request.fields['phone'] = phone;
      request.fields['otp'] = otp;

      _logger.d(request.fields['otp']);

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          var verifyOTPModel = VerifyOTPModel.fromJson(decodedJson);
          await SharedPrefsServices.setStringData("accessToken", verifyOTPModel.data?.accessToken ?? "");
          UserData.accessToken = verifyOTPModel.data?.accessToken;
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL, object: verifyOTPModel);
        } else {
          _logger.v('error code: ${_response.statusCode}');
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        _logger.v('failed');
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.v('catch');
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> login(String phone, String password) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/auth/authorize');
      _logger.v(uri);
      final request = http.MultipartRequest("POST", uri);
      // header data for api
      request.headers['Accept'] = 'application/json';
      // form data for api
      request.fields['phone'] = phone;
      request.fields['password'] = password;

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v('decoded: $decodedJson');
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          var loginModel = LoginModel.fromJson(decodedJson);
          await SharedPrefsServices.setStringData(
              "accessToken", loginModel.data?.accessToken ?? "");
          await SharedPrefsServices.setStringData("accessToken", loginModel.data?.accessToken ?? "");
          UserData.accessToken = loginModel.data?.accessToken;
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL, object: loginModel);
        } else {
          _logger.v('error code: ${_response.statusCode}');
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        _logger.v('failed');
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.v(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> requestCode(String phone) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/auth/password/reset/request');
      final request = http.MultipartRequest("POST", uri);
      // header data for api
      request.headers['Accept'] = 'application/json';
      // form data for api
      request.fields['phone'] = phone;
      _logger.v('phone: ${request.fields['phone']}');

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          _logger.v('request status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: ForgotPasswordModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> verifyOTP(String phone, String otp) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/auth/password/reset/verify');
      final request = http.Request("POST", uri);

      // header data for api
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';

      // form data for api
      request.body = json.encode({
        "phone": phone,
        "otp": otp
      });

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          var forgotPasswordOTPModel = ForgotPasswordOTPModel.fromJson(decodedJson);
          await SharedPrefsServices.setStringData(
              "accessToken", forgotPasswordOTPModel.data?.accessToken ?? ""
          );
          _logger.v('token: ${UserData.accessToken}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL, object: forgotPasswordOTPModel);
        } else {
          _logger.v('error code: ${_response.statusCode}');
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        _logger.v('failed');
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.v(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> resetPassword(String password) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/auth/password/reset/update');
      final request = http.Request("POST", uri);

      // header data for api
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';

      String accessToken = SharedPrefsServices.getStringData("accessToken") ?? "";
      _logger.d('token: $accessToken');
      request.headers['Authorization'] = "Bearer $accessToken";
      // form data for api
      request.body = json.encode({
        "password": password,
      });

      final _response = await request.send();
      final responseData = await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          var resetPasswordModel = ResetPasswordModel.fromJson(decodedJson);
          await SharedPrefsServices.setStringData("accessToken", resetPasswordModel.data?.accessToken ?? "");
          UserData.accessToken = resetPasswordModel.data?.accessToken;
          _logger.v('token: ${resetPasswordModel.data?.accessToken}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL, object: resetPasswordModel);
        } else {
          _logger.v('error code: ${_response.statusCode}');
          return ResponseObject(
              id: ResponseCode.FAILED, object: ErrorResponse.fromJson(decodedJson)
          );
        }
      } else {
        _logger.v('failed');
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson)
        );
      }
    } catch (e) {
      _logger.v(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }
}
