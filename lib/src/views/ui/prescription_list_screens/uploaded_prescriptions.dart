import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/scaffold_message.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadPrescriptionList extends StatelessWidget {
  const UploadPrescriptionList({Key? key, required this.index, required this.profileProvider}) : super(key: key);
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
                          '${profileProvider.profileModel?.data?.uploadPrescriptions?[index].appointDate?.split(' ').first ?? ""} ${profileProvider.profileModel?.data?.uploadPrescriptions?[index].startTime ?? ""}',
                          style: kSubTitleTextStyle),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          profileProvider.profileModel?.data
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
                          profileProvider.profileModel?.data?.uploadPrescriptions?[index].issueName ?? "",
                          style: kSubTitleTextStyle),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          profileProvider.profileModel?.data?.uploadPrescriptions?[index].age ?? "",
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
                    launchURLMethod(profileProvider.profileModel?.data
                        ?.uploadPrescriptions?[index].file ??
                        '');
                  }),
            )
          ],
        ),
        radius: 8.0);
  }
}

class UploadedPrescriptions extends StatefulWidget {
  const UploadedPrescriptions({Key? key}) : super(key: key);

  @override
  State<UploadedPrescriptions> createState() => _UploadedPrescriptionsState();
}

class _UploadedPrescriptionsState extends State<UploadedPrescriptions> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () async {
            profileProvider.getProfile();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
          !profileProvider.profileLoaded
          ? const SizedBox(height: 200,child: Center(child: CircularProgressIndicator(),))
                : (profileProvider.profileModel?.data?.uploadPrescriptions?.length ??
            0) >
            0
            ? ListView.separated(
            shrinkWrap: true,
            reverse: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: profileProvider
                .profileModel?.data?.uploadPrescriptions?.length ??
                0,
            separatorBuilder: (_, __) =>
            const SizedBox(height: 16.0),
            itemBuilder: (BuildContext context, int index) {
              return UploadPrescriptionList(index: index, profileProvider: profileProvider);
            })
            : SizedBox(height: 300, width: size.width, child: const Center(child: Text('No Prescriptions Added', style: kTitleTextStyle,)))
            ],
          ),
        ),
      ),
    );
  }
}
