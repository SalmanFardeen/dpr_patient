import 'package:dpr_patient/src/business_logics/models/address_model.dart';

class UpdateAddressModel {
  bool? success;
  String? message;
  Address? data;

  UpdateAddressModel({this.success, this.message, this.data});

  UpdateAddressModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Address.fromJson(json['data']) : null;
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

// class Data {
//   Address? address;
//
//   Data({this.address});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     address =
//     json['address'] != null ? Address.fromJson(json['address']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (address != null) {
//       data['address'] = address?.toJson();
//     }
//     return data;
//   }
// }