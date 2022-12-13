import 'dart:io';

import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/appointment_confirmation_model.dart';
import 'package:dpr_patient/src/business_logics/models/appointment_confirmation_with_uploaded_files_model.dart';
import 'package:dpr_patient/src/business_logics/models/doctor_appointment_input_model.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/issue_response_model.dart';
import 'package:dpr_patient/src/business_logics/models/patient_info_model.dart';
import 'package:dpr_patient/src/services/repository.dart';
import 'package:flutter/material.dart';

class PatientInfoProvider extends ChangeNotifier {

  bool _inProgress = true, _submissionInProgress = false, _isError = false;
  late ErrorResponse _errorResponse;
  PatientInfoModel? _patientInfoModel;
  IssueResponseModel? _issueResponseModel;
  AppointmentConfirmationModel? _appointmentConfirmationModel;
  AppointmentConfirmationWithUploadedFilesModel? _appointmentConfirmationWithUploadedFilesModel;
  static DoctorAppointmentInputModel doctorAppointmentInputModel = DoctorAppointmentInputModel();

  void clear(){
    _patientInfoModel = null;
  }
  // getter of in progress
  bool get inProgress => _inProgress;

  // getter of submission in progress
  bool get submissionInProgress => _submissionInProgress;

  // getter of boolean if any error occurs
  bool get isError => _isError;

  // get error message
  ErrorResponse get errorResponse => _errorResponse;

  //get patient list
  PatientInfoModel? get patientInfoModel => _patientInfoModel;

  IssueResponseModel? get issueResponseModel => _issueResponseModel;
  //get appointment confirmation data
  AppointmentConfirmationModel? get appointmentConfirmationModel => _appointmentConfirmationModel;
  AppointmentConfirmationWithUploadedFilesModel? get appointmentConfirmationWithUploadedFilesModel => _appointmentConfirmationWithUploadedFilesModel;

  Future<bool> getPatientList() async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.getPatientList();
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _patientInfoModel = _response.object as PatientInfoModel;
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

  Future<bool> getIssueList() async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.getIssueList();
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _issueResponseModel = _response.object as IssueResponseModel;
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

  Future<bool> setAppointment({
    required String date,
    required int patientFkNo,
    required int doctorFkNo,
    required String phoneMobile,
    required bool reportShow,
    int? chamberFkNo,
    int? slot,
    int? issue,
    String? chiefComplain,
    required bool isTelemed
  }) async {
    _inProgress = true;
    _submissionInProgress = true;
    notifyListeners();
    final _response = await repository.setAppointment(
        date: date,
        patientFkNo: patientFkNo,
        doctorFkNo: doctorFkNo,
        phoneMobile: phoneMobile,
        reportShow: reportShow,
        chamberFkNo: chamberFkNo,
        slot: slot,
        issue: issue,
        chiefComplain: chiefComplain,
      isTelemed: isTelemed
    );
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _submissionInProgress = false;
      _appointmentConfirmationModel = _response.object as AppointmentConfirmationModel;
      notifyListeners();
      return true;
    } else {
      _inProgress = false;
      _submissionInProgress = false;
      _isError = true;
      _errorResponse = _response.object as ErrorResponse;
      notifyListeners();
      return false;
    }
  }

  Future<bool> setAppointmentWithUpload(
      {required String date,
        required int patientFkNo,
        required int doctorFkNo,
        required String phoneMobile,
        required bool reportShow,
        int? chamberFkNo,
        int? slot,
        int? issue,
        String? chiefComplain,
        required bool isTelemed,
        required List<File>? images,
        required List<int>? docList}) async {
    _inProgress = true;
    _submissionInProgress = true;
    notifyListeners();
    final _response = await repository.setAppointmentWithUpload(
        date: date,
        patientFkNo: patientFkNo,
        doctorFkNo: doctorFkNo,
        phoneMobile: phoneMobile,
        reportShow: reportShow,
        chamberFkNo: chamberFkNo,
        slot: slot,
        issue: issue,
        chiefComplain: chiefComplain,
        isTelemed: isTelemed,
        images: images,
        docList: docList
    );
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _submissionInProgress = false;
      _appointmentConfirmationWithUploadedFilesModel = _response.object as AppointmentConfirmationWithUploadedFilesModel;
      notifyListeners();
      return true;
    } else {
      _inProgress = false;
      _submissionInProgress = false;
      _isError = true;
      _errorResponse = _response.object as ErrorResponse;
      notifyListeners();
      return false;
    }
  }

  Future<bool> getAppointmentDetails(int id) async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.getRecentAppointmentDetails(id);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _appointmentConfirmationModel = _response.object as AppointmentConfirmationModel;
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