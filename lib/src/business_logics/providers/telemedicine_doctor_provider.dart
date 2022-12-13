import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/doctor_response_model.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/services/repository.dart';
import 'package:flutter/material.dart';

class TelemedicineDoctorProvider extends ChangeNotifier {

  bool _inProgress = false, _isError = false;
  late ErrorResponse _errorResponse;
  DoctorResponseModel? _telemedicineDoctorModel;

  // getter of in progress
  bool get inProgress => _inProgress;

  // getter of boolean if any error occurs
  bool get isError => _isError;

  // get error message
  ErrorResponse get errorResponse => _errorResponse;

  //get telemedicine doctor model
  DoctorResponseModel? get telemedicineDoctorModel => _telemedicineDoctorModel;

  Future<bool> getOnlineDoctor() async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.getOnlineDoctor();
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _telemedicineDoctorModel = _response.object as DoctorResponseModel;
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