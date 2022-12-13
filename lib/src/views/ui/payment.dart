import 'dart:async';

import 'package:dpr_patient/src/business_logics/providers/patient_info_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/services/firebase_services/db_service.dart';
import 'package:dpr_patient/src/views/ui/confirm_appointment.dart';
import 'package:dpr_patient/src/views/ui/telemedicine_confirm_appointment.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Payment extends StatelessWidget {
  final String totalFee;
  const Payment({Key? key, required this.totalFee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: const Text("Select Payment Method", style: kAppBarBlueTitleTextStyle),
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16),
                  color: kLightGreyColor,
                  width: double.infinity,
                  child: const Text("Recommended Method(s)",
                      style: kTitleTextStyle)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Image(image: AssetImage('assets/images/icon_card.png')),
                        SizedBox(width: 8.0),
                        Text("Credit/Debit Card", style: kTitleTextStyle)
                      ],
                    ),
                    Row(
                      children: const [
                        Image(image: AssetImage('assets/images/icon_visa.png')),
                        SizedBox(width: 4.0),
                        Image(
                            image: AssetImage(
                                'assets/images/icon_master_card.png')),
                      ],
                    ),
                    IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded,
                            color: kDeepBlueColor, size: 32.0),
                        onPressed: () {})
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16),
                  color: kLightGreyColor,
                  width: double.infinity,
                  child: const Text("Other saved method(s)",
                      style: kTitleTextStyle)),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Image(
                            image: AssetImage('assets/images/icon_bkash.png')),
                        SizedBox(width: 8.0),
                        Text("018******254", style: kTitleTextStyle)
                      ],
                    ),
                    Radio(value: true, groupValue: true, onChanged: (value) {})
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16),
                  color: kLightGreyColor,
                  width: double.infinity,
                  child:
                      const Text("Payment method(s)", style: kTitleTextStyle)),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Image(
                            image: AssetImage('assets/images/icon_nagad.png')),
                        SizedBox(width: 8.0),
                        Text("Save Nagad Account", style: kTitleTextStyle)
                      ],
                    ),
                    IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded,
                            color: kDeepBlueColor, size: 32.0),
                        onPressed: () {})
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Image(image: AssetImage('assets/images/icon_cash.png')),
                        SizedBox(width: 8.0),
                        Text("Pay on Visit", style: kTitleTextStyle)
                      ],
                    ),
                    Radio(value: true, groupValue: true, onChanged: (value) {}),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              const Divider(
                thickness: 2.0,
                color: kLightGreyColor,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Fee:", style: kTitleTextStyle),
                    Text("$totalFee TK",
                        style: const TextStyle(
                            color: kOrangeColor, fontWeight: FontWeight.w600))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: WidgetFactory.buildButton(
                    context: context,
                    child: const Text("Confirm Appointment",style: kButtonTextStyle),
                    backgroundColor: kMediumBlueColor,
                    borderRadius: 8,
                    onPressed: () async {
                      final patientInfoProvider = Provider.of<PatientInfoProvider>(context, listen: false);
                      if(PatientInfoProvider.doctorAppointmentInputModel.isTelemed == false) {
                        LogDebugger.instance.e(PatientInfoProvider.doctorAppointmentInputModel.toJson());
                        final _responseResult = await patientInfoProvider.setAppointmentWithUpload(
                            date: PatientInfoProvider
                                    .doctorAppointmentInputModel.appointDate ??
                                '',
                            chamberFkNo: PatientInfoProvider
                                .doctorAppointmentInputModel.chamber,
                            doctorFkNo: PatientInfoProvider
                                    .doctorAppointmentInputModel.doctorNoFk ??
                                0,
                            phoneMobile: PatientInfoProvider
                                    .doctorAppointmentInputModel.phoneMobile ??
                                '',
                            patientFkNo: PatientInfoProvider
                                    .doctorAppointmentInputModel.patientNoFk ??
                                0,
                            reportShow: PatientInfoProvider
                                    .doctorAppointmentInputModel.reportShow ??
                                false,
                            issue: PatientInfoProvider
                                .doctorAppointmentInputModel.issueNoFk,
                            slot: PatientInfoProvider.doctorAppointmentInputModel.slotNoPk,
                            chiefComplain: PatientInfoProvider.doctorAppointmentInputModel.chiefComplain,
                            isTelemed: PatientInfoProvider.doctorAppointmentInputModel.isTelemed ?? false,
                            images: PatientInfoProvider.doctorAppointmentInputModel.uploadImages,
                            docList: PatientInfoProvider.doctorAppointmentInputModel.docList);
                        if (_responseResult) {
                          _modalAboutApp(context);
                          startTimeout(context, 3000, patientInfoProvider, PatientInfoProvider.doctorAppointmentInputModel.isTelemed ?? false);

                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                patientInfoProvider.errorResponse.message ??
                                    "Network error"),
                            duration: const Duration(seconds: 1),
                          ));
                        }
                      } else {
                        final _responseResult = await patientInfoProvider
                            .setAppointmentWithUpload(
                            date: PatientInfoProvider.doctorAppointmentInputModel.appointDate ?? '',
                            doctorFkNo: PatientInfoProvider.doctorAppointmentInputModel.doctorNoFk ?? 0,
                            phoneMobile: PatientInfoProvider.doctorAppointmentInputModel.phoneMobile ?? '',
                            patientFkNo: PatientInfoProvider.doctorAppointmentInputModel.patientNoFk ?? 0,
                            reportShow: PatientInfoProvider.doctorAppointmentInputModel.reportShow ?? false,
                            issue: PatientInfoProvider.doctorAppointmentInputModel.issueNoFk,
                            slot: PatientInfoProvider.doctorAppointmentInputModel.slotNoPk,
                            chiefComplain: PatientInfoProvider.doctorAppointmentInputModel.chiefComplain,
                            isTelemed: PatientInfoProvider.doctorAppointmentInputModel.isTelemed ?? true,
                            images: PatientInfoProvider.doctorAppointmentInputModel.uploadImages,
                            docList: PatientInfoProvider.doctorAppointmentInputModel.docList
                        );
                        if (_responseResult) {
                          ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                          String chatRoomID = 'DOC${PatientInfoProvider.doctorAppointmentInputModel.doctorNoFk}_PAT${PatientInfoProvider.doctorAppointmentInputModel.patientNoFk}';
                          DBService.createChatRoom(chatRoomID,
                              {
                                'doc_id': PatientInfoProvider.doctorAppointmentInputModel.doctorNoFk,
                                'doc_name': PatientInfoProvider.doctorAppointmentInputModel.doctorName,
                                'doc_image': PatientInfoProvider.doctorAppointmentInputModel.doctorImage,
                                'pat_id': PatientInfoProvider.doctorAppointmentInputModel.patientNoFk,
                                'pat_name': PatientInfoProvider.doctorAppointmentInputModel.patientName,
                                'pat_image': profileProvider.profileModel?.data?.profile?.image,
                                'room_id': 'DOC${PatientInfoProvider.doctorAppointmentInputModel.doctorNoFk}_PAT${PatientInfoProvider.doctorAppointmentInputModel.patientNoFk}',
                                'user_list': [
                                  PatientInfoProvider.doctorAppointmentInputModel.doctorNoFk,
                                  PatientInfoProvider.doctorAppointmentInputModel.patientNoFk
                                ]
                              });
                          DBService.addAppointmentTiming(chatRoomID, {
                            'appointment_id': patientInfoProvider.appointmentConfirmationWithUploadedFilesModel?.data?.appointment?.appointNoPk,
                            'start_time': DateFormat('yyyy-MM-dd hh:mm a').parse('${PatientInfoProvider.doctorAppointmentInputModel.appointDate?.split(' ').first} ${PatientInfoProvider.doctorAppointmentInputModel.slotTxt?.split(' - ').first}'),
                            'end_time': DateFormat('yyyy-MM-dd hh:mm a').parse('${PatientInfoProvider.doctorAppointmentInputModel.appointDate?.split(' ').first} ${PatientInfoProvider.doctorAppointmentInputModel.slotTxt?.split(' - ').last}'),
                          });
                          DBService.addConversationMsgs(chatRoomID, {
                            "message": 'Gender: ${PatientInfoProvider.doctorAppointmentInputModel.patientGender}\nAge: ${PatientInfoProvider.doctorAppointmentInputModel.patientAge}\nHeight: ${profileProvider.profileModel?.data?.profile?.height?.replaceAll('.', '\'')}\nWeight: ${profileProvider.profileModel?.data?.profile?.weight}\nMarried: ${profileProvider.profileModel?.data?.profile?.maritalStatus == 'Married' ? 'Yes' : 'No'}\nIssue: ${PatientInfoProvider.doctorAppointmentInputModel.issueTxt}',
                            "sentby": PatientInfoProvider.doctorAppointmentInputModel.patientNoFk,
                            "type": 'pat_details',
                            "time": DateTime.now()
                          });
                          if(PatientInfoProvider.doctorAppointmentInputModel.chiefComplain != null && PatientInfoProvider.doctorAppointmentInputModel.chiefComplain != '') {
                            DBService.addConversationMsgs(chatRoomID, {
                            "message": 'Details:\n${PatientInfoProvider.doctorAppointmentInputModel.chiefComplain}',
                            "sentby": PatientInfoProvider.doctorAppointmentInputModel.patientNoFk,
                            "type": 'pat_details',
                            "time": DateTime.now()
                          });
                          }
                          if((patientInfoProvider.appointmentConfirmationWithUploadedFilesModel?.data?.appointment?.filePath?.length ?? 0) > 0) {
                            patientInfoProvider.appointmentConfirmationWithUploadedFilesModel?.data?.appointment?.filePath?.forEach((element) {
                              if(element != null) {
                                DBService.addConversationMsgs(chatRoomID, {
                                "message": element,
                                "sentby": PatientInfoProvider.doctorAppointmentInputModel.patientNoFk,
                                "type": 'upload_images',
                                "time": DateTime.now()
                              });
                              }
                            });
                          }
                          if((patientInfoProvider.appointmentConfirmationWithUploadedFilesModel?.data?.appointment?.selectedImage?.length ?? 0) > 0) {
                            patientInfoProvider.appointmentConfirmationWithUploadedFilesModel?.data?.appointment?.selectedImage?.forEach((element) {
                              if(element != null) {
                                DBService.addConversationMsgs(chatRoomID, {
                                "message": element,
                                "sentby": PatientInfoProvider.doctorAppointmentInputModel.patientNoFk,
                                "type": 'upload_images',
                                "time": DateTime.now()
                              });
                              }
                            });
                          }
                          String appointDate = PatientInfoProvider.doctorAppointmentInputModel.appointDate?.split(' ').first ?? '';
                          DateTime date = DateFormat('yyyy-MM-dd').parse(appointDate);
                          String dateStr = DateFormat('dd-MM-yyyy').format(date);
                          DBService.addConversationMsgs(chatRoomID, {
                            "message": 'Thank you for your appointment. See you on ${dateStr} ${PatientInfoProvider.doctorAppointmentInputModel.slotTxt?.split(' - ').first}.',
                            "sentby": PatientInfoProvider.doctorAppointmentInputModel.doctorNoFk,
                            "type": 'message',
                            "time": DateTime.now()
                          });
                          _modalAboutApp(context);
                          startTimeout(context, 3000, patientInfoProvider, PatientInfoProvider.doctorAppointmentInputModel.isTelemed ?? true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    patientInfoProvider.errorResponse
                                        .message ?? "Network error"),
                                duration: const Duration(seconds: 1),
                              ));
                        }
                      }
                      // _modalAboutApp(context);
                      // startTimeout(context, 3000);
                      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Navigation(selectedIndex: 0)), (route) => false);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Timer startTimeout(BuildContext context, int? milliseconds, PatientInfoProvider patientInfoProvider, bool isTel) {
  var duration = milliseconds == null ? const Duration(seconds: 3) : const Duration(milliseconds: 1) * milliseconds;
  return Timer(duration, () => handleTimeout(context, patientInfoProvider, isTel));
}

void handleTimeout(BuildContext context, PatientInfoProvider patientInfoProvider, bool isTel) {// callback function
  if(isTel) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TelemedicineConfirmAppointment(
                    provider:
                    patientInfoProvider, isRecent: false,)), (route) => false);
  }
  else {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ConfirmAppointment(provider: patientInfoProvider, isRecent: false,)), (route) => false);
  }
  // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Navigation(selectedIndex: 0)), (route) => false);
}

void _modalAboutApp(context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
          content: SizedBox(
                height: 200,
                width: 150,
                child: Column(
                  children: [
                    const SizedBox(height: 24,),
                    Image.asset("assets/images/success.jpg",height: 100,width: 100,),
                    const SizedBox(height: 34,),
                    const Center(child: Text("Payment Success"))
                  ],
                ),
              )
            ,

        );
      });
}

