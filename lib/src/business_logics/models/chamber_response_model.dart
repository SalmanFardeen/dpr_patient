import 'package:dpr_patient/src/business_logics/models/chamber_data_model.dart';

class ChamberResponseModel {
  bool? success;
  String? message;
  List<Chambers>? data;

  ChamberResponseModel({this.success, this.message, this.data});

  ChamberResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Chambers>[];
      json['data'].forEach((v) {
        data!.add(Chambers.fromJson(v));
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