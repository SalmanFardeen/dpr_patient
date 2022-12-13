import 'dart:io';
import 'dart:ui' as ui;

import 'package:dpr_patient/src/business_logics/models/blood_group_model.dart';
import 'package:dpr_patient/src/business_logics/models/gender_model.dart';
import 'package:dpr_patient/src/business_logics/models/marital_status_model.dart';
import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/utils/validators.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class SubProfileEdit extends StatefulWidget {
  final ProfileProvider profileProvider;
  const SubProfileEdit({Key? key, required this.profileProvider}) : super(key: key);

  @override
  _SubProfileEditState createState() => _SubProfileEditState();
}

class _SubProfileEditState extends State<SubProfileEdit> {

  final _form = GlobalKey<FormState>();

  bool _diabetes = false;
  bool _htn = false;
  bool _asthma = false;
  bool _bloodDonor = false;
  String? _selectedRelation;
  String _dob = '';
  int? _selectedBloodGroupId;
  int? _selectedGenderId;
  int? _selectedMaritalStatusId;

  final List<String> _relationList = [
    'Mother',
    'Father',
    'Sister',
    'Brother',
    'Son',
    'Wife',
    'Daughter',
    'Uncle',
    'Aunt',
    'Grandfather',
    'Grandmother',
  ];

  final List<BloodGroupModel> _bloodGroupList = [
    BloodGroupModel(id: 11, group: 'A+'),
    BloodGroupModel(id: 12, group: 'A-'),
    BloodGroupModel(id: 13, group: 'AB+'),
    BloodGroupModel(id: 14, group: 'AB-'),
    BloodGroupModel(id: 15, group: 'B+'),
    BloodGroupModel(id: 16, group: 'B-'),
    BloodGroupModel(id: 17, group: 'O+'),
    BloodGroupModel(id: 18, group: 'O-'),
  ];

  final List<GenderModel> _genderList = [
    GenderModel(id: 5, gender: 'Male'),
    GenderModel(id: 6, gender: 'Female'),
    GenderModel(id: 7, gender: 'Others')
  ];

  final List<MaritalStatusModel> _maritalStatusList = [
    MaritalStatusModel(id: 19, maritalStatus: 'Single'),
    MaritalStatusModel(id: 20, maritalStatus: 'Married'),
  ];

  final _firstNameETController = TextEditingController();
  final _lastNameETController = TextEditingController();
  final _emailETController = TextEditingController();
  final _phoneETController = TextEditingController();
  final _dprIdETController = TextEditingController();
  final _dobETController = TextEditingController();
  final _ageETController = TextEditingController();
  final _heightFootETController = TextEditingController();
  final _heightInchETController = TextEditingController();
  final _weightETController = TextEditingController();
  final _addressETController = TextEditingController();

  File? _uploadDocumentImage;
  final picker = ImagePicker();

  Future getImage(double width) async {
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
          width: width,
          height: 150,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          final pickedFile =
                          await picker.pickImage(source: ImageSource.camera);
                          if (pickedFile != null) {
                            if (mounted) {
                              setState(() {
                                _uploadDocumentImage = File(pickedFile.path);
                                LogDebugger.instance.d('path: $_uploadDocumentImage');
                                // fileUploadController.text = _uploadDocumentImage.path.split('/').last;
                              });
                            }
                          }
                        },
                        child: Icon(FontAwesomeIcons.camera, color: kDeepBlueColor, size: width / 6)
                    ),
                    const SizedBox(height: 16.0),
                    const Text("Capture Image", style: kLargerBlueTextStyle)
                  ],
                ),
              ),
              Container(
                height: 150,
                width: 1,
                color: kBlackColor,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            if (mounted) {
                              setState(() {
                                _uploadDocumentImage = File(pickedFile.path);
                                // fileUploadController.text = _uploadDocumentImage.path.split('/').last;
                              });
                            }
                          }
                        },
                        child: Icon(FontAwesomeIcons.photoVideo, color: kDeepBlueColor, size: width / 6)
                    ),
                    const SizedBox(height: 16.0),
                    const Text("Gallery", style: kLargerBlueTextStyle)
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  Future getImageOptions(double width, ProfileProvider profileProvider) async {
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
          width: width,
          height: 116,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  getImage(width);
                },
                child: Row(
                  children: const [
                    Icon(FontAwesomeIcons.camera, color: kDeepBlueColor, size: 20),
                    SizedBox(width: 6.0),
                    Text("Edit Image", style: kLargerBlueTextStyle)
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _uploadDocumentImage = null;
                    if(profileProvider.subProfileModel?.data
                        ?.profile?.image !=
                        null &&
                        profileProvider.subProfileModel
                            ?.data?.profile?.image !=
                            '') {
                      profileProvider.deleteProfilePic(profileProvider.subProfileModel?.data?.profile?.patientNoPk ?? 0).then((value) {
                      if(value) {
                        profileProvider.getSubProfile(profileProvider.subProfileModel!.data!.profile!.patientNoPk!);
                      }
                    });
                    }
                  });
                },
                child: Row(
                  children: const [
                    Icon(Icons.delete, color: kDeepBlueColor, size: 20),
                    SizedBox(width: 6.0),
                    Text("Remove Image", style: kLargerBlueTextStyle)
                  ],
                ),
              ),            ],
          ),
        )
    );
  }

  @override
  void initState() {
    super.initState();

    _firstNameETController.text = widget.profileProvider.subProfileModel?.data?.profile?.firstName ?? "";
    _lastNameETController.text = widget.profileProvider.subProfileModel?.data?.profile?.lastName ?? "";
    _emailETController.text = widget.profileProvider.subProfileModel?.data?.profile?.email ?? "";
    _phoneETController.text = widget.profileProvider.subProfileModel?.data?.profile?.mobile ?? "";
    _dprIdETController.text = widget.profileProvider.subProfileModel?.data?.profile?.dprId ?? "";
    _dob = widget.profileProvider.subProfileModel?.data?.profile?.dob?.split(" ").first ?? "";
    if(_dob != '') {
      DateTime dateTime = DateFormat('yyyy-MM-dd').parse(_dob);
      _dobETController.text = DateFormat('dd-MM-yyyy').format(dateTime);
    } else {
      _dobETController.text = '';
    }
    _ageETController.text = widget.profileProvider.subProfileModel?.data?.profile?.age ?? "";
    _heightFootETController.text = widget.profileProvider.subProfileModel?.data?.profile?.height?.split('.').first != '0' ? (widget.profileProvider.subProfileModel?.data?.profile?.height?.split('.').first ?? '') : '';
    _heightInchETController.text = (widget.profileProvider.subProfileModel?.data?.profile?.height ?? "").contains(".") ? widget.profileProvider.profileModel!.data!.profile!.height!.split('.').last : "";
    _weightETController.text = widget.profileProvider.subProfileModel?.data?.profile?.weight?.toString() ?? "";
    _addressETController.text = widget.profileProvider.subProfileModel?.data?.profile?.address ?? "";
    _selectedRelation = widget.profileProvider.subProfileModel?.data?.profile?.patRelation;
    _selectedGenderId = widget.profileProvider.subProfileModel?.data?.profile?.gender != null ? _genderList.firstWhere((gender) => gender.gender == widget.profileProvider.subProfileModel?.data?.profile?.gender).id : null;
    _selectedMaritalStatusId = widget.profileProvider.subProfileModel?.data?.profile?.maritalStatus != null ? _maritalStatusList.firstWhere((maritalStatus) => maritalStatus.maritalStatus == widget.profileProvider.subProfileModel?.data?.profile?.maritalStatus).id : null;
    _selectedBloodGroupId = widget.profileProvider.subProfileModel?.data?.profile?.bloodGroup != null ? _bloodGroupList.firstWhere((bloodGroup) => bloodGroup.group == widget.profileProvider.subProfileModel?.data?.profile?.bloodGroup).id : null;
    _bloodDonor = (widget.profileProvider.subProfileModel?.data?.profile?.donateBloodInd ?? false) == 1;
    _diabetes = (widget.profileProvider.subProfileModel?.data?.profile?.diabetesInd ?? false) == 1;
    _htn = (widget.profileProvider.subProfileModel?.data?.profile?.htnInd ?? false) == 1;
    _asthma = (widget.profileProvider.subProfileModel?.data?.profile?.asthmaInd ?? false) == 1;
  }

  updateProfile(BuildContext context, ProfileProvider profileProvider) async {
    if(!_form.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter required data"),
            duration: Duration(seconds: 1),
          ));
      return;
    }
    if(_uploadDocumentImage != null) {
      if (await _uploadDocumentImage!.length() > 10485760) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("File size should be less than 1MB"),
              duration: Duration(seconds: 1),
            ));
        return;
      }
    }

    String? firstName = _firstNameETController.text;
    String? lastName = _lastNameETController.text;
    String? email = _emailETController.text;
    String? phone = _phoneETController.text;
    String? dob = _dob;
    String? heightFoot = _heightFootETController.text == "" ? "0" : _heightFootETController.text;
    String? heightInch = _heightInchETController.text == "" ? "0" : _heightInchETController.text;
    String? weight = _weightETController.text;
    String? address = _addressETController.text;
    final _responseResult = profileProvider.subProfileModel?.data?.profile?.patientNoPk != null
        ? await profileProvider.updateProfile(
        id: profileProvider.subProfileModel?.data?.profile?.patientNoPk ?? 0,
        patientImage: _uploadDocumentImage?.path,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phone,
        dob: dob,
        heightFoot: heightFoot,
        heightInch: heightInch,
        weight: weight,
        address: address,
        bloodDonor: _bloodDonor,
        diabetesInd: _diabetes,
        htnInd: _htn,
        asthmaInd: _asthma,
        relation: _selectedRelation!,
        bloodGroup: _selectedBloodGroupId,
        maritalStatus: _selectedMaritalStatusId,
        gender: _selectedGenderId!
    )
    : await profileProvider.addSubProfile(
        patientImage: _uploadDocumentImage?.path,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phone,
        dob: dob,
        heightFoot: heightFoot,
        heightInch: heightInch,
        weight: weight,
        address: address,
        bloodDonor: _bloodDonor,
        diabetesInd: _diabetes,
        htnInd: _htn,
        asthmaInd: _asthma,
        relation: _selectedRelation!,
        bloodGroup: _selectedBloodGroupId,
        maritalStatus: _selectedMaritalStatusId,
        gender: _selectedGenderId!
    );
    if (_responseResult) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully"),
            duration: Duration(seconds: 1),)
      );
      // Navigator.pop(context);
      if(profileProvider.subProfileModel?.data?.profile?.patientNoPk != null) {
        profileProvider.getSubProfile(profileProvider.subProfileModel!.data!.profile!.patientNoPk!);
      }
      profileProvider.getSubProfileList(true);
      profileProvider.getProfile();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(profileProvider.errorResponse.message ?? "Network error"),
            duration: const Duration(seconds: 1),)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: const Text("Profile", style: kAppBarBlueTitleTextStyle),
        shadowColor: Colors.transparent,
        actions: <Widget>[
          TextButton(
            onPressed: profileProvider.inProgress
            ? () {}
            : () {
              updateProfile(context, profileProvider);
            },
            child: Text("Save", style: TextStyle(color: profileProvider.inProgress ? kDarkGreyColor : kMediumBlueColor)),
          ),
        ],
      ),
      body: profileProvider.inProgress
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
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: kWhiteColor,
          child: Stack(
            children: [
              Form(
                key: _form,
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          WidgetFactory.buildProfileAvatar(
                              context: context,
                              userName: profileProvider.subProfileModel?.data?.profile?.patientName ?? "userName",
                              radius: 100.0,
                              url: _uploadDocumentImage?.path ?? profileProvider.subProfileModel?.data?.profile?.image ?? 'assets/images/person.png',
                              imageType: _uploadDocumentImage == null ? (profileProvider.subProfileModel?.data?.profile?.image == null || profileProvider.subProfileModel?.data?.profile?.image == '' ? ImageType.Asset : ImageType.Network) : ImageType.File
                          ),
                          Positioned(
                            child: InkWell(
                              onTap: () {
                                      if (profileProvider.subProfileModel?.data
                                                      ?.profile?.image !=
                                                  null &&
                                              profileProvider.subProfileModel
                                                      ?.data?.profile?.image !=
                                                  '' ||
                                          _uploadDocumentImage != null) {
                                        getImageOptions(
                                            size.width, profileProvider);
                                      } else {
                                        getImage(size.width);
                                      }
                                    },
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                decoration: const BoxDecoration(
                                  color: kMediumBlueColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, color: kWhiteColor),
                              ),
                            ),
                            right: 4.0,
                            bottom: 4.0,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if(_selectedRelation?.toUpperCase() != 'SELF')
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.only(top: 12.0),
                      decoration: BoxDecoration(
                        color: kLightBlueColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DropdownButtonFormField<String>(
                        validator: (val) {
                          if(val == null) {
                            return 'This field is required';
                          }
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(right: 5, left: 20),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        hint: const Text.rich(TextSpan(
                                    text: 'Relation ',
                                    style: kTitleTextStyle,
                                    children: [TextSpan(text: '*', style: TextStyle(color: kRedColor))])),
                        value: _selectedRelation,
                        items: _relationList.map<DropdownMenuItem<String>>((val) {
                          return DropdownMenuItem(value: val, child: Text(val));
                        }).toList(),
                        onTap: () {},
                        onChanged: (String? value) {
                          if(value != null) {
                            _selectedRelation = value;
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                          size: 24.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(children: [
                      Expanded(
                        child: CustomTextInput(
                            controller: _firstNameETController,
                            validator: validator.nameValidator,
                            hint: "",
                            label: const Text.rich(TextSpan(
                                text: 'First Name ',
                                style: kTitleTextStyle,
                                children: [TextSpan(text: '*', style: TextStyle(color: kRedColor))])),
                            textInputType: TextInputType.text,
                            textInputAction: TextInputAction.next),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: CustomTextInput(
                            controller: _lastNameETController,
                            validator: validator.nameValidator,
                            hint: "",
                            label: const Text.rich(TextSpan(
                                text: 'Last Name ',
                                style: kTitleTextStyle,
                                children: [TextSpan(text: '*', style: TextStyle(color: kRedColor))])),
                            textInputType: TextInputType.text,
                            textInputAction: TextInputAction.next),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextInput(
                              controller: _emailETController,
                              validator: validator.emailValidator,
                              hint: "",
                              label: const Text("Email", style: kTitleTextStyle,),
                              textInputType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextInput(
                              controller: _phoneETController,
                              validator: validator.phoneNoValidator,
                              hint: "",
                              label: const Text.rich(TextSpan(
                                  text: 'Phone Number ',
                                  style: kTitleTextStyle,
                                  children: [TextSpan(text: '*', style: TextStyle(color: kRedColor))])),
                              textInputType: TextInputType.phone,
                              textInputAction: TextInputAction.next),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: CustomTextInput(
                            readOnly: true,
                              controller: _dprIdETController,
                              hint: "",
                              label: const Text("DPR ID", style: kTitleTextStyle,),
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: kDarkGreyColor),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.only(top: 4, bottom: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kLightBlueColor),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                    child: CustomTextInput(
                                        readOnly: true,
                                        validator: validator.dobValidator,
                                        onPressed: () {
                                          _showDatePicker(context);
                                        },
                                        controller: _dobETController,
                                        hint: "",
                                        label: const Text.rich(TextSpan(
                                            text: 'Date of Birth ',
                                            style: kTitleTextStyle,
                                            children: [TextSpan(text: '*', style: TextStyle(color: kRedColor))])),
                                        textInputType: TextInputType.text,
                                        textInputAction: TextInputAction.next)),
                                Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: IconButton(
                                      onPressed: () {
                                        _showDatePicker(context);
                                      },
                                      icon: const Icon(Ionicons.calendar,
                                        color: kDeepBlueColor,
                                        size: 14,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: CustomTextInput(
                              readOnly: true,
                              controller: _ageETController,
                              // validator: validator.nameValidator,
                              hint: "",
                              label: const Text("Age", style: kTitleTextStyle,),
                              textInputType: TextInputType.number,
                              textInputAction: TextInputAction.next),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 12.0),
                            decoration: BoxDecoration(
                              color: kLightBlueColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButtonFormField<GenderModel>(
                              validator: (val) {
                                if(val == null) {
                                  return 'This field is required';
                                }
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(right: 5, left: 20),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              hint: const Text.rich(TextSpan(
                                        text: 'Gender ',
                                        style: kTitleTextStyle,
                                        children: [
                                          TextSpan(
                                              text: '*',
                                              style:
                                                  TextStyle(color: kRedColor))
                                        ])),
                              value: _selectedGenderId == null ? null : _genderList.firstWhere((gender) => gender.id == _selectedGenderId),
                              items: _genderList.map<DropdownMenuItem<GenderModel>>((val) {
                                return DropdownMenuItem(value: val, child: Text(val.gender));
                              }).toList(),
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                              onChanged: (GenderModel? value) {
                                if(value?.gender != null) {
                                  _selectedGenderId = value?.id;
                                }
                              },
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 12.0),
                            decoration: BoxDecoration(
                              color: kLightBlueColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButtonFormField<MaritalStatusModel>(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(right: 5, left: 20),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              hint: const Text(
                                "Marital Status",
                                style: kTitleTextStyle,
                              ),
                              value: _selectedMaritalStatusId == null ? null : _maritalStatusList.firstWhere((maritalStatus) => maritalStatus.id == _selectedMaritalStatusId),
                              items: _maritalStatusList.map<DropdownMenuItem<MaritalStatusModel>>((val) {
                                return DropdownMenuItem(value: val, child: Text(val.maritalStatus));
                              }).toList(),
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                              onChanged: (MaritalStatusModel? value) {
                                if(value?.maritalStatus != null) {
                                  _selectedMaritalStatusId = value?.id;
                                }
                              },
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kLightBlueColor),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Height",
                                  style: kSubTitleTextStyle,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _heightFootETController,
                                        validator: validator.ftValidator,
                                        onTap: () {},
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        cursorColor: kBlackColor,
                                        decoration: const InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: kBlackColor),
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(4.0),
                                        ),
                                        style: kTitleTextStyle,
                                      ),
                                    ),
                                    const Text("ft", style: kTitleTextStyle),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _heightInchETController,
                                        validator: validator.inchValidator,
                                        onTap: () {},
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        cursorColor: kBlackColor,
                                        decoration: const InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: kBlackColor),
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(4.0),
                                        ),
                                        style: kTitleTextStyle,
                                      ),
                                    ),
                                    const Text("Inch", style: kTitleTextStyle),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox()),
                        Expanded(
                            flex: 10,
                            child: Container(
                              padding: const EdgeInsets.only(top: 12.0),
                              decoration: BoxDecoration(
                                color: kLightBlueColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: TextFormField(
                                controller: _weightETController,
                                validator: validator.weightValidator,
                                cursorColor: kBlackColor,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  labelText: '  Weight',
                                  labelStyle: kTitleTextStyle,
                                  hintText: "",
                                  hintStyle: TextStyle(color: kLightGreyColor),
                                  filled: true,
                                  fillColor: kLightBlueColor,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: kDarkGreyColor),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 12.0),
                            decoration: BoxDecoration(
                              color: kLightBlueColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButtonFormField<BloodGroupModel>(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(right: 5, left: 20),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              hint: const Text(
                                "Blood Group",
                                style: kTitleTextStyle,
                              ),
                              value: _selectedBloodGroupId == null ? null : _bloodGroupList.firstWhere((bloodGroup) => bloodGroup.id == _selectedBloodGroupId),
                              items: _bloodGroupList.map<DropdownMenuItem<BloodGroupModel>>((val) {
                                return DropdownMenuItem(value: val, child: Text(val.group));
                              }).toList(),
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                              onChanged: (BloodGroupModel? value) {
                                if(value?.group != null) {
                                  _selectedBloodGroupId = value?.id;
                                }
                              },
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
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
                                      style: kTitleTextStyle,
                                    )),
                                    Checkbox(
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _bloodDonor = !_bloodDonor;
                                        });
                                      },
                                      value: _bloodDonor,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextInput(
                              width: size.width,
                              controller: _addressETController,
                              // validator: validator.nameValidator,
                              hint: "",
                              label: const Text("Address", style: kTitleTextStyle,),
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: kLightBlueColor),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Chronic Disease",
                            style: TextStyle(color: kDeepBlueColor),
                          ),
                          const SizedBox(height: 8.0),
                          SizedBox(
                            width: size.width,
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _diabetes = !_diabetes;
                                      });
                                    },
                                    child: SizedBox(
                                      width:size.width,
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Diabetes",
                                            style: kTitleTextStyle,
                                          ),
                                          const SizedBox(width: 5,),
                                          _diabetes ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _htn = !_htn;
                                      });
                                    },
                                    child: SizedBox(
                                      width:size.width,
                                      child: Row(
                                        children: [
                                          const Text(
                                            "HTN",
                                            style: kTitleTextStyle,
                                          ),
                                          const SizedBox(width: 5,),
                                          _htn ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _asthma = !_asthma;
                                      });
                                    },
                                    child: SizedBox(
                                      width:size.width,
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Asthma",
                                            style: kTitleTextStyle,
                                          ),
                                          const SizedBox(width: 5,),
                                          _asthma ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDatePicker(BuildContext context) {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now())
        .then((value) {
      setState(() {
        _dob =
            DateFormat("yyyy-MM-dd")
                .format(value!);
        _dobETController.text =
            DateFormat("dd-MM-yyyy")
                .format(value);
      });
      calculateAge(value!);
    });
  }
  void calculateAge(DateTime value) {
    DateTime birthDate = value;
    DateTime currentDate = DateTime.now();
    int yearNow = currentDate.year;
    int yearBirth = birthDate.year;

    int monthNow = currentDate.month;
    int monthBirth = birthDate.month;
    int monthDiff = 0;
    int dayNow = currentDate.day;
    int dayBirth = birthDate.day;
    if (dayNow - dayBirth < 0) {
      monthNow--;
    }
    if (monthNow - monthBirth >= 0) {
      monthDiff = monthNow - monthBirth;
    } else {
      monthDiff = monthNow + 12 - monthBirth;
      yearNow--;
    }
    int yearDiff = yearNow - yearBirth;
    _ageETController.text = "$yearDiff";
  }
}

class CustomTextInput extends StatelessWidget {
  final double? width;
  final TextEditingController controller;
  final validator;
  final String hint;
  final Widget label;
  final bool? readOnly;
  final VoidCallback? onPressed;
  final TextInputType textInputType;
  final TextInputAction textInputAction;

  const CustomTextInput({
    Key? key,
    this.width,
    required this.controller,
    this.validator,
    required this.hint,
    required this.label,
    required this.textInputType,
    required this.textInputAction,
    this.readOnly,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
        color: kLightBlueColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        readOnly: readOnly ?? false,
        controller: controller,
        validator: validator,
        cursorColor: kBlackColor,
        keyboardType: textInputType,
        textInputAction: textInputAction,
        onTap: onPressed,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          label: label,
          // labelText: '  $label',
          // labelStyle: kTitleTextStyle,
          hintText: hint,
          hintStyle: const TextStyle(color: kLightGreyColor),
          filled: true,
          fillColor: kLightBlueColor,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class CustomDropDown extends StatelessWidget {
  final hint;
  final value;
  final label;
  final onTap;
  final onChanged;
  final List<String> items;

  const CustomDropDown(
      {Key? key,
      required this.hint,
      required this.value,
      required this.label,
      this.onTap,
      this.onChanged,
      required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: kLightBlueColor,
        borderRadius: BorderRadius.circular(13.0),
      ),
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              labelText: '  $label',
              hintStyle: const TextStyle(color: kLightGreyColor),
              labelStyle: kTitleTextStyle,
              filled: true,
              fillColor: kLightBlueColor,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                borderSide: BorderSide.none,
              ),
            ),
            items: items.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {},
          ),
        ),
      ),
    );
  }
}
