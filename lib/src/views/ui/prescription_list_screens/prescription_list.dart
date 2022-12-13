import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/views/ui/chat_list_screen.dart';
import 'package:dpr_patient/src/views/ui/prescription_list_screens/previous_prescriptions.dart';
import 'package:dpr_patient/src/views/ui/prescription_list_screens/uploaded_prescriptions.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Prescription extends StatefulWidget {
  const Prescription({Key? key}) : super(key: key);

  @override
  State<Prescription> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProfileProvider>(context, listen: false).getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
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
                  Text(
                      UserData.gender != null && UserData.age != null
                          ? "${UserData.gender}, ${UserData.age} years"
                          : "",
                      style: kParagraphTextStyle),
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
          bottom: const TabBar(
            unselectedLabelColor: kGreyColor,
            unselectedLabelStyle: kTitleTextStyle,
            labelColor: kDeepBlueColor,
            tabs: [
            Tab(text: 'Previous Prescriptions'),
            Tab(text: 'Uploaded Prescriptions'),
          ],
          // unselectedLabelColor: kWhiteColor,
          // unselectedLabelStyle: kLargerBlueTextStyle,
          ),
        ),
        body: const TabBarView(
            children: [
          PreviousPrescriptions(),
          UploadedPrescriptions(),
        ]),
      ),
    );
  }
}

