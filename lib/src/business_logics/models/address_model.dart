class Address {
  int? addressNoPk;
  String? address;
  int? patientNoFk;
  int? addressInd;
  String? addName;
  String? addArea;
  int? status;

  Address(
      {this.addressNoPk,
        this.address,
        this.patientNoFk,
        this.addressInd,
        this.addName,
        this.addArea,
        this.status});

  Address.fromJson(Map<String, dynamic> json) {
    addressNoPk = json['address_no_pk'];
    address = json['address'];
    patientNoFk = json['patient_no_fk'];
    addressInd = json['address_ind'];
    addName = json['add_name'];
    addArea = json['add_area'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address_no_pk'] = addressNoPk;
    data['address'] = address;
    data['patient_no_fk'] = patientNoFk;
    data['address_ind'] = addressInd;
    data['add_name'] = addName;
    data['add_area'] = addArea;
    data['status'] = status;
    return data;
  }
}