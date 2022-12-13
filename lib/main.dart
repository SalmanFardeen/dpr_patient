import 'package:dpr_patient/src/app.dart';
import 'package:dpr_patient/src/business_logics/providers/address_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/doctor_details_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/document_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/favourite_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/forgot_password_otp_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/forgot_password_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/in_person_visit_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/login_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/medication_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/nearby_doctor_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/patient_info_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/reset_password_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/signup_otp_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/signup_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/telemedicine_doctor_provider.dart';
import 'package:dpr_patient/src/services/notification_services/awesome_local_notification_service.dart';
import 'package:dpr_patient/src/services/notification_services/local_notification_service.dart';
import 'package:dpr_patient/src/services/notification_services/push_notification_services.dart';
import 'package:dpr_patient/src/services/shared_preference_services/shared_prefs_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  final List<ChangeNotifierProvider> providerList = [
    ChangeNotifierProvider<SignupProvider>(create: (_) => SignupProvider()),
    ChangeNotifierProvider<SignupOtpProvider>(
        create: (_) => SignupOtpProvider()),
    ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
    ChangeNotifierProvider<ForgotPasswordProvider>(
        create: (_) => ForgotPasswordProvider()),
    ChangeNotifierProvider<ForgotPasswordOtpProvider>(
        create: (_) => ForgotPasswordOtpProvider()),
    ChangeNotifierProvider<ResetPasswordProvider>(
        create: (_) => ResetPasswordProvider()),
    ChangeNotifierProvider<NearbyDoctorProvider>(
        create: (_) => NearbyDoctorProvider()),
    ChangeNotifierProvider<TelemedicineDoctorProvider>(
        create: (_) => TelemedicineDoctorProvider()),
    ChangeNotifierProvider<AddressProvider>(create: (_) => AddressProvider()),
    ChangeNotifierProvider<InPersonVisitProvider>(
        create: (_) => InPersonVisitProvider()),
    ChangeNotifierProvider<ProfileProvider>(
        create: (_) => ProfileProvider()),
    ChangeNotifierProvider<DoctorDetailsProvider>(
        create: (_) => DoctorDetailsProvider()),
    ChangeNotifierProvider<PatientInfoProvider>(
        create: (_) => PatientInfoProvider()),
    ChangeNotifierProvider<DocumentProvider>(
        create: (_) => DocumentProvider()),
    ChangeNotifierProvider<FavouriteProvider>(
        create: (_) => FavouriteProvider()),
    ChangeNotifierProvider<MedicationProvider>(
        create: (_) => MedicationProvider()),
  ];

  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsServices.init();
  await Firebase.initializeApp();
  PushNotificationServices.setUpFirebase();
  LocalNotificationService().init();
  AwesomeNotificationService().init();
  // FirebaseMessaging.onBackgroundMessage((message) async {
  //   if (message.notification?.title == 'Incoming Call') {
  //     Map<String, String> map = message.data['image'] != null
  //         ? {
  //       "room_id": message.data['room_id'],
  //       "image": message.data['image'],
  //       "name": message.data['name'],
  //       "other_id": message.data['other_id'],
  //       "is_video": message.data['is_video']
  //     }
  //         : {
  //       "room_id": message.data['room_id'],
  //       "name": message.data['name'],
  //       "other_id": message.data['other_id'],
  //       "is_video": message.data['is_video']
  //     };
  //     AwesomeNotificationService().showNotification(
  //         message.notification?.title ?? '',
  //         message.notification?.body ?? '',
  //         map);
  //   }
  // });
  runApp(MultiProvider(
    providers: providerList,
    child: const MyApp(),
  ));
}
