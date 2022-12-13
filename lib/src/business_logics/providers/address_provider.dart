import 'package:dpr_patient/src/business_logics/models/add_address_model.dart';
import 'package:dpr_patient/src/business_logics/models/address_list_model.dart';
import 'package:dpr_patient/src/business_logics/models/address_model.dart';
import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/update_address_model.dart';
import 'package:dpr_patient/src/services/repository.dart';
import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {

  bool _loadInProgress = true, _updateInProgress = false, _isError = false;
  late ErrorResponse _errorResponse;

  AddressListModel? _addressListModel;

  // getter of in progress
  bool get loadInProgress => _loadInProgress;

  // getter of update in progress
  bool get updateInProgress => _updateInProgress;

  // getter of boolean if any error occurs
  bool get isError => _isError;

  // get error message
  ErrorResponse get errorResponse => _errorResponse;

  AddressListModel? get addressListModel => _addressListModel;

  Future<bool> getAddresses() async {
    _loadInProgress = true;
    notifyListeners();
    final _response = await repository.getAddresses();
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _loadInProgress = false;
      _addressListModel = _response.object as AddressListModel;
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

  Future<bool> addAddress(String name, String area, String address) async {
    _updateInProgress = true;
    notifyListeners();
    final _response = await repository.addAddress(name, area, address);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _updateInProgress = false;
      AddAddressModel addAddressModel = _response.object as AddAddressModel;
      _addressListModel?.data?.addresses?.add(addAddressModel.data ?? Address());
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

  Future<bool> updateAddress(int position, int id, String name, String area, String address) async {
    _updateInProgress = true;
    notifyListeners();
    final _response = await repository.updateAddress(id, name, area, address);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _updateInProgress = false;
      UpdateAddressModel updateAddressModel = _response.object as UpdateAddressModel;
      _addressListModel?.data?.addresses?[position] = updateAddressModel.data ?? Address();
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