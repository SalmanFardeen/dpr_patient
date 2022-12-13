import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/fav_doc_model.dart';
import 'package:dpr_patient/src/business_logics/models/fav_med_model.dart';
import 'package:dpr_patient/src/services/repository.dart';
import 'package:flutter/material.dart';

class FavouriteProvider extends ChangeNotifier {

  bool _inProgress = true, _isFavSetting = false, _isError = false;
  late ErrorResponse _errorResponse;
  FavDocModel? _favDocModel;
  FavMedModel? _favMedModel;

  // getter of in progress
  bool get inProgress => _inProgress;

  bool get isFavSetting => _isFavSetting;

  // setter of in progress
  set setProgress(value) => _inProgress = value;

  // getter of boolean if any error occurs
  bool get isError => _isError;

  // get error message
  ErrorResponse get errorResponse => _errorResponse;

  FavDocModel? get favDocModel => _favDocModel;

  FavMedModel? get favMedModel => _favMedModel;

  Future<bool> getFavDocList() async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.getFavDocList();
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _favDocModel = _response.object as FavDocModel;
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

  Future<bool> getFavMedList() async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.getFavMedList();
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _favMedModel = _response.object as FavMedModel;
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