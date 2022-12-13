import 'dart:convert';
import 'dart:io';

import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/models/appointment_confirmation_model.dart';
import 'package:dpr_patient/src/business_logics/models/appointment_confirmation_with_uploaded_files_model.dart';
import 'package:dpr_patient/src/business_logics/models/chamber_response_model.dart';
import 'package:dpr_patient/src/business_logics/models/doctor_details_model.dart';
import 'package:dpr_patient/src/business_logics/models/error_response.dart';
import 'package:dpr_patient/src/business_logics/models/in_person_visit_model.dart';
import 'package:dpr_patient/src/business_logics/models/doctor_response_model.dart';
import 'package:dpr_patient/src/business_logics/models/issue_response_model.dart';
import 'package:dpr_patient/src/business_logics/models/patient_info_model.dart';
import 'package:dpr_patient/src/business_logics/models/slot_response_model.dart';
import 'package:dpr_patient/src/business_logics/models/slot_summery_response_model.dart';
import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/utils/constants.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class InPersonVistiAPIServices {
  final Logger _logger = Logger();

  Future<ResponseObject> getInPersonVisitDoctorList(
      {required String type}) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/doctor-list?type=$type');
      final request = http.Request("GET", uri);
      // header data for api
      _logger.d("accessToken: $uri");
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = "Bearer ${UserData.accessToken}";

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: InPersonVisitModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      // _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> getInPersonVisitDoctorSearch(String key,
      {bool isTelemedicine = false}) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/doctor-search');
      final request = http.Request("POST", uri);
      // header data for api
      _logger.d("accessToken: ${UserData.accessToken}");
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = "Bearer ${UserData.accessToken}";

      request.body = json.encode({'q': key, 'telemed': isTelemedicine});

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: DoctorResponseModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> getDoctorDetails(
      {required int id, required String type}) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/doctors/$id?type=$type');
      _logger.d('url: $uri');
      final request = http.Request("GET", uri);
      // header data for api
      _logger.d("accessToken: ${UserData.accessToken}");
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = "Bearer ${UserData.accessToken}";

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: DoctorDetailsModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> getDoctorChambers(int id) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/doctors/$id/chambers');
      final request = http.Request("GET", uri);
      // header data for api
      _logger.d("accessToken: ${UserData.accessToken}");
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = "Bearer ${UserData.accessToken}";

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: ChamberResponseModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> getPatientList() async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/sub-profiles');
      final request = http.MultipartRequest("GET", uri);
      // header data for api
      _logger.d("accessToken: ${UserData.accessToken}");
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = "Bearer ${UserData.accessToken}";

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
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
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> setAppointment(
      {required String date,
      required int patientFkNo,
      required int doctorFkNo,
      required String phoneMobile,
      required bool reportShow,
      int? chamberFkNo,
      int? slot,
      int? issue,
      String? chiefComplain,
      required bool isTelemed}) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/appointments');
      final request = http.Request("POST", uri);
      // header data for api
      _logger.d("accessToken: ${UserData.accessToken}");
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = "Bearer ${UserData.accessToken}";

      request.body = json.encode({
        "appoint_date": date,
        "doctor_no_fk": doctorFkNo,
        "patient_no_fk": patientFkNo,
        "phone_mobile": phoneMobile,
        "report_show": reportShow,
        "chamber": chamberFkNo,
        "issue_no_fk": issue,
        "slot_no_pk": slot,
        "chief_complain": chiefComplain,
        "is_telemed": isTelemed
      });

      _logger.v(request.body);

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: AppointmentConfirmationModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> setAppointmentWithUpload(
      {required String date,
        required int patientFkNo,
        required int doctorFkNo,
        required String phoneMobile,
        required bool reportShow,
        int? chamberFkNo,
        int? slot,
        int? issue,
        String? chiefComplain,
        required bool isTelemed,
        required List<File>? images,
        required List<int>? docList}) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/appointments-new');
      final request = http.MultipartRequest("POST", uri);
      // header data for api
      _logger.d("accessToken: ${UserData.accessToken}");
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = "Bearer ${UserData.accessToken}";

      String str1 = docList.toString().replaceAll('[', '');
      String str2 = str1.replaceAll(']', '');

      request.fields.addAll({
        'appoint_date': date,
        'patient_no_fk': '$patientFkNo',
        'doctor_no_fk': '$doctorFkNo',
        'phone_mobile': phoneMobile,
        'report_show': reportShow ? '1' : '0',
        'chamber': '$chamberFkNo',
        'chief_complain': '$chiefComplain',
        'issue_no_fk': '$issue',
        'slot_no_pk': '$slot',
        'type': 'patient_appointment',
        'is_telemed': isTelemed ? '1' : '0',
        'doc_id': (docList?.length ?? 0) > 0 ? str2 : ''
      });

      if (images!.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          if (images[i].path != '') {
            request.files.add(await http.MultipartFile.fromPath(
                'appointment_file[]', images[i].path));
          }
        }
      }

      _logger.v(request.fields);
      _logger.v(request.files.toList());

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: AppointmentConfirmationWithUploadedFilesModel.fromJson(
                  decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> setFavDoc({required int doctor, int isFav = 0}) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/fav-doctor-create');
      final request = http.Request("POST", uri);
      // header data for api
      _logger.d("accessToken: ${UserData.accessToken}");
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = "Bearer ${UserData.accessToken}";

      request.body =
          json.encode({"doctor_person_no_fk": doctor, "is_fav": isFav});

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(id: ResponseCode.SUCCESSFUL, object: Object());
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> getIssueList() async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/issue-list');
      final request = http.Request("GET", uri);
      // header data for api
      _logger.d("accessToken: ${UserData.accessToken}");
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = "Bearer ${UserData.accessToken}";

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          _logger.v('status: ${decodedJson['success']}');
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: IssueResponseModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> getSlotList(
      {required int doctor,
      int? chamber,
      required String date,
      required String type}) async {
    try {
      Uri uri = Uri.parse(BASE_URL + '/api/doctors/$doctor/schedule');
      final request = http.Request("POST", uri);
      // header data for api
      _logger.d("accessToken: ${UserData.accessToken}");
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = "Bearer ${UserData.accessToken}";

      request.body = json.encode({
        "appointment_date": date.split(" ").first,
        "type": type,
        "chamber": chamber
      });

      _logger.v('body: ${request.body}');

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: SlotResponseModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }

  Future<ResponseObject> getSlotSummery(
      {required int doctor, required String type}) async {
    try {
      Uri uri =
          Uri.parse(BASE_URL + '/api/doctor-slot-summary/$doctor?type=$type');
      final request = http.Request("GET", uri);
      // header data for api
      _logger.d("accessToken: ${UserData.accessToken}");
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = "Bearer ${UserData.accessToken}";

      _logger.v('url: $uri');

      final _response = await request.send();
      final responseData =
          await _response.stream.transform(utf8.decoder).join();
      final decodedJson = json.decode(responseData);
      _logger.v(decodedJson);
      if (_response.statusCode == 200 || _response.statusCode == 201) {
        if (decodedJson['success'] == true) {
          return ResponseObject(
              id: ResponseCode.SUCCESSFUL,
              object: SlotSummeryResponseModel.fromJson(decodedJson));
        } else {
          return ResponseObject(
              id: ResponseCode.FAILED,
              object: ErrorResponse.fromJson(decodedJson));
        }
      } else {
        return ResponseObject(
            id: ResponseCode.FAILED,
            object: ErrorResponse.fromJson(decodedJson));
      }
    } catch (e) {
      _logger.d(e.toString());
      return ResponseObject(id: ResponseCode.FAILED, object: ErrorResponse());
    }
  }
}
