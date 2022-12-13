import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/scaffold_message.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';

class SubProfileUploadPrescriptionList extends StatelessWidget {
  const SubProfileUploadPrescriptionList({Key? key, required this.index, required this.profileProvider}) : super(key: key);
  final int index;
  final ProfileProvider profileProvider;

  @override
  Widget build(BuildContext context) {
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
                          '${profileProvider.subProfileModel?.data?.uploadPrescriptions?[index].appointDate?.split(' ').first ?? ""} ${profileProvider.subProfileModel?.data?.uploadPrescriptions?[index].startTime ?? ""}',
                          style: kSubTitleTextStyle),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          profileProvider.subProfileModel?.data
                              ?.uploadPrescriptions?[index].patientName ??
                              "",
                          style: kTitleTextStyle),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          profileProvider.subProfileModel?.data?.uploadPrescriptions?[index].issueName ?? "",
                          style: kSubTitleTextStyle),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          profileProvider.subProfileModel?.data?.uploadPrescriptions?[index].age ?? "",
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
                    launchURLMethod(profileProvider.subProfileModel?.data
                        ?.uploadPrescriptions?[index].file ??
                        '');
                  }),
            )
          ],
        ),
        radius: 8.0);
  }
}