import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/medication_plan_response_model.dart';
import 'package:dpr_patient/src/business_logics/models/medication_type_response_model.dart';
import 'package:dpr_patient/src/services/repository.dart';
import 'package:flutter/material.dart';

class MedicationProvider extends ChangeNotifier {

  bool _loadInProgress = true, _typeLoadInProgress = true, _updateInProgress = false, _isError = false;
  late ErrorResponse _errorResponse;

  MedicationTypeResponseModel? _medicationTypeResponseModel;
  MedicationPlanResponseModel? _medicationPlanResponseModel;

  // getter of in progress
  bool get loadInProgress => _loadInProgress;

  bool get typeLoadInProgress => _typeLoadInProgress;

  // getter of update in progress
  bool get updateInProgress => _updateInProgress;

  // getter of boolean if any error occurs
  bool get isError => _isError;

  // get error message
  ErrorResponse get errorResponse => _errorResponse;

  MedicationTypeResponseModel? get medicationTypeResponseModel => _medicationTypeResponseModel;
  MedicationPlanResponseModel? get medicationPlanResponseModel => _medicationPlanResponseModel;

  Future<bool> getMedicationTypes() async {
    final _response = await repository.getMedicationTypes();
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _typeLoadInProgress = false;
      _medicationTypeResponseModel = _response.object as MedicationTypeResponseModel;
      notifyListeners();
      return true;
    } else {
      _typeLoadInProgress = false;
      _isError = true;
      _errorResponse = _response.object as ErrorResponse;
      notifyListeners();
      return false;
    }
  }

  List<bool> isTaken = [];
  Future<bool> getMedicationPlans() async {
    final _response = await repository.getMedicationPlans();
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _loadInProgress = false;
      _medicationPlanResponseModel = _response.object as MedicationPlanResponseModel;
      isTaken.clear();
      _medicationPlanResponseModel?.data?.forEach((element) {
        isTaken.add(false);
      });
      notifyListeners();
      return true;
    } else {
      _loadInProgress = false;
      _isError = true;
      _errorResponse = _response.object as ErrorResponse;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addMedicationPlan(String medicineType, String medicineName, String note, var days, var times) async {
    _updateInProgress = true;
    notifyListeners();
    final _response = await repository.addMedicationPlan(medicineType, medicineName, note, days, times);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _updateInProgress = false;
      // _medicationPlanResponseModel = _response.object as MedicationPlanResponseModel;
      notifyListeners();
      return true;
    } else {
      _updateInProgress = false;
      _isError = true;
      _errorResponse = _response.object as ErrorResponse;
      notifyListeners();
      return false;
    }
  }
}