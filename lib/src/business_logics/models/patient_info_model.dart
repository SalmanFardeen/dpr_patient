import 'package:dpr_patient/src/business_logics/models/profile_data_model.dart';

class PatientInfoModel {
  bool? success;
  String? message;
  Data? data;

  PatientInfoModel({this.success, this.message, this.data});

  PatientInfoModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  List<ProfileData>? subProfiles;

  Data({this.subProfiles});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['sub-profiles'] != null) {
      subProfiles = <ProfileData>[];
      json['sub-profiles'].forEach((v) {
        subProfiles?.add(ProfileData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (subProfiles != null) {
      data['sub-profiles'] = subProfiles?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
