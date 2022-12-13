class ErrorResponse {
  bool? success;
  String? message;
  List<Errors>? errors;

  ErrorResponse({this.success, this.message, this.errors});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors?.add(Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (errors != null) {
      data['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Errors {
  String? field;
  String? status;
  Errors({this.field, this.status});
  Errors.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field'] = field;
    data['status'] = status;
    return data;
  }
}