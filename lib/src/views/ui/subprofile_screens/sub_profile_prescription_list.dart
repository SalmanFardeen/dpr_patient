import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/views/ui/subprofile_screens/sub_profile_modification_button.dart';
import 'package:dpr_patient/src/views/ui/subprofile_screens/sub_profile_previous_prescriptions.dart';
import 'package:dpr_patient/src/views/ui/subprofile_screens/sub_profile_uploaded_prescriptions.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubProfilePrescriptionList extends StatefulWidget {
  final int id;

  const SubProfilePrescriptionList({Key? key, required this.id})
      : super(key: key);

  @override
  State<SubProfilePrescriptionList> createState() =>
      _SubProfilePrescriptionListState();
}

class _SubProfilePrescriptionListState
    extends State<SubProfilePrescriptionList> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      profileProvider.getSubProfile(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: profileProvider.subProfileLoaded || profileProvider.subProfileDeleted
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
              onRefresh: () {
                return Future.delayed(const Duration(seconds: 1), () async {
                  profileProvider.getSubProfile(widget.id);
                });
              },
              child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    width: size.width,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: size.width,
                              height: 350,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/sub_profile_cover.png"),
                                      fit: BoxFit.fill)),
                            ),
                            Positioned(
                              top: 200,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: kWhiteColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        topLeft: Radius.circular(25))),
                                width: size.width,
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 44,
                                    ),
                                    Text(
                                        profileProvider.subProfileModel?.data
                                                ?.profile?.patientName ??
                                            "",
                                        style: kLargerBlueTextStyle),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: size.width,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Relation: ",
                                                style: kTitleTextStyle,
                                              ),
                                              Text(
                                                profileProvider
                                                        .subProfileModel
                                                        ?.data
                                                        ?.profile
                                                        ?.patRelation ??
                                                    "",
                                                style: kSubTitleTextStyle,
                                              ),
                                            ],
                                          )),
                                          Expanded(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Age: ",
                                                style: kTitleTextStyle,
                                              ),
                                              Text(
                                                profileProvider.subProfileModel
                                                        ?.data?.profile?.age ??
                                                    "",
                                                style: kSubTitleTextStyle,
                                              ),
                                            ],
                                          )),
                                          Expanded(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              const Text(
                                                "Gender: ",
                                                style: kTitleTextStyle,
                                              ),
                                              Text(
                                                profileProvider.subProfileModel
                                                        ?.data?.profile?.gender ??
                                                    "",
                                                style: kSubTitleTextStyle,
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  profileProvider
                                                          .subProfileModel
                                                          ?.data
                                                          ?.profile
                                                          ?.address ??
                                                      "",
                                                  style: kSubTitleTextStyle,
                                                ))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 210,
                              right: 20,
                              child: SubProfileModificationButton(onTapDelete: () {
                                Navigator.pop(context);
                                profileProvider.deleteSubProfile(widget.id).then((value) {
                                  if(value) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(profileProvider.subProfileDeleteModel?.message ?? '')));
                                    profileProvider.getSubProfileList(true);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(profileProvider.errorResponse.message ?? 'Error Occurred!')));
                                  }
                                });
                              },),
                            ),
                            Positioned.fill(
                                top: 50,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Center(
                                    child: WidgetFactory.buildProfileAvatar(
                                        context: context,
                                        userName: profileProvider.subProfileModel
                                                ?.data?.profile?.patientName ??
                                            "User",
                                        radius: 100.0,
                                        url: profileProvider.subProfileModel?.data
                                            ?.profile?.image ?? 'assets/images/person.png',
                                        imageType: profileProvider.subProfileModel?.data?.profile?.image == null || profileProvider.subProfileModel?.data?.profile?.image == '' ? ImageType.Asset : ImageType.Network),
                                  ),
                                )),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              if ((profileProvider.subProfileModel?.data
                                          ?.prescriptions?.length ??
                                      0) >
                                  0) ...[
                                const SizedBox(height: 16.0),
                                const Text("Previous Prescriptions",
                                    style: kLargerBlueTextStyle),
                                const SizedBox(height: 16.0),
                                (profileProvider.subProfileModel?.data
                                    ?.prescriptions?.length ??
                                    0) >
                                    0
                                    ? ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    reverse: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: profileProvider.subProfileModel?.data
                                        ?.prescriptions?.length ??
                                        0,
                                    separatorBuilder: (_, __) =>
                                    const SizedBox(height: 16.0),
                                    itemBuilder: (BuildContext context, int index) {
                                      return SubprofilePrescriptionList(index: index);
                                    })
                                    : SizedBox(height: 300, width: size.width, child: const Center(child: Text('No Prescriptions Added', style: kTitleTextStyle,))),
                              ],
                              if ((profileProvider.subProfileModel?.data
                                          ?.uploadPrescriptions?.length ??
                                      0) >
                                  0) ...[
                                const SizedBox(height: 16.0),
                                const Text("Uploaded Prescriptions",
                                    style: kLargerBlueTextStyle),
                                const SizedBox(height: 16.0),
                                (profileProvider.subProfileModel?.data?.uploadPrescriptions?.length ??
                                    0) >
                                    0
                                    ? ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    reverse: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: profileProvider
                                        .subProfileModel?.data?.uploadPrescriptions?.length ??
                                        0,
                                    separatorBuilder: (_, __) =>
                                    const SizedBox(height: 16.0),
                                    itemBuilder: (BuildContext context, int index) {
                                      return SubProfileUploadPrescriptionList(index: index, profileProvider: profileProvider);
                                    })
                                    : SizedBox(height: 300, width: size.width, child: const Center(child: Text('No Prescriptions Added', style: kTitleTextStyle,))),
                              ],
                              if (((profileProvider.subProfileModel?.data
                                              ?.prescriptions?.length ??
                                          0) ==
                                      0) &&
                                  ((profileProvider.subProfileModel?.data
                                              ?.uploadPrescriptions?.length ??
                                          0) ==
                                      0)) ...[
                                SizedBox(
                                    height: 300,
                                    width: size.width,
                                    child: const Center(
                                        child: Text(
                                      'No Prescriptions Added',
                                      style: kTitleTextStyle,
                                    ))),
                              ],
                              const SizedBox(height: 34),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ),
      ),
    );
  }
}

