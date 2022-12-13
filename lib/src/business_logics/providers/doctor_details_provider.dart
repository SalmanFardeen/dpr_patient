import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/chamber_response_model.dart';
import 'package:dpr_patient/src/business_logics/models/doctor_details_model.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/slot_response_model.dart';
import 'package:dpr_patient/src/business_logics/models/slot_summery_response_model.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/services/repository.dart';
import 'package:flutter/material.dart';

class DoctorDetailsProvider extends ChangeNotifier {

  bool _inProgress = false, _isFavSetting = false, _slotInProgress = false, _isError = false;
  late ErrorResponse _errorResponse;
  DoctorDetailsModel? _doctorDetailsModel;
  ChamberResponseModel? _chamberResponseModel;
  SlotResponseModel? _slotResponseModel;
  SlotSummeryResponseModel? _slotSummeryResponseModel;

  // getter of in progress
  bool get inProgress => _inProgress;
  bool get isFavSetting => _isFavSetting;
  bool get slotInProgress => _slotInProgress;

  // getter of boolean if any error occurs
  bool get isError => _isError;

  // get error message
  ErrorResponse get errorResponse => _errorResponse;

  //get nearby doctor model
  DoctorDetailsModel? get doctorDetailsModel => _doctorDetailsModel;
  ChamberResponseModel? get chamberResponseModel => _chamberResponseModel;
  SlotResponseModel? get slotResponseModel => _slotResponseModel;
  SlotSummeryResponseModel? get slotSummeryResponseModel => _slotSummeryResponseModel;

  void clear() {
    _doctorDetailsModel = null;
    _chamberResponseModel = null;
    _slotResponseModel = null;
  }

  Future<bool> getDoctorDetails({required int id, required String type}) async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.getDoctorDetails(id: id, type: type);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _doctorDetailsModel = _response.object as DoctorDetailsModel;
      LogDebugger.instance.i(_doctorDetailsModel!.toJson());
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

  Future<bool> getDoctorChambers(int id) async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.getDoctorChambers(id);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _chamberResponseModel = _response.object as ChamberResponseModel;
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

  Future<bool> getSlotList({required int doctor, int? chamber, required String date, required String type}) async {
    _slotInProgress = true;
    _slotResponseModel = null;
    notifyListeners();
    final _response = await repository.getSlotList(doctor: doctor, chamber: chamber, date: date, type: type);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _slotInProgress = false;
      _slotResponseModel = _response.object as SlotResponseModel;
      notifyListeners();
      return true;
    } else {
      _slotInProgress = false;
      _isError = true;
      _errorResponse = _response.object as ErrorResponse;
      notifyListeners();
      return false;
    }
  }

  Future<bool> getSlotSummery({required int doctor, required String type}) async {
    LogDebugger.instance.d("Slot summery");
    _slotInProgress = true;
    _slotResponseModel = null;
    notifyListeners();
    final _response = await repository.getSlotSummery(doctor: doctor, type: type);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _slotInProgress = false;
      _slotSummeryResponseModel = _response.object as SlotSummeryResponseModel;
      notifyListeners();
      return true;
    } else {
      _slotInProgress = false;
      _isError = true;
      _errorResponse = _response.object as ErrorResponse;
      notifyListeners();
      return false;
    }
  }

  Future<bool> setFavDoc({required int doctor, int isFav = 0}) async {
    _isFavSetting = true;
    notifyListeners();
    final _response = await repository.setFavDoc(doctor: doctor, isFav: isFav);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _isFavSetting = false;
      return true;
    } else {
      _isFavSetting = false;
      _isError = true;
      _errorResponse = _response.object as ErrorResponse;
      return false;
    }
  }
}