class UploadPrescriptionsModel {
  String? patientName;
  String? gender;
  String? age;
  String? startTime;
  String? endTime;
  String? issueName;
  String? appointDate;
  String? file;

  UploadPrescriptionsModel(
      {this.patientName,
        this.gender,
        this.age,
        this.startTime,
        this.endTime,
        this.issueName,
        this.appointDate,
        this.file});

  UploadPrescriptionsModel.fromJson(Map<String, dynamic> json) {
    patientName = json['patient_name'];
    gender = json['gender'];
    age = json['age'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    issueName = json['issue_name'];
    appointDate = json['appoint_date'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patient_name'] = patientName;
    data['gender'] = gender;
    data['age'] = age;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['issue_name'] = issueName;
    data['appoint_date'] = appointDate;
    data['file'] = file;
    return data;
  }
}
