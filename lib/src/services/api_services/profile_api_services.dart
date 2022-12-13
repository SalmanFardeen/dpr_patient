import 'dart:convert';
import 'dart:io';

import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/patient_info_model.dart';
import 'package:dpr_patient/src/business_logics/models/prescription_view_response_model.dart';
import 'package:dpr_patient/src/business_logics/models/profile_model.dart';
import 'package:dpr_patient/src/business_logics/models/subprofile_delete_model.dart';
import 'package:dpr_patient/src/business_logics/models/subprofile_model.dart';
import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/utils/constants.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/services/file_manager_services/image_compression_service.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;


class ProfileAPIServices {

  final Logger _logger = Logger();

  Future<ResponseObject> getProfile() async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/profile');
      final request = http.Request("GET", uri);
      // header data for api
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      String? accessToken = UserData.accessToken;
      _logger.d("accessToken: $accessToken");
      request.headers['Authorization'] = "Bearer $accessToken";

      final _response = await request.send();
      final responseData = await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          // _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: ProfileModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED, object: ErrorResponse.fromJson(decodedJson)
          );
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson)
        );
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> getSubProfile(int id) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/sub-profiles/$id');
      final request = http.Request("GET", uri);
      // header data for api
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      String? accessToken = UserData.accessToken;
      _logger.d("accessToken: $accessToken");
      request.headers['Authorization'] = "Bearer $accessToken";

      final _response = await request.send();
      final responseData = await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          // _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: SubProfileModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED, object: ErrorResponse.fromJson(decodedJson)
          );
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson)
        );
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> deleteSubProfile(int id) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/sub-profiles/$id');
      final request = http.Request("DELETE", uri);
      // header data for api
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      String? accessToken = UserData.accessToken;
      _logger.d("accessToken: $accessToken");
      request.headers['Authorization'] = "Bearer $accessToken";

      final _response = await request.send();
      final responseData = await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          // _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: SubProfileDeleteModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED, object: ErrorResponse.fromJson(decodedJson)
          );
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson)
        );
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }


  Future<ResponseObject> getSubProfileList() async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/sub-profiles');
      final request = http.MultipartRequest("GET", uri);
      // header data for api
      _logger.d("accessToken: ${UserData.accessToken}");
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = "Bearer ${UserData.accessToken}";

      final _response = await request.send();
      final responseData = await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: PatientInfoModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED, object: ErrorResponse.fromJson(decodedJson)
          );
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson)
        );
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> addSubProfile({
    String? patientImage,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String dob,
    required int gender,
    required int? maritalStatus,
    required String? heightFoot,
    required String? heightInch,
    required String? weight,
    required int? bloodGroup,
    bool bloodDonor = false,
    required String address,
    bool diabetesInd = false,
    bool htnInd = false,
    bool asthmaInd = false,
    String relation =  'Self'
  }) async {
    try {
      _logger.d('Creating profile');
      Uri uri = Uri.parse(BASE_URL + '/api/sub-profiles');
      final request = http.MultipartRequest("POST", uri);
      // header data for api
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      String? accessToken = UserData.accessToken;
      _logger.d("accessToken: $accessToken");
      request.headers['Authorization'] = "Bearer $accessToken";

      if(patientImage != null) request.fields['patient_image'] = patientImage;

      request.fields.addAll({
        'fname': firstName,
        'lname': lastName,
        'gender': gender.toString(),
        'email': email,
        'mobile': phoneNumber,
        'dob': dob,
        'marital_status': maritalStatus == null ? "" : maritalStatus.toString(),
        'initial_height': heightFoot.toString() + "." + heightInch.toString(),
        'initial_weight': weight ?? "",
        'blood_group': bloodGroup == null ? "" : bloodGroup.toString(),
        'donate_blood_ind': bloodDonor ? '1' : '0',
        'diabets_ind': diabetesInd ? '1' : '0',
        'htn_ind': htnInd ? '1' : '0',
        'asthma_ind': asthmaInd ? '1' : '0',
        'address': address,
        'relation': relation
      });

      if(patientImage != null) request.files.add(await _getMultipartFile('patient_image', File(patientImage)));

      // _logger.d('body: ${request.body}');

      final _response = await request.send();
      final responseData = await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          // _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: ProfileModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED, object: ErrorResponse.fromJson(decodedJson)
          );
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson)
        );
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> updateProfile({
    required int id,
    String? patientImage,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String dob,
    required int gender,
    required int? maritalStatus,
    required String? heightFoot,
    required String? heightInch,
    required String? weight,
    required int? bloodGroup,
    bool bloodDonor = false,
    required String address,
    bool diabetesInd = false,
    bool htnInd = false,
    bool asthmaInd = false,
    String relation =  'Self'
  }) async {
    try {
      _logger.d('Updating profile');
      Uri uri = Uri.parse(BASE_URL + '/api/sub-profiles-update/$id');
      final request = http.MultipartRequest("POST", uri);
      // header data for api
      request.headers['Accept'] = 'application/json';
      // request.headers['Content-Type'] = 'application/json';
      String? accessToken = UserData.accessToken;
      _logger.d("accessToken: $accessToken");
      request.headers['Authorization'] = "Bearer $accessToken";

      if(patientImage != null) request.files.add(await _getMultipartFile('patient_image', File(patientImage)));

      _logger.d('image path: $patientImage');

      request.fields.addAll({
        'fname': firstName,
        'lname': lastName,
        'gender': gender.toString(),
        'email': email,
        'mobile': phoneNumber,
        'dob': dob,
        'marital_status': maritalStatus == null ? "" : maritalStatus.toString(),
        'initial_height': heightFoot.toString() + "." + heightInch.toString(),
        'initial_weight': weight ?? "",
        'blood_group': bloodGroup == null ? "" : bloodGroup.toString(),
        'donate_blood_ind': bloodDonor ? '1' : '0',
        'diabets_ind': diabetesInd ? '1' : '0',
        'htn_ind': htnInd ? '1' : '0',
        'asthma_ind': asthmaInd ? '1' : '0',
        'address': address,
        'relation': relation
      });

      _logger.d('body: ${request.fields}');

      final _response = await request.send();
      final responseData = await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          // _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: ProfileModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED, object: ErrorResponse.fromJson(decodedJson)
          );
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson)
        );
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> deleteProfilePic(int id) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/patient-image-delete/$id');
      final request = http.Request("POST", uri);
      // header data for api
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      String? accessToken = UserData.accessToken;
      _logger.d("accessToken: $accessToken");
      request.headers['Authorization'] = "Bearer $accessToken";

      final _response = await request.send();
      final responseData =
      await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: decodedJson['message']
          );
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson)
          );
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson)
        );
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> getPrescription({required int id}) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/view-prescription');
      final request = http.Request("POST", uri);
      // header data for api
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      String? accessToken = UserData.accessToken;
      _logger.d("accessToken: $accessToken");
      request.headers['Authorization'] = "Bearer $accessToken";

      request.body = jsonEncode({
        "prescription_no_pk": id
      });

      _logger.i("prescription id:" + request.body);

      final _response = await request.send();
      final responseData =
      await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          var prescriptionViewResponseModel = PrescriptionViewResponseModel.fromJson(decodedJson);
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: prescriptionViewResponseModel
          );
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson)
          );
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson)
        );
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<http.MultipartFile> _getMultipartFile(
  String attribute, File image) async {
    File file = File("");
    int limit = 1; //mb
    if (ImageCompressionService.instance.fileSize(image) > limit) {
      final dir = await path_provider.getTemporaryDirectory();
      final fileSize =
      ImageCompressionService.instance.fileSize(image); // 500mb
      final ratioOfQuality = 100 - ((fileSize - limit) / (fileSize / 100));
      final targetPath = dir.absolute.path + "/temp.jpg";
      file = await ImageCompressionService.instance
          .testCompressAndGetFile(image, targetPath, ratioOfQuality.floor());
      LogDebugger.instance.v(
          'original >= : ${ImageCompressionService.instance.fileSize(image)}; compressed: '
              '${ImageCompressionService.instance.fileSize(file)}');
    } else {
      file = image;
      LogDebugger.instance
          .v('original: ${ImageCompressionService.instance.fileSize(image)}');
    }
    var stream = http.ByteStream(file.openRead());
    stream.cast();
    var length = await file.length();

    final multipartFile = http.MultipartFile(
      attribute,
      stream,
      length,
      filename: basename(file.path),
    );

    return multipartFile;
  }
}