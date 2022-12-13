import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/views/ui/subprofile_screens/sub_profile_edit.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SubProfile extends StatefulWidget {
  final int patientId;
  const SubProfile({Key? key, required this.patientId}) : super(key: key);

  @override
  _SubProfileState createState() => _SubProfileState();
}

class _SubProfileState extends State<SubProfile> {
  String _dob = '';

  @override
  void initState() {
    super.initState();

    var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      profileProvider.getSubProfile(widget.patientId);
      String? date = profileProvider.subProfileModel?.data?.profile?.dob?.split(" ").first;
      if(date != null && date != '') {
        DateTime dateTime = DateFormat('yyyy-MM-dd').parse(date);
        _dob = DateFormat('dd-MM-yyyy').format(dateTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: const Text("Sub Profile", style: kAppBarBlueTitleTextStyle),
        shadowColor: Colors.transparent,
        actions: <Widget>[
          TextButton(
            onPressed: profileProvider.subProfileLoaded
            ? () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SubProfileEdit(profileProvider: profileProvider)));
            } : () {},
            child: Text("Edit", style: TextStyle(color: profileProvider.subProfileLoaded ? kMediumBlueColor : kDarkGreyColor)),
          ),
        ],
      ),
      body: !profileProvider.subProfileLoaded
      ? SizedBox(
        width: size.width,
        height: size.height / 2,
        child: const Center(
          child: CircularProgressIndicator(
            color: kDeepBlueColor,
          ),
        ),
      )
      : SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: kWhiteColor,
          child: Column(
            children: [
              Center(
                child: WidgetFactory.buildProfileAvatar(
                    context: context,
                    userName: profileProvider.subProfileModel?.data?.profile?.patientName ?? "userName",
                    radius: 100.0,
                    url: profileProvider.subProfileModel?.data?.profile?.image ?? 'assets/images/person.png',
                    imageType: profileProvider.subProfileModel?.data?.profile?.image == null || profileProvider.subProfileModel?.data?.profile?.image == '' ? ImageType.Asset : ImageType.Network
                ),
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              CustomTextInput(
                controller: TextEditingController(text: profileProvider.subProfileModel?.data?.profile?.patRelation ?? ""),
                hint: "",
                label: "Relation", size: size
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextInput(
                        controller: TextEditingController(text: profileProvider.subProfileModel?.data?.profile?.firstName ?? ""),
                        hint: "",
                        label: "First Name", size: size,),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: CustomTextInput(
                        controller: TextEditingController(text: profileProvider.subProfileModel?.data?.profile?.lastName ?? ""),
                        hint: "",
                        label: "Last Name", size: size,),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextInput(
                  controller: TextEditingController(text: profileProvider.subProfileModel?.data?.profile?.email ?? ""),
                  hint: "",
                  label: "Email", size: size,),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextInput(
                        controller: TextEditingController(text: profileProvider.subProfileModel?.data?.profile?.mobile ?? ""),
                        hint: "",
                        label: "Phone Number", size: size,),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextInput(
                        controller: TextEditingController(text: profileProvider.subProfileModel?.data?.profile?.dprId ?? ""),
                        hint: "",
                        label: "DPR ID", size: size,),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                color: kLightGreyColor,
                thickness: 2,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomTextInput(
                        controller: TextEditingController(text: _dob),
                        hint: "",
                        label: "Date of Birth", size: size,),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextInput(
                        controller: TextEditingController(text: profileProvider.subProfileModel?.data?.profile?.age ?? ""),
                        hint: "",
                        label: "Age", size: size,),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextInput(
                        controller: TextEditingController(text: profileProvider.subProfileModel?.data?.profile?.gender),
                        hint: "",
                        label: "Gender", size: size,),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextInput(
                        controller: TextEditingController(text: profileProvider.subProfileModel?.data?.profile?.maritalStatus),
                        hint: "",
                        label: "Marital Status", size: size,),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(233, 241, 255, 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Height', style: kParagraphTextStyle),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(text: profileProvider.subProfileModel?.data?.profile?.height?.split('.').first ?? ""),
                                  decoration: const InputDecoration(
                                    hintText: "",
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(4.0),
                                  ),
                                  style: const TextStyle(
                                      color: kDeepBlueColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Text("ft",
                                  style: TextStyle(
                                      color: kDarkGreyColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(text: (profileProvider.profileModel?.data?.profile?.height ?? "").contains(".") ? profileProvider.profileModel?.data?.profile?.height?.split('.').last : ""),
                                  decoration: const InputDecoration(
                                    hintText: "",
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(4.0),
                                  ),
                                  style: const TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Text("inch",
                                  style: TextStyle(
                                      color: kDarkGreyColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(233, 241, 255, 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Weight', style: kParagraphTextStyle),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(text: profileProvider.subProfileModel?.data?.profile?.weight ?? ""),
                                  decoration: const InputDecoration(
                                    hintText: "",
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(4.0),
                                  ),
                                  style: const TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Text("kg",
                                  style: TextStyle(
                                      color: kDarkGreyColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                color: kLightGreyColor,
                thickness: 2,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomTextInput(
                        controller: TextEditingController(text: profileProvider.subProfileModel?.data?.profile?.bloodGroup),
                        hint: "",
                        label: "Blood Group", size: size,),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 16, top: 4, bottom: 4, right: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: kLightBlueColor),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Blood Donor",
                                  style: kParagraphTextStyle,
                                )
                              ),
                              Checkbox(
                                onChanged: (bool? value) {},
                                value: (profileProvider.subProfileModel?.data?.profile?.donateBloodInd ?? false) == 1,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextInput(
                  controller: TextEditingController(text: profileProvider.subProfileModel?.data?.profile?.address ?? ""),
                  hint: "",
                  label: "Address", size: size,),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: kLightBlueColor),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Chronic Disease",
                            style: kParagraphTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Diabetes",
                                    style: TextStyle(
                                        color: kDarkGreyColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: Checkbox(
                                        onChanged: (bool? value) {},
                                        value: (profileProvider.subProfileModel?.data?.profile?.diabetesInd ?? false) == 1,
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "HTN",
                                    style: TextStyle(
                                        color: kDarkGreyColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: Checkbox(
                                        onChanged: (bool? value) {},
                                        value: (profileProvider.subProfileModel?.data?.profile?.htnInd ?? false) == 1,
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Asthma",
                                    style: TextStyle(
                                        color: kDarkGreyColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Checkbox(
                                    onChanged: (bool? value) {},
                                    value: (profileProvider.subProfileModel?.data?.profile?.asthmaInd ?? false) == 1,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final Size size;
  final String hint;
  final String label;

  const CustomTextInput({
    Key? key,
    required this.controller,
    required this.size,
    required this.hint,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(233, 241, 255, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: kParagraphTextStyle),
          TextField(
            readOnly: true,
            enabled: false,
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: kDarkGreyColor),
              border: InputBorder.none,
              isDense: true,
              contentPadding:
                  const EdgeInsets.only(right: 4.0, bottom: 4.0, top: 4.0),
            ),
            style: const TextStyle(
                color: kBlackColor,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
