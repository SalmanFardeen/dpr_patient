class PrescriptionViewResponseModel {
  bool? success;
  String? message;
  PrescriptionViewResponseData? data;

  PrescriptionViewResponseModel({this.success, this.message, this.data});

  PrescriptionViewResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? PrescriptionViewResponseData.fromJson(json['data']) : null;
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

class PrescriptionViewResponseData {
  PrescriptionDetails? prescriptionDetails;
  List<VitalsDetails>? vitalsDetails;
  List<ViewPrescriptionDataModel>? chiefComplaints;
  List<ViewPrescriptionDataModel>? examinationDetails;
  List<ViewPrescriptionDataModel>? investigationDetails;
  List<ViewPrescriptionDataModel>? adviceDetails;
  List<Medications>? medications;

  PrescriptionViewResponseData(
      {this.prescriptionDetails,
        this.vitalsDetails,
        this.chiefComplaints,
        this.examinationDetails,
        this.investigationDetails,
        this.adviceDetails,
        this.medications});

  PrescriptionViewResponseData.fromJson(Map<String, dynamic> json) {
    prescriptionDetails = json['prescription_details'] != null
        ? PrescriptionDetails.fromJson(json['prescription_details'])
        : null;
    if (json['vitals_details'] != null) {
      vitalsDetails = <VitalsDetails>[];
      json['vitals_details'].forEach((v) {
        vitalsDetails!.add(VitalsDetails.fromJson(v));
      });
    }
    if (json['chief_complaints'] != null) {
      chiefComplaints = <ViewPrescriptionDataModel>[];
      json['chief_complaints'].forEach((v) {
        chiefComplaints!.add(ViewPrescriptionDataModel.fromJson(v));
      });
    }
    if (json['examination_details'] != null) {
      examinationDetails = <ViewPrescriptionDataModel>[];
      json['examination_details'].forEach((v) {
        examinationDetails!.add(ViewPrescriptionDataModel.fromJson(v));
      });
    }
    if (json['investigation_details'] != null) {
      investigationDetails = <ViewPrescriptionDataModel>[];
      json['investigation_details'].forEach((v) {
        investigationDetails!.add(ViewPrescriptionDataModel.fromJson(v));
      });
    }
    if (json['advice_details'] != null) {
      adviceDetails = <ViewPrescriptionDataModel>[];
      json['advice_details'].forEach((v) {
        adviceDetails!.add(ViewPrescriptionDataModel.fromJson(v));
      });
    }
    if (json['medications'] != null) {
      medications = <Medications>[];
      json['medications'].forEach((v) {
        medications!.add(Medications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (prescriptionDetails != null) {
      data['prescription_details'] = prescriptionDetails!.toJson();
    }
    if (vitalsDetails != null) {
      data['vitals_details'] =
          vitalsDetails!.map((v) => v.toJson()).toList();
    }
    if (chiefComplaints != null) {
      data['chief_complaints'] =
          chiefComplaints!.map((v) => v.toJson()).toList();
    }
    if (examinationDetails != null) {
      data['examination_details'] =
          examinationDetails!.map((v) => v.toJson()).toList();
    }
    if (investigationDetails != null) {
      data['investigation_details'] =
          investigationDetails!.map((v) => v.toJson()).toList();
    }
    if (adviceDetails != null) {
      data['advice_details'] =
          adviceDetails!.map((v) => v.toJson()).toList();
    }
    if (medications != null) {
      data['medications'] = medications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrescriptionDetails {
  int? prescriptionNoPk;
  int? patientNoFk;
  int? appointNoFk;
  int? doctorPersonNoFk;
  int? nextAppointmentDay;
  String? prescriptionDate;
  String? appointDate;
  int? slotSl;
  String? patientName;
  String? age;
  String? mobile1;
  String? initialWeight;
  String? initialHeight;
  String? doctorName;
  List<SpecialtyName>? specialtyName;
  List<DesignationList>? designationList;
  String? chamberHospitalName;
  String? visitingFee;
  List<DegreeTypeName>? degreeTypeName;
  String? genderName;
  String? bloodTxt;
  String? maritalTxt;
  String specialtyString = "";
  String qualificationString = "";

  PrescriptionDetails(
      {this.prescriptionNoPk,
        this.patientNoFk,
        this.appointNoFk,
        this.doctorPersonNoFk,
        this.nextAppointmentDay,
        this.prescriptionDate,
        this.appointDate,
        this.slotSl,
        this.patientName,
        this.age,
        this.mobile1,
        this.initialWeight,
        this.initialHeight,
        this.doctorName,
        this.specialtyName,
        this.designationList,
        this.chamberHospitalName,
        this.visitingFee,
        this.degreeTypeName,
        this.genderName,
        this.bloodTxt,
        this.maritalTxt});

  PrescriptionDetails.fromJson(Map<String, dynamic> json) {
    prescriptionNoPk = json['prescription_no_pk'];
    patientNoFk = json['patient_no_fk'];
    appointNoFk = json['appoint_no_fk'];
    doctorPersonNoFk = json['doctor_person_no_fk'];
    nextAppointmentDay = json['next_appointment_day'];
    prescriptionDate = json['prescription_date'];
    appointDate = json['appoint_date'];
    slotSl = json['slot_sl'];
    patientName = json['patient_name'];
    age = json['age'];
    mobile1 = json['mobile1'];
    initialWeight = json['initial_weight'];
    initialHeight = json['initial_height'];
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
    chamberHospitalName = json['chamber_hospital_name'];
    visitingFee = json['visiting_fee'];
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
    genderName = json['gender_name'];
    bloodTxt = json['blood_txt'];
    maritalTxt = json['marital_txt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prescription_no_pk'] = prescriptionNoPk;
    data['patient_no_fk'] = patientNoFk;
    data['appoint_no_fk'] = appointNoFk;
    data['doctor_person_no_fk'] = doctorPersonNoFk;
    data['next_appointment_day'] = nextAppointmentDay;
    data['prescription_date'] = prescriptionDate;
    data['appoint_date'] = appointDate;
    data['slot_sl'] = slotSl;
    data['patient_name'] = patientName;
    data['age'] = age;
    data['mobile1'] = mobile1;
    data['initial_weight'] = initialWeight;
    data['initial_height'] = initialHeight;
    data['doctor_name'] = doctorName;
    if (specialtyName != null) {
      data['specialty_name'] =
          specialtyName!.map((v) => v.toJson()).toList();
    }
    if (designationList != null) {
      data['designation_list'] =
          designationList!.map((v) => v.toJson()).toList();
    }
    data['chamber_hospital_name'] = chamberHospitalName;
    data['visiting_fee'] = visitingFee;
    if (degreeTypeName != null) {
      data['degree_type_name'] =
          degreeTypeName!.map((v) => v.toJson()).toList();
    }
    data['gender_name'] = genderName;
    data['blood_txt'] = bloodTxt;
    data['marital_txt'] = maritalTxt;
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

class VitalsDetails {
  String? heightVal;
  int? weightVal;
  String? bmi;
  int? tempVal;
  int? pulseVal;
  int? bpValSys;
  int? bpValDia;

  VitalsDetails(
      {this.heightVal,
        this.weightVal,
        this.bmi,
        this.tempVal,
        this.pulseVal,
        this.bpValSys,
        this.bpValDia});

  VitalsDetails.fromJson(Map<String, dynamic> json) {
    heightVal = json['height_val'];
    weightVal = json['weight_val'];
    bmi = json['bmi'];
    tempVal = json['temp_val'];
    pulseVal = json['pulse_val'];
    bpValSys = json['bp_val_sys'];
    bpValDia = json['bp_val_dia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['height_val'] = heightVal;
    data['weight_val'] = weightVal;
    data['bmi'] = bmi;
    data['temp_val'] = tempVal;
    data['pulse_val'] = pulseVal;
    data['bp_val_sys'] = bpValSys;
    data['bp_val_dia'] = bpValDia;
    return data;
  }
}

class ViewPrescriptionDataModel {
  String? prescritionData;

  ViewPrescriptionDataModel({this.prescritionData});

  ViewPrescriptionDataModel.fromJson(Map<String, dynamic> json) {
    prescritionData = json['prescrition_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prescrition_data'] = prescritionData;
    return data;
  }
}

class Medications {
  String? brandName;
  String? dosage;
  String? duration;
  int? itemQty;
  String? instructionTake;
  String? medicineComment;

  Medications(
      {this.brandName,
        this.dosage,
        this.duration,
        this.itemQty,
        this.instructionTake,
        this.medicineComment});

  Medications.fromJson(Map<String, dynamic> json) {
    brandName = json['brand_name'];
    dosage = json['dosage'];
    duration = json['duration'];
    itemQty = json['item_qty'];
    instructionTake = json['instruction_take'];
    medicineComment = json['medicine_comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brand_name'] = brandName;
    data['dosage'] = dosage;
    data['duration'] = duration;
    data['item_qty'] = itemQty;
    data['instruction_take'] = instructionTake;
    data['medicine_comment'] = medicineComment;
    return data;
  }
}
