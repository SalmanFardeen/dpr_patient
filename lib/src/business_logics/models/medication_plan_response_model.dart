class MedicationPlanResponseModel {
  bool? success;
  String? message;
  List<Data>? data;

  MedicationPlanResponseModel({this.success, this.message, this.data});

  MedicationPlanResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
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

class Data {
  String? medicineName;
  String? note;
  String? date;
  String? time;

  Data({this.medicineName, this.note, this.date, this.time});

  Data.fromJson(Map<String, dynamic> json) {
    medicineName = json['medicine_name'];
    note = json['note'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['medicine_name'] = medicineName;
    data['note'] = note;
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}
