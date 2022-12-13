import 'package:dpr_patient/src/business_logics/models/doctor_data_model.dart';

class DoctorDetailsModel {
  bool? success;
  String? message;
  Doctor? data;

  DoctorDetailsModel({this.success, this.message, this.data});

  DoctorDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Doctor.fromJson(json['data']) : null;
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