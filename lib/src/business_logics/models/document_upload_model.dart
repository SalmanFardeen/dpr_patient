import 'package:dpr_patient/src/business_logics/models/document_data_model.dart';

class DocumentUploadModel {
  bool? success;
  String? message;
  List<DocumentModel>? data;

  DocumentUploadModel({this.success, this.message, this.data});

  DocumentUploadModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DocumentModel>[];
      json['data'].forEach((v) {
        data!.add(DocumentModel.fromJson(v));
      });
    }  }

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