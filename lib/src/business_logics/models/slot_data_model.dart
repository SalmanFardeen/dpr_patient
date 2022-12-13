class Slot {
  int? scheduleNoPk;
  // String? scheduleDt;
  String? startTime;
  String? endTime;

  Slot({this.scheduleNoPk, this.startTime, this.endTime});

  Slot.fromJson(Map<String, dynamic> json) {
    scheduleNoPk = json['schedule_no_pk'];
    // scheduleDt = json['schedule_dt'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['schedule_no_pk'] = scheduleNoPk;
    // data['schedule_dt'] = scheduleDt;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}