import 'package:dpr_patient/src/business_logics/models/profile_data_model.dart';
import 'package:dpr_patient/src/business_logics/models/upload_prescriptions_model.dart';

class SubProfileModel {
  bool? success;
  String? message;
  Data? data;

  SubProfileModel({this.success, this.message, this.data});

  SubProfileModel.fromJson(Map<String, dynamic> json) {
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
  ProfileData? profile;
  List<Prescriptions>? prescriptions;
  List<UploadPrescriptionsModel>? uploadPrescriptions;

  Data({this.profile, this.prescriptions, this.uploadPrescriptions});

  Data.fromJson(Map<String, dynamic> json) {
    profile =
    json['profile'] != null ? ProfileData.fromJson(json['profile']) : null;
    if (json['prescriptions'] != null) {
      prescriptions = <Prescriptions>[];
      json['prescriptions'].forEach((v) {
        prescriptions!.add(Prescriptions.fromJson(v));
      });
    }
    if (json['upload_prescriptions'] != null) {
      uploadPrescriptions = <UploadPrescriptionsModel>[];
      json['upload_prescriptions'].forEach((v) {
        uploadPrescriptions!.add(UploadPrescriptionsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (prescriptions != null) {
      data['prescriptions'] =
          prescriptions!.map((v) => v.toJson()).toList();
    }
    if (uploadPrescriptions != null) {
      data['upload_prescriptions'] =
          uploadPrescriptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Prescriptions {
  int? prescriptionNoFk;
  String? prescriptionUid;
  int? appointNoPk;
  int? patientNoPk;
  int? doctorNoFk;
  String? startTime;
  String? appointDate;
  String? doctorName;
  List<SpecialtyName>? specialtyName;
  List<DesignationList>? designationList;
  List<DegreeTypeName>? degreeTypeName;
  String specialtyString = "";
  String qualificationString = "";
  String? designationString;

  Prescriptions(
      {this.prescriptionNoFk,
        this.prescriptionUid,
        this.appointNoPk,
        this.patientNoPk,
        this.doctorNoFk,
        this.startTime,
        this.appointDate,
        this.doctorName,
        this.specialtyName,
        this.designationList,
        this.degreeTypeName});

  Prescriptions.fromJson(Map<String, dynamic> json) {
    prescriptionNoFk = json['prescription_no_fk'];
    prescriptionUid = json['prescription_uid'];
    appointNoPk = json['appoint_no_pk'];
    patientNoPk = json['patient_no_pk'];
    doctorNoFk = json['doctor_no_fk'];
    startTime = json['start_time'];
    appointDate = json['appoint_date'];
    doctorName = json['doctor_name'];
    if (json['specialty_name'] != null) {
      specialtyName = <SpecialtyName>[];
      json['specialty_name'].forEach((v) {
        specialtyName!.add(SpecialtyName.fromJson(v));
        if(specialtyName?.last.specialtyName != null) {
          specialtyString = specialtyString == ""
              ? specialtyName!.last.specialtyName!
              : specialtyString + ", " + specialtyName!.last.specialtyName!;
        }
      });
    }
    if (json['designation_list'] != null) {
      designationList = <DesignationList>[];
      json['designation_list'].forEach((v) {
        designationList!.add(DesignationList.fromJson(v));
      });
    }
    if (json['degree_type_name'] != null) {
      degreeTypeName = <DegreeTypeName>[];
      json['degree_type_name'].forEach((v) {
        degreeTypeName!.add(DegreeTypeName.fromJson(v));
        if(degreeTypeName?.last.degreeTypeName != null) {
          qualificationString = qualificationString == ""
              ? degreeTypeName!.last.degreeTypeName!
              : qualificationString + ", " + degreeTypeName!.last.degreeTypeName!;
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prescription_no_fk'] = prescriptionNoFk;
    data['prescription_uid'] = prescriptionUid;
    data['appoint_no_pk'] = appointNoPk;
    data['patient_no_pk'] = patientNoPk;
    data['doctor_no_fk'] = doctorNoFk;
    data['start_time'] = startTime;
    data['appoint_date'] = appointDate;
    data['doctor_name'] = doctorName;
    if (specialtyName != null) {
      data['specialty_name'] =
          specialtyName!.map((v) => v.toJson()).toList();
    }
    if (designationList != null) {
      data['designation_list'] =
          designationList!.map((v) => v.toJson()).toList();
    }
    if (degreeTypeName != null) {
      data['degree_type_name'] =
          degreeTypeName!.map((v) => v.toJson()).toList();
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

class DesignationList {
  String? designation;
  String? institution;

  DesignationList({this.designation, this.institution});

  DesignationList.fromJson(Map<String, dynamic> json) {
    designation = json['designation'];
    institution = json['institution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['designation'] = designation;
    data['institution'] = institution;
    return data;
  }
}

class DegreeTypeName {
  String? degreeTypeName;
  String? institution;
  String? passingYear;
  String? batch;
  String? award;

  DegreeTypeName(
      {this.degreeTypeName,
        this.institution,
        this.passingYear,
        this.batch,
        this.award});

  DegreeTypeName.fromJson(Map<String, dynamic> json) {
    degreeTypeName = json['degree_type_name'];
    institution = json['institution'];
    passingYear = json['passing_year'];
    batch = json['batch'];
    award = json['award'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['degree_type_name'] = degreeTypeName;
    data['institution'] = institution;
    data['passing_year'] = passingYear;
    data['batch'] = batch;
    data['award'] = award;
    return data;
  }
}
