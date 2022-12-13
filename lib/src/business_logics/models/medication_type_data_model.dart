class MedicationType {
  String? medicationType;

  MedicationType({this.medicationType});

  MedicationType.fromJson(Map<String, dynamic> json) {
    medicationType = json['medication_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['medication_type'] = medicationType;
    return data;
  }
}
