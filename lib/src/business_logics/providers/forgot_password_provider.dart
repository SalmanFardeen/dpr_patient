import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/forgot_password_model.dart';
import 'package:dpr_patient/src/services/repository.dart';
import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:flutter/material.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  bool _inProgress = false, _isError = false;
  late ErrorResponse _errorResponse;
  late ForgotPasswordModel _forgotPasswordModel;

  // getter of in progress
  bool get inProgress => _inProgress;

  // getter of boolean if any error occurs
  bool get isError => _isError;

  // get error message
  ErrorResponse get errorResponse => _errorResponse;

  //get patient signup model
  ForgotPasswordModel get forgotPasswordModel => _forgotPasswordModel;

  //register patient with name,password and phone no.
  Future<bool> requestCode(String phone) async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.requestCode(phone);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _forgotPasswordModel = _response.object as ForgotPasswordModel;
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