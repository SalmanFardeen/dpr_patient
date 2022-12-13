class Doctor {
  int? personNoPk;
  String? fullName;
  List<Qualification>? qualification;
  String qualificationString = "";
  List<SpecialtyName>? specialtyName;
  String specialtyString = "";
  List<Designation>? designation;
  String? designationString;
  String? chamberName;
  String? visitingFee;
  String? reportingFee;
  String? photoName;
  String? experience;
  int? docFavInd;

  Doctor(
      {this.personNoPk,
        this.fullName,
        this.qualification,
        this.specialtyName,
        this.designation,
        this.chamberName,
        this.visitingFee,
        this.reportingFee,
        this.photoName,
        this.experience,
        this.docFavInd});

  Doctor.fromJson(Map<String, dynamic> json) {
    personNoPk = json['person_no_pk'];
    fullName = json['full_name'];
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
    if (json['designation'] != null) {
      designation = <Designation>[];
      json['designation'].forEach((v) {
        designation!.add(Designation.fromJson(v));
      });
    }
    chamberName = json['chamber_hospital_name'];
    visitingFee = json['visiting_fee'];
    reportingFee = json['report_fee'];
    photoName = json['photo_name'];
    experience = json['patient_consulting_from'];
    docFavInd = json['doc_fav_ind'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['person_no_pk'] = personNoPk;
    data['full_name'] = fullName;
    if (qualification != null) {
      data['qualification'] =
          qualification!.map((v) => v.toJson()).toList();
    }
    if (specialtyName != null) {
      data['specialty_name'] =
          specialtyName!.map((v) => v.toJson()).toList();
    }
    if (designation != null) {
      data['designation'] = designation!.map((v) => v.toJson()).toList();
    }
    data['chamber_hospital_name'] = chamberName;
    data['visiting_fee'] = visitingFee;
    data['report_fee'] = reportingFee;
    data['photo_name'] = photoName;
    data['patient_consulting_from'] = experience;
    data['doc_fav_ind'] = docFavInd;
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

class Designation {
  String? designation;
  String? institution;

  Designation({this.designation, this.institution});

  Designation.fromJson(Map<String, dynamic> json) {
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
