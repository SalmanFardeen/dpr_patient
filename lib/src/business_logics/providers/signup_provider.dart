import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/services/repository.dart';
import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/signup_model.dart';
import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  bool _isAccepted = false, _inProgress = false, _isError = false;
  late ErrorResponse _errorResponse;
  late SignUpModel _signUpModel;

  // getter of in progress
  bool get inProgress => _inProgress;

  // getter of is accepted
  bool get isAccepted => _isAccepted;

  // setter of is accepted
  set isAccepted(value) => _isAccepted = value;

  // getter of boolean if any error occurs
  bool get isError => _isError;

  // get error message
  ErrorResponse get errorResponse => _errorResponse;

  //get patient signup model
  SignUpModel get patientSignUpModel => _signUpModel;

  //register patient with name,password and phone no.
  Future<bool> signUp(String firstName, String lastName, String phone, String password) async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.signUp(firstName, lastName, phone, password);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _signUpModel = _response.object as SignUpModel;
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