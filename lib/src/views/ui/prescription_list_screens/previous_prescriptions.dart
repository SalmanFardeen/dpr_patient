import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/views/ui/prescription_view.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class PreviousPrescriptions extends StatefulWidget {
  const PreviousPrescriptions({Key? key}) : super(key: key);

  @override
  State<PreviousPrescriptions> createState() => _PreviousPrescriptionsState();
}

class _PreviousPrescriptionsState extends State<PreviousPrescriptions> {
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
          ? const SizedBox(height: 200, child: Center(child: CircularProgressIndicator(),))
                : (profileProvider.profileModel?.data?.prescriptions?.length ??
            0) >
            0
            ? ListView.separated(
            shrinkWrap: true,
            // reverse: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: profileProvider
                .profileModel?.data?.prescriptions?.length ??
                0,
            separatorBuilder: (_, __) =>
            const SizedBox(height: 16.0),
            itemBuilder: (BuildContext context, int index) {
              return PrescriptionList(index: index);
            })
            : SizedBox(height: 300, width: size.width, child: const Center(child: Text('No Prescriptions Added', style: kTitleTextStyle,)))
            ],
          ),
        ),
      ),
    );
  }
}
class PrescriptionList extends StatelessWidget {
  final int index;

  const PrescriptionList({Key? key, required this.index}) : super(key: key);

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
                          '${profileProvider.profileModel?.data?.prescriptions?[index].appointDate ?? ""} ${profileProvider.profileModel?.data?.prescriptions?[index].startTime ?? ""}',
                          style: kSubTitleTextStyle),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          profileProvider.profileModel?.data
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
                          "${profileProvider.profileModel?.data?.prescriptions?[index].specialtyString ?? ""}, ${profileProvider.profileModel?.data?.prescriptions?[index].qualificationString ?? ""}",
                          style: kSubTitleTextStyle),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Prescription ID: ${profileProvider.profileModel?.data?.prescriptions?[index].prescriptionUid ?? ""}",
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
                                    .profileModel
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