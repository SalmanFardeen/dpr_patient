class Chambers {
  int? chamberNoPk;
  String? chamberName;

  Chambers({this.chamberNoPk, this.chamberName});

  Chambers.fromJson(Map<String, dynamic> json) {
    chamberNoPk = json['chamber_telemidicine_no_fk'];
    chamberName = json['chamber_hospital_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chamber_telemidicine_no_fk'] = chamberNoPk;
    data['chamber_hospital_name'] = chamberName;
    return data;
  }
}