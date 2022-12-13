import 'dart:io';

import 'package:dpr_patient/src/business_logics/models/doctor_appointment_input_model.dart';
import 'package:dpr_patient/src/business_logics/models/issue_data_model.dart';
import 'package:dpr_patient/src/business_logics/models/profile_data_model.dart';
import 'package:dpr_patient/src/business_logics/providers/document_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/patient_info_provider.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/views/ui/display_appointment.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/utils/validators.dart';
import 'package:dpr_patient/src/views/widgets/scaffold_message.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientDetails extends StatefulWidget {
  final int doctorFkNo;
  final String date;
  final int? chamberFkNo;
  final int slotNoPk;
  final String? name;
  final String expertise;
  final String degree;
  final String? image;
  final String slotTxt;
  final String chamberHospitalName;
  final String? doctorFee;
  final String? reportingFee;

  const PatientDetails({
    Key? key,
    required this.doctorFkNo,
    required this.date,
    required this.chamberFkNo,
    required this.slotNoPk,
    this.name,
    required this.expertise,
    required this.degree,
    this.image,
    required this.slotTxt,
    required this.chamberHospitalName,
    this.doctorFee, this.reportingFee,
  }) : super(key: key);

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {

  final _form = GlobalKey<FormState>();

  int _selectedPatientNoPk = 0;
  bool _reportShow = false;
  int? _selectedIssue;
  String _patientName = '', _patientAge = '', _patientGender = '', _issueTxt = '';

  final _phoneNumberETController = TextEditingController();
  final _documentETController = TextEditingController();

  final _descriptionETController = TextEditingController();

  List<int>? selectedDocList = [];
  List<bool> selectedDoc = [];
  List <File>? _uploadDocumentImage = [];
  final picker = ImagePicker();

  void _launchURL(String _url) async {
    Uri url = Uri.parse(_url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
  Future getImage(double width) async {
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
          width: width,
          height: 160,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                  await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    if (mounted) {
                      setState(() {
                        _uploadDocumentImage?.add(File(pickedFile.path));
                        _documentETController.text = '${_uploadDocumentImage!.length + selectedDocList!.length}';
                      });
                    }
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(FontAwesomeIcons.camera, color: kDeepBlueColor),
                    SizedBox(width: 8.0),
                    Text("Capture Image", style: kLargerBlueTextStyle)
                  ],
                ),
              ),
              const SizedBox(height: 4.0),
              const Divider(thickness: 1),
              const SizedBox(height: 4.0),
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                  await picker.pickMultiImage();
                  if (pickedFile != null) {
                    if (mounted) {
                      setState(() {
                        pickedFile.forEach((element) {
                          _uploadDocumentImage?.add(File(element.path));
                        });
                        _documentETController.text = '${_uploadDocumentImage!.length + selectedDocList!.length}';
                      });
                    }
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(FontAwesomeIcons.photoVideo, color: kDeepBlueColor),
                    SizedBox(width: 8.0),
                    Text("Gallery", style: kLargerBlueTextStyle)
                  ],
                ),
              ),
              const SizedBox(height: 4.0),
              const Divider(thickness: 1),
              const SizedBox(height: 4.0),
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  var docProvider = Provider.of<DocumentProvider>(context, listen: false);
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => StatefulBuilder(
                          builder: (context, setState) =>  (docProvider.uploadListModel?.data?.length ?? 0) > 0
                              ? ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: docProvider.uploadListModel?.data?.length ?? 0,
                              separatorBuilder: (_, __) => const Divider(thickness: 1),
                              itemBuilder: (BuildContext context, int position) {
                                return docProvider.inProgress
                                    ? const Center(child: CircularProgressIndicator())
                                    : Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                                  child: ListTile(
                                    title: Text(docProvider.uploadListModel?.data?[position].doctDescription ?? "", style: kTitleTextStyle),
                                    trailing: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: WidgetFactory.buildButton(
                                          context: context,
                                          child: const Text("View", style: kButtonTextStyle, textAlign: TextAlign.center,),
                                          backgroundColor: kDeepBlueColor,
                                          borderRadius: 8.0,
                                          onPressed: docProvider.uploadListModel?.data?[position].pathName == null
                                              ? () {}
                                              :() {
                                            _launchURL(docProvider.uploadListModel?.data?[position].pathName ?? "");
                                          }),
                                    ),
                                    leading: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedDoc[position] = !selectedDoc[position];
                                          if(selectedDoc[position]) {
                                            if(docProvider.uploadListModel?.data?[position].dcmtNoPk != null) {
                                              selectedDocList?.add(docProvider
                                                  .uploadListModel
                                                  ?.data?[
                                              position]
                                                  .dcmtNoPk ??
                                                  0);
                                              _documentETController
                                                  .text =
                                              '${_uploadDocumentImage!.length + selectedDocList!.length}';
                                            } else {
                                              showScaffoldMessage(context, 'the document id is empty');
                                            }
                                          } else {
                                            selectedDocList?.remove(docProvider.uploadListModel?.data?[position].dcmtNoPk);
                                            _documentETController.text = ((_uploadDocumentImage?.length ?? 0) + (selectedDocList?.length ?? 0)) > 0 ? '${_uploadDocumentImage!.length + selectedDocList!.length}' : '';
                                          }
                                        });
                                      }, child: Icon(selectedDoc[position] ? Icons.check_box : Icons.check_box_outline_blank),),
                                  ),
                                );
                              }
                          ) : const Center(child: Text('No uploaded documents found'))));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.snippet_folder_rounded, color: kDeepBlueColor),
                    SizedBox(width: 8.0),
                    Text("Uploaded Documents", style: kLargerBlueTextStyle)
                  ],
                ),
              )

            ],
          ),
        )
    );
  }

  @override
  void initState() {
    super.initState();
    PatientInfoProvider patientInfoProvider = Provider.of<PatientInfoProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      patientInfoProvider.clear();
      patientInfoProvider.getIssueList();
      patientInfoProvider.getPatientList();
      var docProvider = Provider.of<DocumentProvider>(context, listen: false);
      docProvider.getDocumentList().then((value) {
        if(value) {
          docProvider
              .uploadListModel
              ?.data
              ?.forEach((element) {
            setState(() {
              selectedDoc.add(false);
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    PatientInfoProvider patientInfoProvider =
        Provider.of<PatientInfoProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: const Text("Patient Info", style: kAppBarBlueTitleTextStyle),
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
          child: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0),
                        child: ShadowContainer(
                          radius: 8.0,
                          child: SizedBox(
                            width: double.infinity,
                              child: DropdownButtonFormField<ProfileData>(
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(right: 5, left: 20),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                hint: const Text(
                                  "Please select a patient",
                                  style: TextStyle(color: Color(0xFFCBCBCB)),
                                ),
                                items: patientInfoProvider
                                    .patientInfoModel?.data?.subProfiles
                                    ?.map<DropdownMenuItem<ProfileData>>((val) {
                                  return DropdownMenuItem(
                                      value: val,
                                      onTap: () {
                                        setState(() {
                                          _phoneNumberETController.text = val.mobile ?? '';
                                          _patientName = '${val.firstName} ${val.lastName}';
                                          _patientAge = val.age ?? '';
                                          _patientGender = val.gender ?? '';
                                        });
                                      },
                                      child: Text(
                                          "${val.firstName} ${val.lastName}"));
                                }).toList(),
                                onTap: () {},
                                onChanged: (ProfileData? value) {
                                  setState(() {
                                    _selectedPatientNoPk =
                                        value?.patientNoPk ?? 1;
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.grey,
                                  size: 25.0,
                                ),
                              ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 28.0),
                        child: Container(
                          color: kWhiteColor,
                          padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                          child: const Text("Appointment For",
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 16.0),
                          child: ShadowContainer(
                            radius: 8.0,
                            child: WidgetFactory.buildTextField(
                                context: context,
                                validator: validator.phoneNoValidator,
                                label: "",
                                hint: "",
                                borderRadius: 8.0,
                                borderColor: kDarkGreyColor,
                                controller: _phoneNumberETController,
                                textInputType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onPressed: () {}),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 28.0),
                        child: Container(
                          color: kWhiteColor,
                          padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                          child: const Text("Phone Number",
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 8.0, top: 16.0),
                              child: ShadowContainer(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 16.0),
                                        child: Text("Yes"),
                                      ),
                                      SizedBox(
                                          width: 48,
                                          height: 48,
                                          child: Checkbox(
                                              value: _reportShow,
                                              onChanged: (value) {
                                                setState(() {
                                                  _reportShow = !_reportShow;
                                                });
                                              }))
                                    ],
                                  ),
                                  radius: 8.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 28.0),
                              child: Container(
                                color: kWhiteColor,
                                padding:
                                    const EdgeInsets.only(left: 4.0, top: 4.0),
                                child: const Text("Report Show",
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 16.0, top: 16.0),
                                child: ShadowContainer(
                                    radius: 8.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: _documentETController,
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.only(left: 16.0),
                                              border: InputBorder.none
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              getImage(size.width);
                                            },
                                            icon: const Icon(Icons.folder,
                                                color: kDeepBlueColor))
                                      ],
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Container(
                                  color: kWhiteColor,
                                  padding: const EdgeInsets.only(
                                      left: 4.0, top: 4.0),
                                  child: const Text("Upload",
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                  if ((_uploadDocumentImage?.length ?? 0) > 0) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                          padding: const EdgeInsets.only(left: 16),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Image.file(
                                  _uploadDocumentImage![index],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    left: 70,
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _uploadDocumentImage?.removeAt(index);
                                            _documentETController.text = ((_uploadDocumentImage?.length ?? 0) + (selectedDocList?.length ?? 0)) > 0 ? '${_uploadDocumentImage!.length + selectedDocList!.length}' : '';
                                          });
                                        },
                                        child: ShadowContainer(
                                          radius: 50,
                                          padding: const EdgeInsets.all(1.0),
                                          child: const Icon(
                                            Icons.close,
                                            color: kRedColor,
                                            size: 15,
                                          ),
                                        ))),
                              ],
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(width: 15),
                          itemCount: (_uploadDocumentImage?.length ?? 0)),
                    )
                  ],
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0),
                        child: ShadowContainer(
                          radius: 8.0,
                          child: DropdownButtonFormField<Issue>(
                            decoration: const InputDecoration(
                              contentPadding:
                              EdgeInsets.only(right: 5, left: 20),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            hint: const Text(
                              "Please select a issue",
                              style: TextStyle(color: Color(0xFFCBCBCB)),
                            ),
                            items: patientInfoProvider.issueResponseModel?.data?.tmIssuesList?.map<DropdownMenuItem<Issue>>((val) {
                              return DropdownMenuItem(
                                  value: val,
                                  child: Text(val.lookupdataName ?? ""));
                            }).toList(),
                            onTap: () {},
                            onChanged: (Issue? value) {
                              setState(() {
                                _selectedIssue = value?.lookupdataNoPk;
                                _issueTxt = value?.lookupdataName ?? '';
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.grey,
                              size: 25.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 28.0),
                        child: Container(
                          color: kWhiteColor,
                          padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                          child: const Text("Issues",
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0),
                        child: SizedBox(
                          width: size.width,
                          height: 100,
                          child: ShadowContainer(
                            radius: 15,
                            child: TextFormField(
                              maxLines: 2,
                              maxLength: 200,
                              cursorColor: kBlackColor,
                              controller: _descriptionETController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(right: 8.0, left: 16.0, bottom: 16.0, top: 16.0),
                                border: OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: '',
                                labelStyle: kTitleTextStyle,
                                hintText: '(Optional)',
                                hintStyle: TextStyle(color: kDarkGreyColor),
                                filled: true,
                                fillColor: kWhiteColor,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(13.0)),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 28.0),
                        child: Container(
                          color: kWhiteColor,
                          padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                          child: const Text("Disease Description",
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      // const Positioned(
                      //   bottom: 8,
                      //   right: 24.0,
                      //   child: Text("0/300",
                      //       style: TextStyle(color: kLightGreyColor)),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 48.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 32.0),
                      Container(
                        decoration: BoxDecoration(
                            color: patientInfoProvider.inProgress
                                ? kLightGreyColor
                                : kMediumBlueColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24.0),
                                bottomLeft: Radius.circular(24.0))),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                          child: IconButton(
                            onPressed:
                            // patientInfoProvider.appointmentConfirmationModel != null
                            //     ? () {
                            //         Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (context) =>
                            //                     ConfirmAppointment(
                            //                         provider:
                            //                             patientInfoProvider, issue: _selectedIssue ?? "" + _descriptionETController.text.toString())));
                            //       }
                            //     :
                            patientInfoProvider.inProgress
                                    ? () {}
                                    : () async {
                                        if (_selectedPatientNoPk == 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text("Please select a patient"),
                                            duration: Duration(seconds: 1),
                                          ));
                                          return;
                                        }
                                        if (_selectedIssue == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                            Text("Please select an issue"),
                                            duration: Duration(seconds: 1),
                                          ));
                                          return;
                                        }
                                        if (_form.currentState!.validate()) {
                                          LogDebugger.instance.d(
                                              "date: ${widget.date}, chamber: ${widget.chamberFkNo}, doctor: ${widget.doctorFkNo}");
                                          PatientInfoProvider.doctorAppointmentInputModel = DoctorAppointmentInputModel(
                                              appointDate: widget.date,
                                              chamber:
                                              widget.chamberFkNo,
                                              doctorNoFk: widget.doctorFkNo,
                                              phoneMobile:
                                              _phoneNumberETController
                                                  .text,
                                              patientNoFk:
                                              _selectedPatientNoPk,
                                              reportShow: _reportShow,
                                              issueNoFk: _selectedIssue,
                                              slotNoPk: widget.slotNoPk,
                                              chiefComplain:
                                              _descriptionETController
                                                  .text
                                                  .toString(),
                                              isTelemed: false,
                                            issueTxt: _issueTxt,
                                            slotTxt: widget.slotTxt,
                                            patientName: _patientName,
                                            patientAge: _patientAge,
                                            patientGender: _patientGender,
                                            doctorName: widget.name,
                                            expertise: widget.expertise,
                                            degree: widget.degree,
                                            doctorImage: widget.image,
                                            chamberHospitalName: widget.chamberHospitalName,
                                            doctorFee: widget.doctorFee,
                                            reportFee: widget.reportingFee,
                                            uploadImages: _uploadDocumentImage,
                                            docList: selectedDocList
                                          );
                                          LogDebugger.instance.e(PatientInfoProvider.doctorAppointmentInputModel.docList);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const DisplayAppointment()));

                                        }
                                      },
                            icon: const Center(
                                child: Icon(Icons.arrow_forward_ios_rounded,
                                    color: kWhiteColor, size: 32.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Container(
                              width: 48.0,
                              height: 4.0,
                              decoration: const BoxDecoration(
                                  color: kMediumBlueColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)))),
                          const SizedBox(width: 16.0),
                          Container(
                              width: 48.0,
                              height: 4.0,
                              decoration: const BoxDecoration(
                                  color: kMediumBlueColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)))),
                          const SizedBox(width: 16.0),
                          Container(
                              width: 48.0,
                              height: 4.0,
                              decoration: const BoxDecoration(
                                  color: kLightGreyColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)))),
                        ],
                      ),
                      const SizedBox(height: 8.0)
                    ],
                  ),
                  const SizedBox(height: 16.0)
                ],
              ),
            ),
          ),
          patientInfoProvider.submissionInProgress
              ? const Center(
                  child: CircularProgressIndicator(
                    color: kDeepBlueColor,
                  ),
                )
              : Container()
        ],
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _phoneNumberETController.dispose();
    _descriptionETController.dispose();
  }
}
