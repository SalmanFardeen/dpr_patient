import 'package:dpr_patient/src/business_logics/models/address_model.dart';

class AddressListModel {
  bool? success;
  String? message;
  AddressList? data;

  AddressListModel({this.success, this.message, this.data});

  AddressListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? AddressList.fromJson(json['data']) : null;
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

class AddressList {
  List<Address>? addresses;

  AddressList({this.addresses});

  AddressList.fromJson(Map<String, dynamic> json) {
    if (json['addresses'] != null) {
      addresses = <Address>[];
      json['addresses'].forEach((v) {
        addresses?.add(Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (addresses != null) {
      data['addresses'] = addresses?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}