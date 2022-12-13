import 'dart:io';

import 'package:dpr_patient/src/business_logics/models/api_response_object.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/services/api_services/address_api_services.dart';
import 'package:dpr_patient/src/services/api_services/appointment_api_services.dart';
import 'package:dpr_patient/src/services/api_services/auth_api_services.dart';

import 'package:dpr_patient/src/services/api_services/document_api_services.dart';

import 'package:dpr_patient/src/services/api_services/favorite_api_services.dart';

import 'package:dpr_patient/src/services/api_services/home_api_services.dart';
import 'package:dpr_patient/src/services/api_services/in_person_visit_api_services.dart';
import 'package:dpr_patient/src/services/api_services/medication_plan_api_services.dart';
import 'package:dpr_patient/src/services/api_services/profile_api_services.dart';

final repository = _Repository();

class _Repository {
  final AuthAPIServices _authAPIServices = AuthAPIServices();
  final HomeAPIServices _homeAPIServices = HomeAPIServices();
  final AddressAPIServices _addressAPIServices = AddressAPIServices();
  final InPersonVistiAPIServices _inPersonVisitAPIServices = InPersonVistiAPIServices();
  final ProfileAPIServices _profileAPIServices = ProfileAPIServices();
  final DocumentAPIServices _documentAPIServices = DocumentAPIServices();
  final FavouriteAPIServices _favouriteAPIServices = FavouriteAPIServices();
  final MedicationPlanAPIServices _medicationPlanAPIServices = MedicationPlanAPIServices();
  final AppointmenyApiServices _appointmenyApiServices = AppointmenyApiServices();

  Future<ResponseObject> signUp(String firstName, String lastName, String phone, String password) =>
      _authAPIServices.signUp(firstName, lastName, phone, password);

  Future<ResponseObject> signupVerifyOTP(String phone, String otp) =>
      _authAPIServices.signupVerifyOtp(phone, otp);

  Future<ResponseObject> login(String phone, String password) =>
      _authAPIServices.login(phone, password);

  Future<ResponseObject> requestCode(String phone) =>
      _authAPIServices.requestCode(phone);

  Future<ResponseObject> verifyOTP(String phone, String otp) =>
      _authAPIServices.verifyOTP(phone, otp);

  Future<ResponseObject> resetPassword(String password) =>
      _authAPIServices.resetPassword(password);

  Future<ResponseObject> getNearbyDoctor(double lat, double lon) =>
      _homeAPIServices.getNearbyDoctor(lat, lon);

  Future<ResponseObject> getOnlineDoctor() =>
      _homeAPIServices.getOnlineDoctor();

  Future<ResponseObject> getAddresses() =>
      _addressAPIServices.getAddresses();

  Future<ResponseObject> addAddress(String name, String area, String address) =>
      _addressAPIServices.addAddress(name, area, address);

  Future<ResponseObject> updateAddress(int id, String name, String area, String address) =>
      _addressAPIServices.updateAddress(id, name, area, address);

  Future<ResponseObject> getProfile() =>
      _profileAPIServices.getProfile();

  Future<ResponseObject> getSubProfile(int id) =>
      _profileAPIServices.getSubProfile(id);

  Future<ResponseObject> deleteSubProfile(int id) =>
      _profileAPIServices.deleteSubProfile(id);

  Future<ResponseObject> getSubProfileList() =>
      _profileAPIServices.getSubProfileList();

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
      required String relation
    }) {
    LogDebugger.instance.d('pro image: $patientImage');
    return _profileAPIServices.updateProfile(
        id: id,
        patientImage: patientImage,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        dob: dob,
        gender: gender,
        maritalStatus: maritalStatus,
        heightFoot: heightFoot,
        heightInch: heightInch,
        weight: weight,
        bloodGroup: bloodGroup,
        bloodDonor: bloodDonor,
        address: address,
        diabetesInd: diabetesInd,
        htnInd: htnInd,
        asthmaInd: asthmaInd,
        relation: relation

    );
  }

  Future<ResponseObject> deleteProfilePic(int id) =>
      _profileAPIServices.deleteProfilePic(id);

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
    required String relation
  }) =>
      _profileAPIServices.addSubProfile(
        patientImage: patientImage,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          dob: dob,
          gender: gender,
          maritalStatus: maritalStatus,
          heightFoot: heightFoot,
          heightInch: heightInch,
          weight: weight,
          bloodGroup: bloodGroup,
          bloodDonor: bloodDonor,
          address: address,
          diabetesInd: diabetesInd,
          htnInd: htnInd,
          asthmaInd: asthmaInd,
          relation: relation
      );

  Future<ResponseObject> getInPersonVisitDoctorList({required String type}) =>
      _inPersonVisitAPIServices.getInPersonVisitDoctorList(type: type);

  Future<ResponseObject> getInPersonVisitDoctorSearch(String key, {bool isTelemedicine = false}) =>
      _inPersonVisitAPIServices.getInPersonVisitDoctorSearch(key, isTelemedicine: isTelemedicine);

  Future<ResponseObject> getDoctorDetails({required int id, required String type}) =>
      _inPersonVisitAPIServices.getDoctorDetails(id: id, type: type);

  Future<ResponseObject> getDoctorChambers(int id) =>
      _inPersonVisitAPIServices.getDoctorChambers(id);

  Future<ResponseObject> getPatientList() =>
      _inPersonVisitAPIServices.getPatientList();

  Future<ResponseObject> getIssueList() =>
      _inPersonVisitAPIServices.getIssueList();

  Future<ResponseObject> getSlotList({required int doctor, int? chamber, required String date, required String type}) =>
      _inPersonVisitAPIServices.getSlotList(doctor: doctor, chamber: chamber, date: date, type: type);

  Future<ResponseObject> getSlotSummery({required int doctor, required String type}) =>
      _inPersonVisitAPIServices.getSlotSummery(doctor: doctor, type: type);

  Future<ResponseObject> setFavDoc({required int doctor, int isFav = 0}) =>
      _inPersonVisitAPIServices.setFavDoc(doctor: doctor, isFav: isFav);

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
          required bool isTelemed}) =>
      _inPersonVisitAPIServices.setAppointment(
          date: date,
          patientFkNo: patientFkNo,
          doctorFkNo: doctorFkNo,
          phoneMobile: phoneMobile,
          reportShow: reportShow,
          chamberFkNo: chamberFkNo,
          slot: slot,
          issue: issue,
          chiefComplain: chiefComplain,
          isTelemed: isTelemed);

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
          required List<int>? docList}) =>
      _inPersonVisitAPIServices.setAppointmentWithUpload(
          date: date,
          patientFkNo: patientFkNo,
          doctorFkNo: doctorFkNo,
          phoneMobile: phoneMobile,
          reportShow: reportShow,
          chamberFkNo: chamberFkNo,
          slot: slot,
          issue: issue,
          chiefComplain: chiefComplain,
          isTelemed: isTelemed,
          images: images,
          docList: docList);

  Future<ResponseObject> getDocumentList() =>
      _documentAPIServices.getDocumentList();

  Future<ResponseObject> upload(String description, String date, File? file) =>
      _documentAPIServices.upload(description, date, file);

  Future<ResponseObject> getFavDocList() =>
      _favouriteAPIServices.getFavDocList();

  Future<ResponseObject> getFavMedList() =>
      _favouriteAPIServices.getFavMedList();

  Future<ResponseObject> getMedicationTypes() =>
      _medicationPlanAPIServices.getMedicationTypes();

  Future<ResponseObject> getMedicationPlans() =>
      _medicationPlanAPIServices.getMedicationPlans();

  Future<ResponseObject> addMedicationPlan(String medicineType, String medicineName, String note, var days, var times) =>
      _medicationPlanAPIServices.addMedicationPlan(medicineType, medicineName, note, days, times);

  Future<ResponseObject> getPrescription({required int id}) =>
      _profileAPIServices.getPrescription(id: id);

  Future<ResponseObject> getRecentAppointmentDetails(int id) =>
      _appointmenyApiServices.getRecentAppointmentDetails(id);
}