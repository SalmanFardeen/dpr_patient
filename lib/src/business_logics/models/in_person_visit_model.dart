import 'package:dpr_patient/src/business_logics/models/doctor_data_model.dart';

class InPersonVisitModel {
  bool? success;
  String? message;
  Data? data;

  InPersonVisitModel({this.success, this.message, this.data});

  InPersonVisitModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  List<Specialities>? specialities;
  List<RecentAppointments>? recentAppointments;
  List<Doctor>? topRatedDoctors;

  Data({this.specialities, this.recentAppointments, this.topRatedDoctors});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['specialities'] != null) {
      specialities = <Specialities>[];
      json['specialities'].forEach((v) {
        specialities?.add(Specialities.fromJson(v));
      });
    }
    if (json['recent-appointments'] != null) {
      recentAppointments = <RecentAppointments>[];
      json['recent-appointments'].forEach((v) {
        recentAppointments?.add(RecentAppointments.fromJson(v));
      });
    }
    if (json['top-rated-doctors'] != null) {
      topRatedDoctors = <Doctor>[];
      json['top-rated-doctors'].forEach((v) {
        topRatedDoctors?.add(Doctor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (specialities != null) {
      data['specialities'] = specialities?.map((v) => v.toJson()).toList();
    }
    if (topRatedDoctors != null) {
      data['top-rated-doctors'] =
          topRatedDoctors?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Specialities {
  String? image;
  String? name;
  String? description;

  Specialities({this.image, this.name, this.description});

  Specialities.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}

class RecentAppointments {
  int? appointNoPk;
  String? image;
  String? name;
  List<SpecialtyName>? speciality;
  String specialtyString = "";

  RecentAppointments({this.appointNoPk, this.image, this.name, this.speciality});

  RecentAppointments.fromJson(Map<String, dynamic> json) {
    appointNoPk = json['appoint_no_pk'];
    image = json['photo_name'];
    name = json['full_name'];
    if (json['specialty_name'] != null) {
      speciality = <SpecialtyName>[];
      json['specialty_name'].forEach((v) {
        speciality!.add(SpecialtyName.fromJson(v));
        if(speciality?.last.specialtyName != null) {
          specialtyString = specialtyString == ""
              ? speciality!.last.specialtyName!
              : specialtyString + ", " + speciality!.last.specialtyName!;
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appoint_no_pk'] = appointNoPk;
    data['photo_name'] = image;
    data['full_name'] = name;
    if (speciality != null) {
      data['specialty_name'] =
          speciality!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpecialtyName {
  String? specialtyName;

  SpecialtyName({this.specialtyName});

  SpecialtyName.fromJson(Map<String, dynamic> json) {
    specialtyName = json['specialty_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['specialty_name'] = specialtyName;
    return data;
  }
}