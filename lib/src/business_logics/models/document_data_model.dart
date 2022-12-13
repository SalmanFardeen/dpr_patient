class DocumentModel {
  int? dcmtNoPk;
  int? userNoFk;
  int? patientNoFk;
  String? doctDescription;
  String? pathName;

  DocumentModel({
    this.dcmtNoPk,
    this.userNoFk,
    this.patientNoFk,
    this.doctDescription,
    this.pathName
  });

  DocumentModel.fromJson(Map<String, dynamic> json) {
    dcmtNoPk = json['dcmt_no_pk'];
    userNoFk = json['user_no_fk'];
    patientNoFk = json['patient_no_fk'];
    doctDescription = json['doct_description'];
    pathName = json['path_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dcmt_no_pk'] = dcmtNoPk;
    data['user_no_fk'] = userNoFk;
    data['patient_no_fk'] = patientNoFk;
    data['doct_description'] = doctDescription;
    data['path_name'] = pathName;
    return data;
  }
}
