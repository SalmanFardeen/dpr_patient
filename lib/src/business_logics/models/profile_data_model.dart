class ProfileData {
  int? patientNoPk;
  String? image;
  String? patientName;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? address;
  String? gender;
  String? dob;
  String? height;
  String? weight;
  String? bloodGroup;
  int? donateBloodInd;
  String? patRelation;
  int? htnInd;
  int? asthmaInd;
  int? diabetesInd;
  String? maritalStatus;
  String? age;
  String? dprId;

  ProfileData(
      {this.patientNoPk,
        this.image,
        this.patientName,
        this.firstName,
        this.lastName,
        this.email,
        this.mobile,
        this.address,
        this.gender,
        this.dob,
        this.height,
        this.weight,
        this.bloodGroup,
        this.donateBloodInd,
        this.patRelation,
        this.htnInd,
        this.asthmaInd,
        this.diabetesInd,
        this.maritalStatus,
        this.age,
        this.dprId});

  ProfileData.fromJson(Map<String, dynamic> json) {
    patientNoPk = json['patient_no_pk'];
    image = json['patient_photo'];
    patientName = json['patient_name'];
    firstName = json['fname'];
    lastName = json['lname'];
    email = json['email'];
    mobile = json['mobile'];
    address = json['address'];
    gender = json['gender'];
    dob = json['dob'];
    height = json['height'];
    weight = json['weight'];
    bloodGroup = json['blood_group'];
    donateBloodInd = json['donate_blood_ind'];
    patRelation = json['pat_relation'];
    htnInd = json['htn_ind'];
    asthmaInd = json['asthma_ind'];
    diabetesInd = json['diabets_ind'];
    maritalStatus = json['marital_status'];
    age = json['age'];
    dprId = json['dpr_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patient_no_pk'] = patientNoPk;
    data['patient_photo'] = image;
    data['patient_name'] = patientName;
    data['fname'] = firstName;
    data['lname'] = firstName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['address'] = address;
    data['gender'] = gender;
    data['dob'] = dob;
    data['height'] = height;
    data['weight'] = weight;
    data['blood_group'] = bloodGroup;
    data['donate_blood_ind'] = donateBloodInd;
    data['pat_relation'] = patRelation;
    data['htn_ind'] = htnInd;
    data['asthma_ind'] = asthmaInd;
    data['diabets_ind'] = diabetesInd;
    data['marital_status'] = maritalStatus;
    data['age'] = age;
    data['dpr_id'] = dprId;
    return data;
  }
}