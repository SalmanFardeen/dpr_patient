import 'dart:io';

class DoctorAppointmentInputModel {
  String? appointDate;
  int? patientNoFk;
  int? doctorNoFk;
  String? phoneMobile;
  bool? reportShow;
  int? chamber;
  String? chiefComplain;
  int? issueNoFk;
  int? slotNoPk;
  bool? isTelemed;
  String? issueTxt;
  String? slotTxt;
  String? patientName;
  String? patientAge;
  String? patientGender;
  String? doctorName;
  String? expertise;
  String? degree;
  String? doctorImage;
  String? chamberHospitalName;
  String? doctorFee;
  String? reportFee;
  List<File>? uploadImages;
  List<int>? docList;

  DoctorAppointmentInputModel(
      {this.appointDate,
        this.patientNoFk,
        this.doctorNoFk,
        this.phoneMobile,
        this.reportShow,
        this.chamber,
        this.chiefComplain,
        this.issueNoFk,
        this.slotNoPk,
        this.isTelemed,
        this.issueTxt,
        this.slotTxt,
        this.patientName,
        this.patientAge,
        this.patientGender,
        this.doctorName,
        this.expertise,
        this.degree,
        this.doctorImage,
        this.chamberHospitalName,
        this.doctorFee,
        this.reportFee,
        this.uploadImages,
        this.docList});

  DoctorAppointmentInputModel.fromJson(Map<String, dynamic> json) {
    appointDate = json['appoint_date'];
    patientNoFk = json['patient_no_fk'];
    doctorNoFk = json['doctor_no_fk'];
    phoneMobile = json['phone_mobile'];
    reportShow = json['report_show'];
    chamber = json['chamber'];
    chiefComplain = json['chief_complain'];
    issueNoFk = json['issue_no_fk'];
    slotNoPk = json['slot_no_pk'];
    isTelemed = json['is_telemed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appoint_date'] = appointDate;
    data['patient_no_fk'] = patientNoFk;
    data['doctor_no_fk'] = doctorNoFk;
    data['phone_mobile'] = phoneMobile;
    data['report_show'] = reportShow;
    data['chamber'] = chamber;
    data['chief_complain'] = chiefComplain;
    data['issue_no_fk'] = issueNoFk;
    data['slot_no_pk'] = slotNoPk;
    data['is_telemed'] = isTelemed;
    return data;
  }
}
