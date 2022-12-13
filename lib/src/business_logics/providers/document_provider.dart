import 'dart:io';

import 'package:dpr_patient/src/business_logics/models/document_upload_model.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
// import 'package:dpr_patient/src/business_logics/models/profile_model.dart';
import 'package:dpr_patient/src/business_logics/models/upload_list_model.dart';
import 'package:dpr_patient/src/services/repository.dart';
import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:flutter/material.dart';

class DocumentProvider extends ChangeNotifier {
  bool _inProgress = false;
  // bool _profileLoaded = false;
  bool _isError = false;
  late ErrorResponse _errorResponse;

  // ProfileModel? _profileModel;
  UploadListModel? _uploadListModel;
  DocumentUploadModel? _documentUploadModel;

  // getter of in progress
  bool get inProgress => _inProgress;

  // bool get profileLoaded => _profileLoaded;

  // getter of boolean if any error occurs
  bool get isError => _isError;

  // get error message
  ErrorResponse get errorResponse => _errorResponse;

  // ProfileModel? get profileModel => _profileModel;

  UploadListModel? get uploadListModel => _uploadListModel;

  DocumentUploadModel? get documentUploadModel => _documentUploadModel;

  // Future<bool> getProfile() async {
  //   final _response = await repository.getProfile();
  //   if (_response.id == ResponseCode.SUCCESSFUL) {
  //     _profileLoaded = true;
  //     _profileModel = _response.object as ProfileModel;
  //     notifyListeners();
  //     return true;
  //   } else {
  //     _profileLoaded = true;
  //     _isError = true;
  //     _errorResponse = _response.object as ErrorResponse;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  Future<bool> getDocumentList() async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.getDocumentList();
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _uploadListModel = _response.object as UploadListModel;
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

  Future<bool> upload(String description, String date, File? file) async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.upload(description, date, file);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _documentUploadModel = _response.object as DocumentUploadModel;
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