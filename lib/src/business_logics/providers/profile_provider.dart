import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/patient_info_model.dart';
import 'package:dpr_patient/src/business_logics/models/prescription_view_response_model.dart';
import 'package:dpr_patient/src/business_logics/models/profile_model.dart';
import 'package:dpr_patient/src/business_logics/models/subprofile_delete_model.dart';
import 'package:dpr_patient/src/business_logics/models/subprofile_model.dart';
import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/services/notification_services/push_notification_services.dart';
import 'package:dpr_patient/src/services/repository.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  bool _inProgress = false,
      _profileLoaded = true,
      _subProfileLoaded = false,
      _subProfileDeleted = false,
      _isError = false, _subProfileListLoaded = false;
  late ErrorResponse _errorResponse;
  ProfileModel? _profileModel;
  SubProfileModel? _subProfileModel;
  PatientInfoModel? _patientInfoModel;
  PrescriptionViewResponseModel? _prescriptionViewResponseModel;
  SubProfileDeleteModel? _subProfileDeleteModel;

  // getter of in progress
  bool get inProgress => _inProgress;

  bool get profileLoaded => _profileLoaded;

  bool get subProfileLoaded => _subProfileLoaded;
  bool get subProfileListLoaded => _subProfileListLoaded;

  bool get subProfileDeleted => _subProfileDeleted;

  // getter of boolean if any error occurs
  bool get isError => _isError;

  // get error message
  ErrorResponse get errorResponse => _errorResponse;

  //get profile data
  ProfileModel? get profileModel => _profileModel;

  SubProfileModel? get subProfileModel => _subProfileModel;

  PatientInfoModel? get patientInfoModel => _patientInfoModel;

  PrescriptionViewResponseModel? get prescriptionViewResponseModel => _prescriptionViewResponseModel;

  SubProfileDeleteModel? get subProfileDeleteModel => _subProfileDeleteModel;

  void clear() {
    _profileModel = null;
    _subProfileModel = null;
    _patientInfoModel = null;
    _profileLoaded = true;
    _subProfileLoaded = false;
  }

  Future<bool> getProfile() async {
    _profileLoaded = false;
    notifyListeners();
    final _response = await repository.getProfile();
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _profileLoaded = true;
      _profileModel = _response.object as ProfileModel;
      UserData.username = profileModel?.data?.profile?.patientName;
      UserData.phone = profileModel?.data?.profile?.mobile;
      UserData.address = profileModel?.data?.profile?.address;
      UserData.gender = profileModel?.data?.profile?.gender;
      UserData.age = profileModel?.data?.profile?.age;
      UserData.dprId = profileModel?.data?.profile?.dprId;
      UserData.id = profileModel?.data?.profile?.patientNoPk;
      UserData.callerId = profileModel?.data?.profile?.patientNoPk.toString();
      notifyListeners();
      return true;
    } else {
      _profileLoaded = true;
      _isError = true;
      _errorResponse = _response.object as ErrorResponse;
      notifyListeners();
      return false;
    }
  }

  Future<bool> getSubProfile(int id) async {
    _subProfileLoaded = true;
    notifyListeners();
    final _response = await repository.getSubProfile(id);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _subProfileLoaded = false;
      _subProfileModel = _response.object as SubProfileModel;
      notifyListeners();
      return true;
    } else {
      _subProfileLoaded = false;
      _isError = true;
      _errorResponse = _response.object as ErrorResponse;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteSubProfile(int id) async {
    _subProfileDeleted = true;
    notifyListeners();
    final _response = await repository.deleteSubProfile(id);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _subProfileDeleted = false;
      _subProfileDeleteModel = _response.object as SubProfileDeleteModel;
      notifyListeners();
      return true;
    } else {
      _subProfileDeleted = false;
      _isError = true;
      _errorResponse = _response.object as ErrorResponse;
      notifyListeners();
      return false;
    }
  }

  Future<bool> getSubProfileList(bool isSubScribe) async {
    _subProfileListLoaded = true;
    notifyListeners();
    final _response = await repository.getSubProfileList();
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _subProfileListLoaded = false;
      _patientInfoModel = _response.object as PatientInfoModel;
      if(isSubScribe) {
        _patientInfoModel?.data?.subProfiles?.forEach((element) {
        PushNotificationServices.subscribeTopic('PAT${element.patientNoPk}');
      });
      } else {
        _patientInfoModel?.data?.subProfiles?.forEach((element) {
          PushNotificationServices.unsubscribeTopic('PAT${element.patientNoPk}');
        });
      }
      notifyListeners();
      return true;
    } else {
      _subProfileListLoaded = false;
      _isError = true;
      _errorResponse = _response.object as ErrorResponse;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addSubProfile({
    String? patientImage,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String dob,
    required int gender,
    required int? maritalStatus,
    required String? heightFoot,
    required String? heightInch,
    required String? weight,
    required int? bloodGroup,
    bool bloodDonor = false,
    required String address,
    bool diabetesInd = false,
    bool htnInd = false,
    bool asthmaInd = false,
    required String relation
  }) async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.addSubProfile(
      patientImage: patientImage,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        dob: dob,
        gender: gender,
        maritalStatus: maritalStatus,
        heightFoot: heightFoot,
        heightInch: heightInch,
        weight: weight,
        bloodGroup: bloodGroup,
        bloodDonor: bloodDonor,
        address: address,
        diabetesInd: diabetesInd,
        htnInd: htnInd,
        asthmaInd: asthmaInd,
        relation: relation
    );
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      // _profileModel = _response.object as ProfileModel;
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

  Future<bool> updateProfile({
    required int id,
    String? patientImage,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String dob,
    required int gender,
    required int? maritalStatus,
    required String? heightFoot,
    required String? heightInch,
    required String? weight,
    required int? bloodGroup,
    bool bloodDonor = false,
    required String address,
    bool diabetesInd = false,
    bool htnInd = false,
    bool asthmaInd = false,
    required String relation
  }) async {
    LogDebugger.instance.d('p image: $patientImage');
    _inProgress = true;
    notifyListeners();
    final _response = await repository.updateProfile(
        id: id,
      patientImage: patientImage,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      dob: dob,
      gender: gender,
      maritalStatus: maritalStatus,
      heightFoot: heightFoot,
      heightInch: heightInch,
      weight: weight,
      bloodGroup: bloodGroup,
      bloodDonor: bloodDonor,
      address: address,
      diabetesInd: diabetesInd,
      htnInd: htnInd,
      asthmaInd: asthmaInd,
      relation: relation
    );
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
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

  Future<bool> deleteProfilePic(int id)async {
    _inProgress = true;
    notifyListeners();
    final _response = await repository.deleteProfilePic(id);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
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

  Future<bool> getPrescription({required int id}) async {
    _inProgress = true;
    _prescriptionViewResponseModel = null;
    notifyListeners();
    final _response = await repository.getPrescription(id: id);
    if (_response.id == ResponseCode.SUCCESSFUL) {
      _inProgress = false;
      _prescriptionViewResponseModel = _response.object as PrescriptionViewResponseModel;
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