import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/in_person_visit_model.dart';
import 'package:dpr_patient/src/business_logics/models/doctor_response_model.dart';
import 'package:dpr_patient/src/services/repository.dart';
import 'package:flutter/material.dart';

class InPersonVisitProvider extends ChangeNotifier {

  bool _inProgress = true, _inSearch = false, _isError = false;
  late ErrorResponse _errorResponse;
  InPersonVisitModel? _inPersonVisitModel;
  DoctorResponseModel? _inPersonVisitSearchModel;

  // getter of in progress
  bool get inProgress => _inProgress;

  // getter of in progress
  bool get inSearch => _inSearch;

  // getter of boolean if any error occurs
  bool get isError => _isError;

  // get error message
  ErrorResponse get errorResponse => _errorResponse;

  //get doctor list
  InPersonVisitModel? get inPersonVisitModel => _inPersonVisitModel;

  //get doctor search list
  DoctorResponseModel? get inPersonVisitSearchModel => _inPersonVisitSearchModel;

  //set doctor search list
  void clearData({bool? isTrue}) {
    _inPersonVisitSearchModel = null;
    _inSearch = false;
    if(isTrue ?? true) {
      notifyListeners();
    }
  }

  Future<bool> getInPersonVisitDoctorList({required String type}) async {
    _inProgress = true;
    _inSearch = false;
    _inPersonVisitModel = null;
    notifyListeners();
    final _response = await repository.getInPersonVisitDoctorList(type: type);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _inPersonVisitModel = _response.object as InPersonVisitModel;
      _inPersonVisitModel?.data?.recentAppointments?.sort((a, b) {
       int aPK = a.appointNoPk ?? 0;
       int bPK = b.appointNoPk ?? 0;
       return bPK.compareTo(aPK);
      });
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

  Future<bool> getInPersonVisitDoctorSearch(String key, {bool isTelemedicine = false}) async {
    _inProgress = true;
    _inSearch = true;
    notifyListeners();
    final _response = await repository.getInPersonVisitDoctorSearch(key, isTelemedicine: isTelemedicine);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _inPersonVisitSearchModel = _response.object as DoctorResponseModel;
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

  Future<bool> getNearbyDoctor(double lat, double lon) async {
    _inProgress = true;
    _inSearch = true;
    notifyListeners();
    final _response = await repository.getNearbyDoctor(lat, lon);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _inPersonVisitSearchModel = _response.object as DoctorResponseModel;
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

  Future<bool> getOnlineDoctor() async {
    _inProgress = true;
    _inSearch = true;
    notifyListeners();
    final _response = await repository.getOnlineDoctor();
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _inPersonVisitSearchModel = _response.object as DoctorResponseModel;
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