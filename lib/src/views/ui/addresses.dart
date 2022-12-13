import 'dart:ui' as ui;

import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/providers/address_provider.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/views/ui/chat_list_screen.dart';
import 'package:dpr_patient/src/views/ui/patient_location.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Addresses extends StatefulWidget {
  const Addresses({Key? key}) : super(key: key);

  @override
  State<Addresses> createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  bool done = false;

  final _nameETController = TextEditingController();

  final _addressETController = TextEditingController();

  final _form = GlobalKey<FormState>();

  String? area;

  @override
  void initState() {
    super.initState();
    var addressProvider = Provider.of<AddressProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addressProvider.getAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var addressProvider = Provider.of<AddressProvider>(context);
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
            addressProvider.getAddresses();
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
                      Expanded(
                          flex: 2,
                          child: PatientLocation(location: UserData.address)
                      ),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                        flex: 1,
                        child: WidgetFactory.buildButton(
                            context: context,
                            child: const Text("Add New", style: kButtonTextStyle),
                            backgroundColor: kDeepBlueColor,
                            borderRadius: 8.0,
                            onPressed: () {
                              _showModalSheet(context, addressProvider, false);
                            }),
                      )
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  const Text("Address Book", style: kLargerBlueTextStyle),
                  const SizedBox(height: 16.0),
                  (!addressProvider.loadInProgress && (addressProvider.addressListModel?.data?.addresses?.length ?? 0) == 0)
                  ? SizedBox(width: size.width, height: 300, child: const Center(child: Text("No Address Added", style: kTitleTextStyle)))
                  : _showList(addressProvider, size.width)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showList(AddressProvider addressProvider, width) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: addressProvider.addressListModel?.data?.addresses?.length ?? 0,
        separatorBuilder: (_, __) => const SizedBox(height: 16.0),
        itemBuilder: (BuildContext context, int position) {
          return addressProvider.loadInProgress
              ? shimmer(width)
              : _addressTile(addressProvider, context, position);
        });
  }

  _addressTile(AddressProvider addressProvider, BuildContext context, position) {
    return ShadowContainer(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        addressProvider.addressListModel?.data?.addresses?[position].addName ?? "N\\A",
                        style: kTitleTextStyle),
                    const SizedBox(height: 8.0),
                    Text(
                        addressProvider.addressListModel?.data?.addresses?[position].address ?? "N\\A",
                        style: kSubTitleTextStyle),
                  ],
                )),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: WidgetFactory.buildButton(
                  context: context,
                  child: const Text("Edit",
                      style: kButtonTextStyle),
                  backgroundColor: kDeepBlueColor,
                  borderRadius: 8.0,
                  onPressed: () {
                    int? id = addressProvider.addressListModel?.data?.addresses?[position].addressNoPk;
                    String? name = addressProvider.addressListModel?.data?.addresses?[position].addName;
                    String? address = addressProvider.addressListModel?.data?.addresses?[position].address;
                    setState(() {
                      area = addressProvider.addressListModel?.data?.addresses?[position].addArea ?? "";
                    });
                    _showModalSheet(context, addressProvider, true, position: position, id: id, name: name, address: address);
                  }),
            )
          ],
        ),
        radius: 8.0);
  }

  _showModalSheet(BuildContext context, AddressProvider addressProvider, bool isEdit, {int? position, int? id, String? name, String? address}) {
    _nameETController.text = name ?? "";
    _addressETController.text = address ?? "";
    bool progress = false;

    LogDebugger.instance.d('isEdit: $isEdit');
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 16.0, left: 16.0, right: 16.0),
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isEdit? "Update Address" : 'Add New Address',
                        style: kLargerBlueTextStyle,
                      ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 1),
                      const SizedBox(height: 16),
                      decoration(nameTextField(context, _nameETController)),
                      const SizedBox(height: 16),
                      decoration(areaDropDown()),
                      const SizedBox(height: 16),
                      decoration(descriptionTextField(_addressETController)),
                      Container(
                        padding: const EdgeInsets.fromLTRB(16.0, 16, 16.0, 0.0),
                        child: progress
                        ? const Center(child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(color: kOrangeColor),
                        ))
                        : WidgetFactory.buildButton(
                            context: context,
                            child: Text(isEdit? "Update" : "Add", style: kButtonTextStyle),
                            backgroundColor: kDeepBlueColor,
                            borderRadius: 8.0,
                            onPressed: () async {
                              if(_form.currentState!.validate()) {
                                name = _nameETController.text.toString();
                                address = _addressETController.text.toString();
                                setModalState(() => progress = true);
                                final _responseResult = isEdit
                                    ? await addressProvider.updateAddress(
                                    position!, id!, name ?? "", area ?? "", address ?? "")
                                    : await addressProvider.addAddress(
                                    name ?? "", area ?? "", address ?? "");
                                setModalState(() => progress = false);
                                if (_responseResult) {
                                  name = "";
                                  address = "";
                                  area = null;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Address added successfully"),
                                        duration: Duration(seconds: 1),
                                      )
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(addressProvider.errorResponse
                                            .message ?? "Network error"),
                                        duration: const Duration(seconds: 1),
                                      )
                                  );
                                }
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        )
    );
  }

  Widget decoration(Widget childWidget) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(13.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ]),
      child: childWidget,
    );
  }

  Widget nameTextField(BuildContext context, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (value) {return value!.isEmpty ? 'The field is empty' : null;},
      cursorColor: kBlackColor,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(right: 4.0, left: 16.0),
        border: OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: 'Name',
        labelStyle: kTitleTextStyle,
        filled: true,
        fillColor: kWhiteColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Icon(
          Icons.person,
          color: kDeepBlueColor,
        ),
      ),
    );
  }

  Widget descriptionTextField(TextEditingController controller) {
    return TextFormField(
      maxLines: 2,
      maxLength: 200,
      validator: (value) {return value!.isEmpty ? 'The field is empty' : null;},
      controller: controller,
      cursorColor: kBlackColor,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        contentPadding:
        EdgeInsets.only(right: 8.0, left: 16.0, bottom: 16.0, top: 8.0),
        border: OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: 'Address',
        labelStyle: kTitleTextStyle,
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

  Directionality areaDropDown() {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: area,
          isExpanded: true,
          isDense: false,
          itemHeight: 50.0,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(right: 4.0, left: 16.0),
            labelText: 'Area',
            labelStyle: kTitleTextStyle,
            border: OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
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
          items: <String>['Dhaka', 'Chittagong', 'Jessore'].map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            area = value.toString();
          },
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.black,
            size: 40.0,
          ),
        ),
      ),
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