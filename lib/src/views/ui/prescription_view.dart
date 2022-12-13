import 'package:barcode_widget/barcode_widget.dart';
import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PrescriptionView extends StatefulWidget {
  final int id;
  const PrescriptionView({Key? key, required this.id}) : super(key: key);

  @override
  State<PrescriptionView> createState() => _PrescriptionViewState();
}

class _PrescriptionViewState extends State<PrescriptionView> {
  String appointmentDate = '', followUpDate = '', fDString = '';
  int followUpDays = 0;

  @override
  void initState() {
    super.initState();

    ProfileProvider prescriptionProvider = Provider.of<ProfileProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await prescriptionProvider.getPrescription(id: widget.id).then((value) {
        if (value) {
          appointmentDate = prescriptionProvider.prescriptionViewResponseModel
              ?.data?.prescriptionDetails?.appointDate ??
              '';
          followUpDays = prescriptionProvider.prescriptionViewResponseModel
              ?.data?.prescriptionDetails?.nextAppointmentDay ??
              0;
          if(followUpDays == 1) {
            fDString = 'After 1 day';
          } else if(followUpDays == 30) {
            fDString = 'After 1 months';
          } else if(followUpDays > 30) {
            double month = followUpDays/30;
            fDString = 'After ${month.round()} months';
          } else {
            fDString = 'After $followUpDays days';
          }
          if (appointmentDate != '' || followUpDays != 0) {
            DateTime d1 = DateFormat('dd-MM-yyyy').parse(appointmentDate);
            DateTime d2 = d1.add(Duration(days: followUpDays));
            followUpDate = DateFormat('dd/MM/yyyy').format(d2);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ProfileProvider prescriptionProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: kWhiteColor,
        title: const Text("Prescription", style: kAppBarBlueTitleTextStyle),
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            child: prescriptionProvider.inProgress
            ? SizedBox(
              height: size.height / 1.5,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
            : Column(
              children: [
                Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                prescriptionProvider.prescriptionViewResponseModel?.data?.prescriptionDetails?.doctorName ?? "",
                                style: kLargerBlueTextStyle2,
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                prescriptionProvider.prescriptionViewResponseModel?.data?.prescriptionDetails?.specialtyString ?? '',
                                style: kSubTitleGreyText,
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                prescriptionProvider.prescriptionViewResponseModel?.data?.prescriptionDetails?.qualificationString ?? '',
                                style: kSubTitleGreyText,
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: kDeepBlueColor,
                                size: 14,
                              ),
                              Text(
                                prescriptionProvider.prescriptionViewResponseModel?.data?.prescriptionDetails?.chamberHospitalName ?? "",
                                style: kSubTitleTextStyle,
                              ),
                            ],
                          )
                        ],
                      )),
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/dpr_logo.png"))),
                              )),
                          const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "D P R",
                                style: kLargerBlueTextStyle,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Divider(
                  color: kDarkGreyColor,
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BarcodeWidget(
                                    width: size.width / 3,
                                    height: 30,
                                    drawText: false,
                                    data:
                                    '${prescriptionProvider.prescriptionViewResponseModel?.data?.prescriptionDetails?.appointNoFk}',
                                    barcode: Barcode.code128()),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text.rich(TextSpan(
                                    text: "Patient ID: ",
                                    style: kTitleTextStyle,
                                    children: [
                                      TextSpan(
                                        text:
                                        '${UserData.dprId}',
                                        style: kTitleTextStyle,
                                      )
                                    ])),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text.rich(TextSpan(
                                    text: "Name: ",
                                    style: kTitleTextStyle,
                                    children: [
                                      TextSpan(
                                        text:
                                        '${prescriptionProvider.prescriptionViewResponseModel?.data?.prescriptionDetails?.patientName}',
                                        style: kTitleTextStyle,
                                      )
                                    ])),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text.rich(TextSpan(
                                    text: "Age: ",
                                    style: kTitleTextStyle,
                                    children: [
                                      TextSpan(
                                        text:
                                        '${prescriptionProvider.prescriptionViewResponseModel?.data?.prescriptionDetails?.age}',
                                        style: kTitleTextStyle,
                                      )
                                    ])),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BarcodeWidget(
                                    width: size.width / 3,
                                    height: 30,
                                    drawText: false,
                                    data: widget.id.toString(),
                                    barcode: Barcode.code128()),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text.rich(TextSpan(
                                    text: "Prescription ID: ",
                                    style: kTitleTextStyle,
                                    children: [
                                      TextSpan(
                                        text:
                                        '${prescriptionProvider.prescriptionViewResponseModel?.data?.prescriptionDetails?.prescriptionNoPk}',
                                        style: kTitleTextStyle,
                                      )
                                    ])),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text.rich(TextSpan(
                                    text: "Prescription Date: ",
                                    style: kTitleTextStyle,
                                    children: [
                                      TextSpan(
                                        text:
                                        '${prescriptionProvider.prescriptionViewResponseModel?.data?.prescriptionDetails?.prescriptionDate}',
                                        style: kTitleTextStyle,
                                      )
                                    ])),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text.rich(TextSpan(
                                    text: "Gender: ",
                                    style: kTitleTextStyle,
                                    children: [
                                      TextSpan(
                                        text:
                                        '${prescriptionProvider.prescriptionViewResponseModel?.data?.prescriptionDetails?.genderName}',
                                        style: kTitleTextStyle,
                                      )
                                    ])),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: kDarkGreyColor,
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                                    if ((prescriptionProvider
                                                .prescriptionViewResponseModel
                                                ?.data
                                                ?.chiefComplaints
                                                ?.length ??
                                            0) >
                                        0) ...[
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Chief Complain:',
                                              style: kPrescriptionViewTitle,
                                            ),
                                            const Divider(
                                              color: kDeepBlueColor,
                                            ),
                                            ListView.separated(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: prescriptionProvider
                                                        .prescriptionViewResponseModel
                                                        ?.data
                                                        ?.chiefComplaints
                                                        ?.length ??
                                                    0,
                                                separatorBuilder: (_, __) =>
                                                    const SizedBox(height: 2.0),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Text(
                                                    prescriptionProvider
                                                            .prescriptionViewResponseModel
                                                            ?.data
                                                            ?.chiefComplaints?[
                                                                index]
                                                            .prescritionData ??
                                                        "",
                                                    style: kGraySubtitle,
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      )
                                    ],
                                    if ((prescriptionProvider
                                                .prescriptionViewResponseModel
                                                ?.data
                                                ?.examinationDetails
                                                ?.length ??
                                            0) >
                                        0) ...[
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Examination/Findings: ",
                                              style: kPrescriptionViewTitle,
                                            ),
                                            const Divider(
                                              color: kDeepBlueColor,
                                            ),
                                            ListView.separated(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: prescriptionProvider
                                                        .prescriptionViewResponseModel
                                                        ?.data
                                                        ?.examinationDetails
                                                        ?.length ??
                                                    0,
                                                separatorBuilder: (_, __) =>
                                                    const SizedBox(height: 2.0),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Text(
                                                    prescriptionProvider
                                                            .prescriptionViewResponseModel
                                                            ?.data
                                                            ?.examinationDetails?[
                                                                index]
                                                            .prescritionData ??
                                                        "",
                                                    style: kGraySubtitle,
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      )
                                    ],
                                    if ((prescriptionProvider
                                                .prescriptionViewResponseModel
                                                ?.data
                                                ?.investigationDetails
                                                ?.length ??
                                            0) >
                                        0) ...[
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Investigation: ",
                                              style: kPrescriptionViewTitle,
                                            ),
                                            const Divider(
                                              color: kDeepBlueColor,
                                            ),
                                            ListView.separated(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: prescriptionProvider
                                                        .prescriptionViewResponseModel
                                                        ?.data
                                                        ?.investigationDetails
                                                        ?.length ??
                                                    0,
                                                separatorBuilder: (_, __) =>
                                                    const SizedBox(height: 2.0),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Text(
                                                    prescriptionProvider
                                                            .prescriptionViewResponseModel
                                                            ?.data
                                                            ?.investigationDetails?[
                                                                index]
                                                            .prescritionData ??
                                                        "",
                                                    style: kGraySubtitle,
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      )
                                    ],
                                    if ((prescriptionProvider.prescriptionViewResponseModel?.data?.vitalsDetails?.length ?? 0) > 0 &&
                                            prescriptionProvider
                                                    .prescriptionViewResponseModel
                                                    ?.data
                                                    ?.vitalsDetails?[0]
                                                    .heightVal !=
                                                '0.0' ||
                                        prescriptionProvider
                                                .prescriptionViewResponseModel
                                                ?.data
                                                ?.vitalsDetails?[0]
                                                .weightVal !=
                                            null ||
                                        prescriptionProvider.prescriptionViewResponseModel?.data?.vitalsDetails?[0].bmi !=
                                            '0' ||
                                        prescriptionProvider
                                                .prescriptionViewResponseModel
                                                ?.data
                                                ?.vitalsDetails?[0]
                                                .tempVal !=
                                            null ||
                                        prescriptionProvider
                                                .prescriptionViewResponseModel
                                                ?.data
                                                ?.vitalsDetails?[0]
                                                .pulseVal !=
                                            null ||
                                        prescriptionProvider
                                                .prescriptionViewResponseModel
                                                ?.data
                                                ?.vitalsDetails?[0]
                                                .bpValDia !=
                                            null ||
                                        prescriptionProvider
                                                .prescriptionViewResponseModel
                                                ?.data
                                                ?.vitalsDetails?[0]
                                                .bpValSys !=
                                            null)
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Vitals:',
                                              style: kPrescriptionViewTitle,
                                            ),
                                            const Divider(
                                              color: kThemeColor,
                                            ),
                                            Text(
                                              "Height: ${(prescriptionProvider.prescriptionViewResponseModel?.data?.vitalsDetails?[0].heightVal ?? 0)}",
                                              style: kGraySubtitle,
                                            ),
                                            Text(
                                              "Weight: ${(prescriptionProvider.prescriptionViewResponseModel?.data?.vitalsDetails?[0].weightVal ?? 0)} Kg",
                                              style: kGraySubtitle,
                                            ),
                                            Text(
                                              "BMI: ${(prescriptionProvider.prescriptionViewResponseModel?.data?.vitalsDetails?[0].bmi ?? 0)} Kg/m\u00B2",
                                              style: kGraySubtitle,
                                            ),
                                            Text(
                                              "Temperature: ${(prescriptionProvider.prescriptionViewResponseModel?.data?.vitalsDetails?[0].tempVal ?? 0)} °F",
                                              style: kGraySubtitle,
                                            ),
                                            Text(
                                              "Pulse: ${(prescriptionProvider.prescriptionViewResponseModel?.data?.vitalsDetails?[0].pulseVal ?? 0)}/min",
                                              style: kGraySubtitle,
                                            ),
                                            Text(
                                              "BP: ${(prescriptionProvider.prescriptionViewResponseModel?.data?.vitalsDetails?[0].bpValSys ?? 0)}/${(prescriptionProvider.prescriptionViewResponseModel?.data?.vitalsDetails?[0].bpValDia ?? 0)}",
                                              style: kGraySubtitle,
                                            )
                                          ],
                                        ),
                                      ),
                            const SizedBox(
                              height: 100,
                            )
                          ],
                        )
                      ),
                      Expanded(
                        flex: 0,
                        child: Container(
                          width: 1,
                          height: 550,
                          color: kDarkGreyColor,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const FaIcon(
                                FontAwesomeIcons.prescription,
                                color: kDeepBlueColor,
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            const PrescriptionList(),
                            const SizedBox(
                              height: 100,
                            ),
                            const AdviceList(),
                            const SizedBox(
                              height: 15,
                            ),
                            // additionalComments(),
                            (prescriptionProvider
                                .prescriptionViewResponseModel
                                ?.data
                                ?.prescriptionDetails
                                ?.nextAppointmentDay ??
                                0) ==
                                0
                                ? Container()
                                : Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 15),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Next visit: $followUpDate ($fDString)",
                                    style: kSubTitleTextStyle,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: WidgetFactory.buildButton(
                      context: context,
                      child: const Text("Save PDF",style: TextStyle(color: kWhiteColor),),
                      backgroundColor: kDeepBlueColor,
                      borderRadius: 5,
                      onPressed: (){}),
                ),
                const SizedBox(
                  height: 34,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PrescriptionList extends StatelessWidget {
  const PrescriptionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileProvider prescriptionProvider = Provider.of<ProfileProvider>(context);
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: prescriptionProvider.prescriptionViewResponseModel?.data?.medications?.length ?? 0,
              separatorBuilder: (_, __) => const SizedBox(height: 2.0),
              itemBuilder: (BuildContext context, int position) {
                return Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${position + 1}) ${prescriptionProvider.prescriptionViewResponseModel?.data?.medications?[position].brandName}",
                          style: kSubTitleTextStyle,
                        )),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                              "${prescriptionProvider.prescriptionViewResponseModel?.data?.medications?[position].dosage} - ${prescriptionProvider.prescriptionViewResponseModel?.data?.medications?[position].duration}Days - ${prescriptionProvider.prescriptionViewResponseModel?.data?.medications?[position].instructionTake} ${prescriptionProvider.prescriptionViewResponseModel?.data?.medications?[position].medicineComment != null && prescriptionProvider.prescriptionViewResponseModel?.data?.medications?[position].medicineComment != '' ? '(${prescriptionProvider.prescriptionViewResponseModel?.data?.medications?[position].medicineComment})' : ''}",
                              style: kSubTitleTextStyle,
                            ))
                      ],
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}

class AdviceList extends StatelessWidget {
  const AdviceList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 34),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Advice:",
            style: kPrescriptionViewTitle,
          ),
          const SizedBox(
            height: 8,
          ),
          ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: profileProvider.prescriptionViewResponseModel?.data?.adviceDetails?.length ?? 0,
              separatorBuilder: (_, __) => const SizedBox(height: 2.0),
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Expanded(
                        child: Text(
                          profileProvider.prescriptionViewResponseModel?.data?.adviceDetails?[index].prescritionData ?? "",
                          style: kGraySubtitle,
                        ))
                  ],
                );
              }),
        ],
      ),
    );
  }
}

// Widget adviceList() {
//   return Container(
//     padding: const EdgeInsets.only(left: 16, right: 34),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Advice:",
//           style: kPrescriptionViewTitle,
//         ),
//         const SizedBox(
//           height: 8,
//         ),
//         ListView.separated(
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: 3,
//             separatorBuilder: (_, __) => const SizedBox(height: 2.0),
//             itemBuilder: (BuildContext context, int position) {
//               return Row(
//                 children: const [
//                   Expanded(
//                       child: Text(
//                     "Maintain correct posture during activities",
//                     style: kGraySubtitle,
//                   ))
//                 ],
//               );
//             }),
//       ],
//     ),
//   );
// }

Widget additionalComments() {
  return Container(
    padding: const EdgeInsets.only(left: 16, right: 34),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Additional Comments:",
          style: kPrescriptionViewTitle,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard.",
          style: kGraySubtitle,
        ),
      ],
    ),
  );
}
