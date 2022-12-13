import 'dart:io';

import 'package:dpr_patient/src/business_logics/providers/document_provider.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/utils/validators.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class UploadNewDocument extends StatefulWidget {
  const UploadNewDocument({Key? key}) : super(key: key);

  @override
  State<UploadNewDocument> createState() => _UploadNewDocumentState();
}

class _UploadNewDocumentState extends State<UploadNewDocument> {

  DateTime selectedDate = DateTime.now();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController fileUploadController = TextEditingController();

  final _form = GlobalKey<FormState>();

  bool _show = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2060, 12)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat("dd/MM/yyyy").format(picked);
      });
    }
  }

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
                              fileUploadController.text = _uploadDocumentImage!.path.split('/').last;
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
                              fileUploadController.text = _uploadDocumentImage!.path.split('/').last;
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DocumentProvider documentProvider = Provider.of<DocumentProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: const Text("Upload New Document", style: kAppBarBlueTitleTextStyle),
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  textFieldDecoration(descriptionTextField()),
                  const SizedBox(height: 24.0),
                  textFieldDecoration(dateTextField()),
                  const SizedBox(height: 24.0),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(13.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 2), //
                          ),
                        ]),
                    child: TextFormField(
                      autocorrect: true,
                      readOnly: true,
                      validator: validator.uploadFileValidator,
                      controller: fileUploadController,
                      onTap: () {
                        getImage(size.width);
                      },
                      decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.only(right: 5, left: 15),
                        border: const OutlineInputBorder(),
                        floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                        labelText: 'Upload File',
                        labelStyle: kTitleTextStyle,
                        hintStyle: const TextStyle(color: kLightGreyColor),
                        filled: true,
                        fillColor: kWhiteColor,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(13.0)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(13.0)),
                          borderSide: BorderSide.none,
                        ),
                        prefixText: ' ',
                        suffixIcon: IconButton(
                            icon: const Icon(
                              Ionicons.folder_sharp,
                              color: kDeepBlueColor,
                            ),
                            onPressed: () {
                              getImage(size.width);
                            }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  if(_show)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      documentProvider.errorResponse.message ?? "Network error",
                      style: const TextStyle(color: kRedColor, fontSize: 10),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  documentProvider.inProgress
                  ? const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: kOrangeColor,
                      ),
                    ),
                  )
                  : WidgetFactory.buildButton(
                      context: context,
                      child: const Text("Upload and Save Document", style: kButtonTextStyle),
                      backgroundColor: kDeepBlueColor,
                      borderRadius: 8.0,
                      onPressed: () async {
                        setState(() {
                          _show = false;
                        });
                        if(_form.currentState!.validate()) {
                          final _responseResult = await documentProvider.upload(
                              descriptionController.text.toString(),
                              dateController.text.toString(),
                              _uploadDocumentImage
                          );
                          if (_responseResult) {
                            setState(() {
                              _show = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Document uploaded successfully"),
                                  duration: Duration(seconds: 1),
                                ));
                            Navigator.pop(context);
                            documentProvider.getDocumentList();
                          } else {
                            setState(() {
                              _show = true;
                            });
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textFieldDecoration(Widget childWidget) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2), //
            ),
          ]),
      child: childWidget,
    );
  }

  Widget descriptionTextField() {
    return TextFormField(
      maxLines: 2,
      maxLength: 200,
      cursorColor: kBlackColor,
      controller: descriptionController,
      validator: validator.nameValidator,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(right: 8.0, left: 16.0, bottom: 16.0, top: 16.0),
        border: OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: 'Description',
        labelStyle: kTitleTextStyle,
        hintText: 'Document Description',
        hintStyle: TextStyle(color: kLightGreyColor),
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
    );
  }

  Widget dateTextField(){
    return TextFormField(
      readOnly: true,
      controller: dateController,
      autocorrect: true,
      onTap: () {
        _selectDate(context);
      },
      decoration: const InputDecoration(
        floatingLabelBehavior:FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        labelText: 'Reference Date',
        labelStyle: kTitleTextStyle,
        hintText: 'dd/mm/yyyy',
        hintStyle: TextStyle(color: kLightGreyColor),
        filled: true,
        fillColor: kWhiteColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(16.0)
          ),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(16.0)
          ),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Icon(
          FontAwesomeIcons.calendarDay,
          color: kDeepBlueColor,
          size: 18,
        ),
      ),
    );
  }
}