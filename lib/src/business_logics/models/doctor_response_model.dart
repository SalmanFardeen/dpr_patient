import 'package:dpr_patient/src/business_logics/models/doctor_data_model.dart';

class DoctorResponseModel {
  bool? success;
  String? message;
  List<Doctor>? data;

  DoctorResponseModel({this.success, this.message, this.data});

  DoctorResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Doctor>[];
      json['data'].forEach((v) {
        data!.add(Doctor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}