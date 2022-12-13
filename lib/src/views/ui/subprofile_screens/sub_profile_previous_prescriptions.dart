import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/views/ui/prescription_view.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubprofilePrescriptionList extends StatelessWidget {
  final int index;

  const SubprofilePrescriptionList({Key? key, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    return ShadowContainer(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          '${profileProvider.subProfileModel?.data?.prescriptions?[index].appointDate ?? ""} ${profileProvider.subProfileModel?.data?.prescriptions?[index].startTime ?? ""}',
                          style: kSubTitleTextStyle),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          profileProvider.subProfileModel?.data
                                  ?.prescriptions?[index].doctorName ??
                              "",
                          style: kTitleTextStyle),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "${profileProvider.subProfileModel?.data?.prescriptions?[index].specialtyString ?? ""}, ${profileProvider.subProfileModel?.data?.prescriptions?[index].qualificationString ?? ""}",
                          style: kSubTitleTextStyle),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Prescription ID: ${profileProvider.subProfileModel?.data?.prescriptions?[index].prescriptionUid ?? ""}",
                          style: kSubTitleTextStyle),
                    ),
                  ],
                )),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: WidgetFactory.buildButton(
                  context: context,
                  child: const Text("View", style: kButtonTextStyle),
                  backgroundColor: kDeepBlueColor,
                  borderRadius: 8.0,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrescriptionView(
                                id: profileProvider
                                        .subProfileModel
                                        ?.data
                                        ?.prescriptions?[index]
                                        .prescriptionNoFk ??
                                    0)));
                  }),
            )
          ],
        ),
        radius: 8.0);
  }
}
