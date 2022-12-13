import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/verify_otp_model.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:flutter/material.dart';
import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/services/repository.dart';

class SignupOtpProvider extends ChangeNotifier {
  bool _inProgress = false, _isError = false;
  late ErrorResponse _errorResponse;
  late VerifyOTPModel _verifyOTPModel;

  // getter of in progress
  bool get inProgress => _inProgress;

  // setter of in progress
  set inProgress(value) => _inProgress = value;

  // getter of boolean if any error occurs
  bool get isError => _isError;

  // get verify otp model
  VerifyOTPModel get verifyOTPModel => _verifyOTPModel;

  // get error message
  ErrorResponse get errorResponse => _errorResponse;

  // login patient with phone and otp
  Future<bool> signupVerifyOTP(String phone, String otp) async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.signupVerifyOTP(phone, otp);
    LogDebugger.instance.d(_response.object);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _verifyOTPModel = _response.object as VerifyOTPModel;
      notifyListeners();
      return true;
    } else {
      _inProgress = false;
      _isError = true;
      _errorResponse = _response.object as ErrorResponse;
      notifyListeners();
      return false;
    }
  }
}
