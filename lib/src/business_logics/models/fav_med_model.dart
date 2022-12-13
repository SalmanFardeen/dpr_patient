class FavMedModel {
  bool? success;
  String? message;
  List<Data>? data;

  FavMedModel({this.success, this.message, this.data});

  FavMedModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? favouriteName;
  int? favouriteItemNoFk;

  Data({this.favouriteName, this.favouriteItemNoFk});

  Data.fromJson(Map<String, dynamic> json) {
    favouriteName = json['favourite_name'];
    favouriteItemNoFk = json['favourite_item_no_fk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['favourite_name'] = favouriteName;
    data['favourite_item_no_fk'] = favouriteItemNoFk;
    return data;
  }
}
