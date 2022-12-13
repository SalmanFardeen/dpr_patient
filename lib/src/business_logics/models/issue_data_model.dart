class Issue {

  int? lookupdataNoPk;
  String? lookupdataName;

  Issue(this.lookupdataNoPk, this.lookupdataName);

  Issue.fromJson(Map<String, dynamic> json) {
    lookupdataNoPk = json['lookupdata_no_pk'];
    lookupdataName = json['lookupdata_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lookupdata_no_pk'] = lookupdataNoPk;
    data['lookupdata_name'] = lookupdataName;
    return data;
  }
}