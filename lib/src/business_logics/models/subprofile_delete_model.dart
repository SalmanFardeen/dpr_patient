class SubProfileDeleteModel {
  bool? success;
  String? message;
  // Null? data;

  SubProfileDeleteModel({this.success, this.message});

  SubProfileDeleteModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    // data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    // data['data'] = this.data;
    return data;
  }
}
