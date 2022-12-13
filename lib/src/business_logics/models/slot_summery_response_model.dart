class SlotSummeryResponseModel {
  bool? success;
  String? message;
  List<Data>? data;

  SlotSummeryResponseModel({this.success, this.message, this.data});

  SlotSummeryResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? startTime;
  String? endTime;
  String day = "Sat";
  int? scheduleDayFri;
  int? scheduleDaySat;
  int? scheduleDaySun;
  int? scheduleDayMon;
  int? scheduleDayTue;
  int? scheduleDayWed;
  int? scheduleDayThu;
  String? chamberHospitalName;

  Data({
    this.startTime,
    this.endTime,
    this.scheduleDayFri,
    this.scheduleDaySat,
    this.scheduleDaySun,
    this.scheduleDayMon,
    this.scheduleDayTue,
    this.scheduleDayWed,
    this.scheduleDayThu,
    this.chamberHospitalName
  });

  Data.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    scheduleDayFri = json['schedule_day_fri'];
    if(scheduleDayFri == 1) day = "Friday";
    scheduleDaySat = json['schedule_day_sat'];
    if(scheduleDaySat == 1) day = "Saturday";
    scheduleDaySun = json['schedule_day_sun'];
    if(scheduleDaySun == 1) day = "Sunday";
    scheduleDayMon = json['schedule_day_mon'];
    if(scheduleDayMon == 1) day = "Monday";
    scheduleDayTue = json['schedule_day_tue'];
    if(scheduleDayTue == 1) day = "Tuesday";
    scheduleDayWed = json['schedule_day_wed'];
    if(scheduleDayWed == 1) day = "Wednesday";
    scheduleDayThu = json['schedule_day_thu'];
    if(scheduleDayThu == 1) day = "Thursday";
    chamberHospitalName = json['chamber_hospital_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['schedule_day_fri'] = scheduleDayFri;
    data['schedule_day_sat'] = scheduleDaySat;
    data['schedule_day_sun'] = scheduleDaySun;
    data['schedule_day_mon'] = scheduleDayMon;
    data['schedule_day_tue'] = scheduleDayTue;
    data['schedule_day_wed'] = scheduleDayWed;
    data['schedule_day_thu'] = scheduleDayThu;
    data['chamber_hospital_name'] = chamberHospitalName;
    return data;
  }
}
