import 'package:dpr_patient/src/business_logics/providers/patient_info_provider.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';

class TelemedicineRecentAppointmentDetails extends StatefulWidget {
  final PatientInfoProvider provider;
  const TelemedicineRecentAppointmentDetails({Key? key, required this.provider}) : super(key: key);

  @override
  State<TelemedicineRecentAppointmentDetails> createState() => _TelemedicineRecentAppointmentDetailsState();
}

class _TelemedicineRecentAppointmentDetailsState extends State<TelemedicineRecentAppointmentDetails> {
  final TextEditingController _couponETController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PatientInfoProvider provider = widget.provider;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: const Text("Appointment Details", style: kAppBarGreenTitleTextStyle),
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
                    name: provider.appointmentConfirmationModel?.data?.doctorName ?? "",
                    expertise: provider.appointmentConfirmationModel?.data?.specialtyString ?? "",
                    degree: provider.appointmentConfirmationModel?.data?.qualificationString ?? "",
                    image: provider.appointmentConfirmationModel?.data?.doctorPhoto ?? "",
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
                  child: Text(provider.appointmentConfirmationModel?.data?.patientName ?? "", style: kSubTitleTextStyle),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: Text("Age: ${provider.appointmentConfirmationModel?.data?.age ?? ""}, ${provider.appointmentConfirmationModel?.data?.gender ?? ""}", style: kSubTitleTextStyle),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, bottom: 4.0),
                  child: Text("Issue", style: kTitleTextStyle),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                  child: Text("${provider.appointmentConfirmationModel?.data?.issueName} ${provider.appointmentConfirmationModel?.data?.chiefComplain != null && provider.appointmentConfirmationModel?.data?.chiefComplain != '' ? '(${provider.appointmentConfirmationModel?.data?.chiefComplain})' : ''}", style: kSubTitleTextStyle),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text("Serial", style: kTitleTextStyle),
                                    Text(":", style: kTitleTextStyle)
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(provider.appointmentConfirmationModel?.data?.serial.toString() ?? "",
                                    style: const TextStyle(
                                        color: kOrangeColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
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
                                    Text("Date", style: kTitleTextStyle),
                                    Text(":", style: kTitleTextStyle)
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(provider.appointmentConfirmationModel?.data?.appointDate != null
                                    ? (provider.appointmentConfirmationModel?.data?.appointDate?.split(" ").first ?? "N\\A")
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
                                child: Text(provider.appointmentConfirmationModel?.data?.startTime != null
                                    ? (provider.appointmentConfirmationModel?.data?.startTime ?? "N\\A")
                                    : "N\\A",
                                    style: kTitleTextStyle,
                                    textAlign: TextAlign.end),
                              )
                            ],
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Row(
                          //   children: [
                          //     const Icon(Icons.place, color: kDeepBlueColor),
                          //     const SizedBox(width: 4),
                          //     Text(provider.appointmentConfirmationModel?.data?.chamberHospitalName ?? "N/A",
                          //         style: kLargerBlueTextStyle),
                          //   ],
                          // ),
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
                if(provider.appointmentConfirmationModel?.data?.teleReportFeeInd == 0)
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
                            child: Text("${provider.appointmentConfirmationModel?.data?.doctorTeleFee ?? 0} Tk",
                                style: kTitleTextStyle, textAlign: TextAlign.end))
                      ],
                    ),
                  ),
                if(provider.appointmentConfirmationModel?.data?.teleReportFeeInd == 1)
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
                            child: Text("${provider.appointmentConfirmationModel?.data?.teleReportFee ?? 0} Tk",
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
                                          text: " ${int.parse(provider.appointmentConfirmationModel?.data?.teleReportFeeInd == 0 ? (provider.appointmentConfirmationModel?.data?.doctorTeleFee ?? '0') : (provider.appointmentConfirmationModel?.data?.teleReportFee ?? '0')) + 10} Tk",
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
            userName: name ?? "",
            imageType: image == null ? ImageType.Asset : ImageType.Network,
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
