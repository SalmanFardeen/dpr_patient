import 'package:dpr_patient/src/business_logics/models/issue_data_model.dart';

class IssueResponseModel {
  bool? success;
  String? message;
  Data? data;

  IssueResponseModel({this.success, this.message, this.data});

  IssueResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Issue>? tmIssuesList;

  Data({this.tmIssuesList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['tmIssuesList'] != null) {
      tmIssuesList = <Issue>[];
      json['tmIssuesList'].forEach((v) {
        tmIssuesList!.add(Issue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tmIssuesList != null) {
      data['tmIssuesList'] = tmIssuesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}