import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/views/ui/chat_list_screen.dart';
import 'package:dpr_patient/src/views/ui/subprofile_screens/sub_profile_edit.dart';
import 'package:dpr_patient/src/views/ui/subprofile_screens/sub_profile_prescription_list.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SubProfileList extends StatefulWidget {
  const SubProfileList({Key? key}) : super(key: key);

  @override
  State<SubProfileList> createState() => _SubProfileListState();
}

class _SubProfileListState extends State<SubProfileList> {

  @override
  void initState() {
    super.initState();

    var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      profileProvider.getSubProfileList(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: kWhiteColor,
        shadowColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(UserData.username ?? "", style: kTitleTextStyle),
                const SizedBox(height: 4.0),
                Text(UserData.gender != null && UserData.age != null ? "${UserData.gender}, ${UserData.age} years" : "", style: kParagraphTextStyle),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: const FaIcon(
              FontAwesomeIcons.facebookMessenger,
              size: 20,
            ),
            color: kDeepBlueColor,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatListScreen()));
            },
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8.0),
          Container(
            padding: const EdgeInsets.only(right: 20),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 14),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.notifications,
                      color: kDeepBlueColor,
                    ),
                    onPressed: () {},
                    constraints: const BoxConstraints(),
                  ),
                ),
                Positioned(
                    top: 14,
                    left: 12,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "1",
                            style: TextStyle(fontSize: 6, color: kWhiteColor),
                          )),
                    ))
              ],
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () async {
            profileProvider.getSubProfileList(true);
          });
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              width: size.width,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Expanded(
                      //     flex: 2,
                      //     child: PatientLocation(location: UserData.address)
                      // ),
                      Expanded(
                          flex: 3,
                          child: Container()
                      ),
                      Expanded(
                        flex: 1,
                        child: WidgetFactory.buildButton(
                            context: context,
                            child: const Text("Add New", style: kButtonTextStyle),
                            backgroundColor: kDeepBlueColor,
                            borderRadius: 8.0,
                            onPressed: () {
                              profileProvider.clear();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SubProfileEdit(profileProvider: profileProvider)));
                            }
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  const Text("Sub Profiles", style: kLargerBlueTextStyle),
                  const SizedBox(height: 16.0),
                  (!profileProvider.subProfileListLoaded && (profileProvider.patientInfoModel?.data?.subProfiles?.length ?? 0) == 0)
                      ? SizedBox(width: size.width, height: 300, child: const Center(child: Text("No Sub Profile Added", style: kTitleTextStyle)))
                      : _showList(profileProvider, size.width)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showList(ProfileProvider profileProvider, double width) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        reverse: true,
        scrollDirection: Axis.vertical,
        itemCount: profileProvider.patientInfoModel?.data?.subProfiles?.length ?? 0,
        separatorBuilder: (_, __) => const SizedBox(height: 16.0),
        itemBuilder: (BuildContext context, int position) {
          return profileProvider.subProfileListLoaded
            ? shimmer(width)
              : profileListTile(profileProvider, context, position);
        }
    );
  }

  profileListTile(ProfileProvider profileProvider, BuildContext context, int position) {
    return ShadowContainer(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profileProvider.patientInfoModel?.data?.subProfiles?[position].patientName ?? 'Patient', style: kTitleTextStyle),
                    Text(profileProvider.patientInfoModel?.data?.subProfiles?[position].patRelation ?? 'Brother', style: kSubTitleTextStyle)
                  ],
                )
            ),
            Expanded(
              flex: 1,
              child: WidgetFactory.buildButton(
                  context: context,
                  child: const Text("View", style: kButtonTextStyle),
                  backgroundColor: kDeepBlueColor,
                  borderRadius: 8.0,
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => SubProfile(patientId: profileProvider.patientInfoModel?.data?.subProfiles?[position].patientNoPk ?? 0)));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SubProfilePrescriptionList(id: profileProvider.patientInfoModel?.data?.subProfiles?[position].patientNoPk ?? 0)));
                  }),
            ),
          ],
        ),
        radius: 8.0
    );
  }

  Widget shimmer(width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
                color: Colors.grey[200]!
            )
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 130, height: 20, color: Colors.grey[200]),
                  const SizedBox(height: 4.0),
                  Container(width: 150, height: 20, color: Colors.grey[200]),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}