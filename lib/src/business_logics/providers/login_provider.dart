import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/login_model.dart';
import 'package:dpr_patient/src/services/repository.dart';
import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool _inProgress = false, _isError = false;
  late ErrorResponse _errorResponse;
  late LoginModel _loginModel;

  // getter of in progress
  bool get inProgress => _inProgress;

  // getter of boolean if any error occurs
  bool get isError => _isError;

  // get error message
  ErrorResponse get errorResponse => _errorResponse;

  //get login model
  LoginModel get loginModel => _loginModel;

  //login with phone and password
  Future<bool> login(String phone, String password) async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.login(phone, password);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _loginModel = _response.object as LoginModel;
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