import 'package:dpr_patient/src/business_logics/models/medication_type_data_model.dart';

class MedicationTypeResponseModel {
  bool? success;
  String? message;
  List<MedicationType>? data;

  MedicationTypeResponseModel({this.success, this.message, this.data});

  MedicationTypeResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MedicationType>[];
      json['data'].forEach((v) {
        data?.add(MedicationType.fromJson(v));
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