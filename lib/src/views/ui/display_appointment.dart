import 'package:dpr_patient/src/business_logics/providers/patient_info_provider.dart';
import 'package:dpr_patient/src/views/ui/payment.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';

class DisplayAppointment extends StatefulWidget {
  const DisplayAppointment({Key? key}) : super(key: key);

  @override
  _DisplayAppointmentState createState() => _DisplayAppointmentState();
}

class _DisplayAppointmentState extends State<DisplayAppointment> {
  final TextEditingController _couponETController = TextEditingController();
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
        title: const Text("Confirm Appointment", style: kAppBarBlueTitleTextStyle),
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HeaderInfo(
                    name: PatientInfoProvider.doctorAppointmentInputModel.doctorName,
                    expertise: PatientInfoProvider.doctorAppointmentInputModel.expertise ?? '',
                    degree: PatientInfoProvider.doctorAppointmentInputModel.degree ?? '',
                    image: PatientInfoProvider.doctorAppointmentInputModel.doctorImage,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                  height: .05,
                  color: Colors.grey.shade400,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 4.0),
                  child: Text("Patient Name", style: kTitleTextStyle),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                  child: Text(PatientInfoProvider.doctorAppointmentInputModel.patientName ?? "", style: kSubTitleTextStyle),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: Text("Age: ${PatientInfoProvider.doctorAppointmentInputModel.patientAge ?? ""}, ${PatientInfoProvider.doctorAppointmentInputModel.patientGender ?? ""}", style: kSubTitleTextStyle),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, bottom: 4.0),
                  child: Text("Issue", style: kTitleTextStyle),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                  child: Text("${PatientInfoProvider.doctorAppointmentInputModel.issueTxt} ${PatientInfoProvider.doctorAppointmentInputModel.chiefComplain != '' && PatientInfoProvider.doctorAppointmentInputModel.chiefComplain != null ? '(${PatientInfoProvider.doctorAppointmentInputModel.chiefComplain})' : ''}", style: kSubTitleTextStyle),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ShadowContainer(
                    radius: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("Date", style: kTitleTextStyle),
                                    Text(":", style: kTitleTextStyle)
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(PatientInfoProvider.doctorAppointmentInputModel.appointDate != null
                                    ? (PatientInfoProvider.doctorAppointmentInputModel.appointDate?.split(' ').first ?? 'N\\A')
                                    : "N\\A",
                                    style: kTitleTextStyle,
                                    textAlign: TextAlign.end),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text("Time", style: kTitleTextStyle),
                                    Text(":", style: kTitleTextStyle)
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(PatientInfoProvider.doctorAppointmentInputModel.slotTxt?.split(' - ').first != null
                                    ? (PatientInfoProvider.doctorAppointmentInputModel.slotTxt?.split(' - ').first ?? "N\\A")
                                    : "N\\A",
                                    style: kTitleTextStyle,
                                    textAlign: TextAlign.end),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.place, color: kDeepBlueColor),
                              const SizedBox(width: 4),
                              Text(PatientInfoProvider.doctorAppointmentInputModel.chamberHospitalName ?? "N/A",
                                  style: kLargerBlueTextStyle),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Divider(
                  thickness: 1,
                  height: .05,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                // Fee Details ................................................
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: Text("Fee Details", style: kTitleTextStyle),
                ),
                if(PatientInfoProvider.doctorAppointmentInputModel.reportShow == false)
                Padding(
                  padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Consultation Fee", style: kTitleTextStyle),
                            Text(":", style: kTitleTextStyle)
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Text("${PatientInfoProvider.doctorAppointmentInputModel.doctorFee ?? 0} Tk",
                              style: kTitleTextStyle, textAlign: TextAlign.end))
                    ],
                  ),
                ),
                if(PatientInfoProvider.doctorAppointmentInputModel.reportShow == true)
                Padding(
                  padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Report Fee", style: kTitleTextStyle),
                            Text(":", style: kTitleTextStyle)
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Text("${PatientInfoProvider.doctorAppointmentInputModel.reportFee ?? 0} Tk",
                              style: kTitleTextStyle, textAlign: TextAlign.end))
                    ],
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Services Charge", style: kTitleTextStyle),
                            Text(":", style: kTitleTextStyle),
                          ],
                        ),
                      ),
                      const Expanded(
                          flex: 1,
                          child: Text("10 Tk",
                              style: kTitleTextStyle, textAlign: TextAlign.end)),
                    ],
                  ),
                ),
                // Coupon....................................
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextField(
                          controller: _couponETController,
                          decoration: InputDecoration(
                              hintText: "Enter Coupon",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                  const BorderSide(color: kMediumBlueColor))),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        flex: 3,
                        child: MaterialButton(
                            color: const Color.fromRGBO(223, 229, 239, 1.0),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 16.0),
                                child: Text(
                                  "Apply",
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            onPressed: () {}),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Divider(
                  thickness: 1,
                  height: .05,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
//  Totals...................................................
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: "Total Fee:",
                                    style: kTitleTextStyle,
                                    children: [
                                      TextSpan(
                                          text: " ${int.parse(PatientInfoProvider.doctorAppointmentInputModel.reportShow == false ? (PatientInfoProvider.doctorAppointmentInputModel.doctorFee ?? '0') : (PatientInfoProvider.doctorAppointmentInputModel.reportFee ?? '0')) + 10} Tk",
                                          style: const TextStyle(
                                            color: kOrangeColor,
                                          ))
                                    ]),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 4.0),
                                child: Text("VAT,included where applicable ",
                                    style: kSubTitleTextStyle),
                              ),
                            ],
                          )),
                      Expanded(
                        flex: 1,
                        child: WidgetFactory.buildButton(
                            context: context,
                            child: const Text(
                              "Proceed to Pay",
                              style: kButtonTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: kMediumBlueColor,
                            borderRadius: 5,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Payment(
                                  totalFee: (int.parse(PatientInfoProvider.doctorAppointmentInputModel.reportShow == false ? (PatientInfoProvider.doctorAppointmentInputModel.doctorFee ?? '0') : (PatientInfoProvider.doctorAppointmentInputModel.reportFee ?? '0')) + 10).toString()
                              )));
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class HeaderInfo extends StatelessWidget {
  final String? name;
  final String expertise;
  final String degree;
  final String? image;

  const HeaderInfo({
    Key? key,
    required this.name,
    required this.expertise,
    required this.degree,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        WidgetFactory.buildProfileAvatar(
            context: context,
            url: image ?? "assets/images/person.png",
            userName: name ?? "User",
            imageType: image == null || image == '' ? ImageType.Asset : ImageType.Network,
            radius: 80
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? "",
                style: kLargerTextStyle,
              ),
              const SizedBox(height: 4.0),
              Text(
                expertise,
                style: kTitleTextStyle,
              ),
              const SizedBox(height: 4.0),
              Text(
                degree,
                style: kTitleTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
