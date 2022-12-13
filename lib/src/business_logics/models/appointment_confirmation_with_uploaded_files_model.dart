class AppointmentConfirmationWithUploadedFilesModel {
  bool? success;
  String? message;
  Data? data;

  AppointmentConfirmationWithUploadedFilesModel(
      {this.success, this.message, this.data});

  AppointmentConfirmationWithUploadedFilesModel.fromJson(
      Map<String, dynamic> json) {
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
  Appointment? appointment;

  Data({this.appointment});

  Data.fromJson(Map<String, dynamic> json) {
    appointment = json['appointment'] != null
        ? Appointment.fromJson(json['appointment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (appointment != null) {
      data['appointment'] = appointment!.toJson();
    }
    return data;
  }
}

class Appointment {
  int? appointNoPk;
  int? patientNoPk;
  String? doctorName;
  String? doctorPhoto;
  List<SpecialtyName>? specialtyName;
  String specialtyString = "";
  String? experience;
  String? patientName;
  String? age;
  String? gender;
  int? serial;
  String? appointDate;
  String? startTime;
  String? endTime;
  int? issueNoFk;
  String? issueName;
  List<DesignationList>? designationList;
  String? doctorFee;
  String? doctorTeleFee;
  String? reportFee;
  String? teleReportFee;
  List<Qualification>? qualification;
  String qualificationString = "";
  String? chiefComplain;
  String? chamberHospitalName;
  List<String>? filePath;
  List<String>? selectedImage;

  Appointment(
      {this.appointNoPk,
        this.patientNoPk,
        this.doctorName,
        this.doctorPhoto,
        this.specialtyName,
        this.experience,
        this.patientName,
        this.age,
        this.gender,
        this.serial,
        this.appointDate,
        this.startTime,
        this.endTime,
        this.issueNoFk,
        this.issueName,
        this.designationList,
        this.doctorFee,
        this.doctorTeleFee,
        this.reportFee,
        this.teleReportFee,
        this.qualification,
        this.chiefComplain,
        this.chamberHospitalName,
        this.filePath,
        this.selectedImage});

  Appointment.fromJson(Map<String, dynamic> json) {
    appointNoPk = json['appoint_no_pk'];
    patientNoPk = json['patient_no_pk'];
    doctorName = json['doctor_name'];
    doctorPhoto = json['doctor_photo'];
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
    experience = json['experience'];
    patientName = json['patient_name'];
    age = json['age'];
    gender = json['gender'];
    serial = json['serial'];
    appointDate = json['appoint_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    issueNoFk = json['issue_no_fk'];
    issueName = json['issue_name'];
    if (json['designation_list'] != null) {
      designationList = <DesignationList>[];
      json['designation_list'].forEach((v) {
        designationList!.add(DesignationList.fromJson(v));
      });
    }
    doctorFee = json['doctor_fee'];
    doctorTeleFee = json['doctor_tele_fee'];
    reportFee = json['report_fee'];
    teleReportFee = json['tele_report_fee'];
    if (json['qualification'] != null) {
      qualification = <Qualification>[];
      json['qualification'].forEach((v) {
        qualification!.add(Qualification.fromJson(v));
        if(qualification?.last.degreeTypeName != null) {
          qualificationString = qualificationString == ""
              ? qualification!.last.degreeTypeName!
              : qualificationString + ", " + qualification!.last.degreeTypeName!;
        }
      });
    }
    chiefComplain = json['chif_complain'];
    chamberHospitalName = json['chamber_hospital_name'];
    if(json['Selected_Image'] != null) {
      selectedImage = json['Selected_Image'].cast<String>();
    }
    if(json['file_path'] != null) {
      filePath = json['file_path'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appoint_no_pk'] = appointNoPk;
    data['patient_no_pk'] = patientNoPk;
    data['doctor_name'] = doctorName;
    data['doctor_photo'] = doctorPhoto;
    if (specialtyName != null) {
      data['specialty_name'] =
          specialtyName!.map((v) => v.toJson()).toList();
    }
    data['experience'] = experience;
    data['patient_name'] = patientName;
    data['age'] = age;
    data['gender'] = gender;
    data['serial'] = serial;
    data['appoint_date'] = appointDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['issue_no_fk'] = issueNoFk;
    data['issue_name'] = issueName;
    if (designationList != null) {
      data['designation_list'] =
          designationList!.map((v) => v.toJson()).toList();
    }
    data['doctor_fee'] = doctorFee;
    data['doctor_tele_fee'] = doctorTeleFee;
    data['report_fee'] = reportFee;
    data['tele_report_fee'] = teleReportFee;
    if (qualification != null) {
      data['qualification'] =
          qualification!.map((v) => v.toJson()).toList();
    }
    data['chif_complain'] = chiefComplain;
    data['chamber_hospital_name'] = chamberHospitalName;
    data['Selected_Image'] = selectedImage;
    data['file_path'] = filePath;
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

class Qualification {
  String? degreeTypeName;
  String? institution;
  String? passingYear;
  String? batch;
  String? award;

  Qualification(
      {this.degreeTypeName,
        this.institution,
        this.passingYear,
        this.batch,
        this.award});

  Qualification.fromJson(Map<String, dynamic> json) {
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
