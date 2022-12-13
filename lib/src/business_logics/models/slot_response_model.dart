import 'package:dpr_patient/src/business_logics/models/slot_data_model.dart';

class SlotResponseModel {
  bool? success;
  String? message;
  List<Slot>? data;

  SlotResponseModel({this.success, this.message, this.data});

  SlotResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Slot>[];
      json['data'].forEach((v) {
        data!.add(Slot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}