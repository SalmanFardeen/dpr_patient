class FavDocModel {
  bool? success;
  String? message;
  List<Data>? data;

  FavDocModel({this.success, this.message, this.data});

  FavDocModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

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

class Data {
  int? doctorPersonNoFk;
  String? fullName;
  List<Qualification>? qualification;
  List<Specialization>? specialization;
  // String? doctorFee;
  // String? chamberHospitalName;
  String? photoName;
  String specializationString = '';
  String qualificationString = '';

  Data(
      {this.doctorPersonNoFk,
        this.fullName,
        this.qualification,
        this.specialization,
        // this.doctorFee,
        // this.chamberHospitalName,
        this.photoName});

  Data.fromJson(Map<String, dynamic> json) {
    doctorPersonNoFk = json['doctor_person_no_fk'];
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
    if (json['specialization'] != null) {
      specialization = <Specialization>[];
      json['specialization'].forEach((v) {
        specialization!.add(Specialization.fromJson(v));
        if(specialization?.last.specialtyName != null) {
          specializationString = specializationString == ""
              ? specialization!.last.specialtyName!
              : specializationString + ", " + specialization!.last.specialtyName!;
        }
      });
    }
    // doctorFee = json['doctor_fee'];
    // chamberHospitalName = json['chamber_hospital_name'];
    photoName = json['photo_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctor_person_no_fk'] = doctorPersonNoFk;
    data['full_name'] = fullName;
    if (qualification != null) {
      data['qualification'] =
          qualification!.map((v) => v.toJson()).toList();
    }
    if (specialization != null) {
      data['specialization'] =
          specialization!.map((v) => v.toJson()).toList();
    }
    // data['doctor_fee'] = doctorFee;
    // data['chamber_hospital_name'] = chamberHospitalName;
    data['photo_name'] = photoName;
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

class Specialization {
  String? specialtyName;

  Specialization({this.specialtyName});

  Specialization.fromJson(Map<String, dynamic> json) {
    specialtyName = json['specialty_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['specialty_name'] = specialtyName;
    return data;
  }
}
