import 'package:dpr_patient/src/business_logics/models/medication_type_data_model.dart';
import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/providers/medication_provider.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/views/ui/chat_list_screen.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MedicationPlan extends StatefulWidget {
  const MedicationPlan({Key? key}) : super(key: key);

  @override
  State<MedicationPlan> createState() => _MedicationPlanState();
}

class _MedicationPlanState extends State<MedicationPlan> {

  final _form = GlobalKey<FormState>();
  List<String> _selectedTimeSlot = [];
  String? _selectedMedicationType;
  bool _everyday = false;
  var _selectedDays = [false, false, false, false, false, false, false];
  final _days = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  final _medicineETController = TextEditingController();
  final _noteETController = TextEditingController();

  late String formattedDate;

  @override
  void initState() {
    super.initState();
    var medicationProvider =
        Provider.of<MedicationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      medicationProvider.getMedicationPlans();
      medicationProvider.getMedicationTypes();
    });

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MMMM-dd');
    formattedDate = formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    MedicationProvider medicationProvider =
        Provider.of<MedicationProvider>(context);
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
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () async {
            medicationProvider.getMedicationPlans();
            medicationProvider.getMedicationTypes();
          });
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      // Expanded(
                      //     flex: 2,
                      //     child: PatientLocation(location: UserData.address)),
                      Expanded(flex: 3, child: Container()),
                      Expanded(
                        flex: 1,
                        child: WidgetFactory.buildButton(
                            context: context,
                            child: const Text("Add New", style: kButtonTextStyle),
                            backgroundColor: kDeepBlueColor,
                            borderRadius: 8.0,
                            onPressed: () {
                              _showModalSheet(context, medicationProvider, size);
                            }),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Worry Less.\nLive Healthier.",
                                  style: TextStyle(
                                      color: kDeepBlueColor,
                                      fontSize: size.width / 14,
                                      fontWeight: FontWeight.w400)),
                              const SizedBox(height: 8.0),
                              Text("Welcome to daily dose reminder",
                                  style: TextStyle(
                                      color: kDeepBlueColor, fontSize: size.width / 24))
                            ],
                          )),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 1,
                          child: ShadowContainer(
                            color: kLightBlueColor,
                            radius: 8.0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: Column(
                              children: [
                                const Text("TODAY", style: kTitleTextStyle),
                                const SizedBox(height: 8.0),
                                Text(formattedDate.split("-").last,
                                    style: TextStyle(
                                        fontSize: size.width / 18,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8.0),
                                Text(formattedDate.split("-")[1],
                                    style: TextStyle(
                                        fontSize: size.width / 28,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 4.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 8.0),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF0C909D),
                                      borderRadius: BorderRadius.circular(16.0)),
                                  child: Text(formattedDate.split("-").first,
                                      style: TextStyle(
                                          color: kWhiteColor, fontSize: size.width / 24)),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                // medicationProvider.loadInProgress
                (!medicationProvider.loadInProgress && (medicationProvider.medicationPlanResponseModel?.data?.length ?? 0) == 0)
                ? SizedBox(width: size.width, height: 300, child: const Center(child: Text("No Medication plan added", style: kTitleTextStyle)))
                : getMedicationPlanList(medicationProvider, size.width),
                const SizedBox(height: 16.0)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getMedicationPlanList(MedicationProvider medicationProvider, double width) {
    LogDebugger.instance.d('Progress ${medicationProvider.loadInProgress}');
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: medicationProvider.medicationPlanResponseModel?.data?.length ?? 0,
      separatorBuilder: (_, __) => const SizedBox(height: 16.0),
      itemBuilder: (BuildContext context, int position) {
        // LogDebugger.instance.d('Progress ${medicationProvider.loadInProgress}');
        return medicationProvider.loadInProgress
            ? shimmer(width)
            : getSingleMedicationPlan(context, medicationProvider, position);
      }
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
            border: Border.all(color: Colors.grey[200]!)),
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

  Widget getSingleMedicationPlan(
      BuildContext context, MedicationProvider provider, int position) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ShadowContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF7ECA9C),
              Color(0xFF27B081),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  ShadowContainer(
                      radius: 8.0,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0)),
                          child: Row(
                            children: [
                              const Icon(Icons.alarm,
                                  size: 16, color: Color(0xFF0C909D)),
                              const SizedBox(width: 4.0),
                              Text(
                                  provider.medicationPlanResponseModel
                                          ?.data?[position].time
                                          ?.split(' | ')
                                          .last ??
                                      "",
                                  style: const TextStyle(
                                      color: Color(0xFF0C909D),
                                      fontSize: 14)),
                            ],
                          ))),
                  const SizedBox(width: 16.0),
                  Expanded(
                      child: Text(
                          provider.medicationPlanResponseModel
                                  ?.data?[position].time
                                  ?.split(' | ')
                                  .first ??
                              "",
                          style: const TextStyle(
                              color: kWhiteColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            provider.medicationPlanResponseModel
                                    ?.data?[position].medicineName ??
                                "",
                            style: const TextStyle(
                                color: kWhiteColor, fontSize: 24.0)),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                            provider.medicationPlanResponseModel
                                    ?.data?[position].note ??
                                "",
                            style: const TextStyle(
                                color: kWhiteColor, fontSize: 10))
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text("1 Pill",
                              style: TextStyle(
                                  color: kWhiteColor, fontSize: 20)),
                          Icon(FontAwesomeIcons.pills,
                              color: kWhiteColor, size: 36)
                        ],
                      ))
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        provider.isTaken[position] = !provider.isTaken[position];
                      });
                    },
                    child: ShadowContainer(
                        radius: 8.0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(Icons.favorite, size: 16, color: provider.isTaken[position] ? kRedColor : kDarkGreyColor),
                            const SizedBox(width: 4.0),
                            Text("TAKEN",
                                style:
                                    TextStyle(color: provider.isTaken[position] ? kRedColor : kDarkGreyColor, fontSize: 14))
                          ],
                        )),
                  ),
                ],
              )
            ],
          ),
          radius: 8),
    );
  }

  _showModalSheet(BuildContext context, MedicationProvider provider, Size size) {
    bool progress = false;

    _selectedTimeSlot = [];
    _selectedMedicationType = null;
    _everyday = false;
    _selectedDays = [false, false, false, false, false, false, false];

    _medicineETController.text = "";
    _noteETController.text = "";

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Container(
                  width: size.width,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 16.0,
                      left: 16.0,
                      right: 16.0),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Add New Medicine',
                          style: kLargerBlueTextStyle,
                        ),
                        const SizedBox(height: 8.0),
                        const Divider(
                          thickness: 1,
                          color: kDarkGreyColor,
                        ),
                        const SizedBox(height: 16.0),
                        dropDown(provider),
                        const SizedBox(height: 16.0),
                        medicineTextField(_medicineETController),
                        const SizedBox(height: 24.0),
                        daySelect(setState, size.width),
                        const SizedBox(height: 24.0),
                        timeSlot(setState),
                        const SizedBox(height: 24.0),
                        noteTextField(_noteETController),
                        const SizedBox(height: 16.0),
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                          child: progress
                              ? const Center(child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(color: kOrangeColor),
                          ))
                              : WidgetFactory.buildButton(
                              context: context,
                              child: const Text("SAVE", style: kButtonTextStyle),
                              backgroundColor: kDeepBlueColor,
                              borderRadius: 16.0,
                              onPressed: () async {
                                if(!_form.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Please enter required data"),
                                        duration: Duration(seconds: 1),
                                      ));
                                  return;
                                }
                                if (_selectedMedicationType == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content:
                                        Text("Please select a medication type"),
                                    duration: Duration(seconds: 1),
                                  ));
                                  return;
                                }
                                var selectedDayStrings = [];
                                for (int i = 0; i < 7; i++) {
                                  if (_selectedDays[i]) {
                                    selectedDayStrings.add(_days[i]);
                                  }
                                }
                                if (selectedDayStrings.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Please select a day at least"),
                                    duration: Duration(seconds: 1),
                                  ));
                                  return;
                                }
                                if (_selectedTimeSlot.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Please select a time"),
                                    duration: Duration(seconds: 1),
                                  ));
                                  return;
                                }
                                setState(() => progress = true);
                                final _responseResult = await provider
                                    .addMedicationPlan(
                                        _selectedMedicationType!,
                                        _medicineETController.text.toString(),
                                        _noteETController.text.toString(),
                                        selectedDayStrings,
                                        _selectedTimeSlot);
                                setState(() => progress = false);
                                if (_responseResult) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("Medication added successfully"),
                                    duration: Duration(seconds: 1),
                                  ));
                                  Navigator.pop(context);
                                  provider.getMedicationPlans();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        provider.errorResponse.message ??
                                            "Network error"),
                                    duration: const Duration(seconds: 1),
                                  ));
                                }
                              }),
                        ),
                        const SizedBox(height: 16.0)
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  Widget daySelect(setState, double width) {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          singleDay('Everyday', 1, setState),
          const SizedBox(width: 8.0),
          singleDay("S", 2, setState),
          const SizedBox(width: 8.0),
          singleDay("S", 3, setState),
          const SizedBox(width: 8.0),
          singleDay("M", 4, setState),
          const SizedBox(width: 8.0),
          singleDay("T", 5, setState),
          const SizedBox(width: 8.0),
          singleDay("W", 6, setState),
          const SizedBox(width: 8.0),
          singleDay("T", 7, setState),
          const SizedBox(width: 8.0),
          singleDay("F", 8, setState),
          const SizedBox(width: 8.0),
        ],
      ),
    );
  }

  Widget singleDay(String day, int position, setModalState) {
    return Expanded(
        flex: position == 1 ? 3 : 1,
        child: InkWell(
          onTap: () {
            if (position == 1) {
              setModalState(() {
                _everyday = !_everyday;
                for (int i = 0; i < 7; i++) {
                  _selectedDays[i] = _everyday;
                }
              });
            } else {
              setModalState(() {
                if (_selectedDays[position - 2]) _everyday = false;
                _selectedDays[position - 2] = !_selectedDays[position - 2];
              });
            }
          },
          child: ShadowContainer(
              color: position == 1
                  ? (_everyday ? kDeepBlueColor : kWhiteColor)
                  : (_selectedDays[position - 2]
                      ? kDeepBlueColor
                      : kWhiteColor),
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Text(day,
                  style: TextStyle(
                      color: position == 1
                          ? (_everyday ? kWhiteColor : kDeepBlueColor)
                          : (_selectedDays[position - 2]
                              ? kWhiteColor
                              : kDeepBlueColor),
                      fontSize: 12.0),
                  textAlign: TextAlign.center),
              radius: 4.0),
        ));
  }

  Widget timeSlot(setModalState) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                child: singleTimeSlot(
                    "Morning, Before Breakfast | 9:30 AM", setModalState)),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: singleTimeSlot(
                    "Morning, After Breakfast | 10:30 AM", setModalState))
          ],
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                child: singleTimeSlot(
                    "Noon, Before Lunch | 1:30 AM", setModalState)),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: singleTimeSlot(
                    "Noon, After Lunch | 2:30 AM", setModalState))
          ],
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                child: singleTimeSlot(
                    "Night, Before Dinner | 9:30 PM", setModalState)),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: singleTimeSlot(
                    "Night, After Dinner | 10:30 PM", setModalState))
          ],
        )
      ],
    );
  }

  Widget singleTimeSlot(String time, setModalState) {
    return InkWell(
      onTap: () {
        setModalState(() {
          if(_selectedTimeSlot.contains(time)) {
            _selectedTimeSlot.remove(time);
          } else {
            _selectedTimeSlot.add(time);
          }
          LogDebugger.instance.d('time: $_selectedTimeSlot');
        });
      },
      child: ShadowContainer(
        radius: 8.0,
        color: _selectedTimeSlot.contains(time) ? kDeepBlueColor : kWhiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Center(
            child: Text(time,
                style: TextStyle(
                    color: _selectedTimeSlot.contains(time)
                        ? kWhiteColor
                        : kDeepBlueColor,
                    fontSize: 12))),
      ),
    );
  }

  Widget dropDown(MedicationProvider provider) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 6.0),
          child: ShadowContainer(
            radius: 8.0,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonFormField<MedicationType>(
              isDense: true,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(233, 241, 255, 1.0))),
                contentPadding: EdgeInsets.only(left: 8.0),
              ),
              hint: const Text("Select Medication Type"),
              items: provider.medicationTypeResponseModel?.data
                  ?.map<DropdownMenuItem<MedicationType>>((val) {
                return DropdownMenuItem(
                    value: val, child: Text(val.medicationType ?? ""));
              }).toList(),
              onTap: () {},
              onChanged: (MedicationType? value) {
                if (value?.medicationType != null) {
                  _selectedMedicationType = value?.medicationType;
                }
              },
              icon: const Icon(Icons.arrow_drop_down_sharp, color: Colors.grey),
            ),
          ),
        ),
        Container(
            color: kWhiteColor,
            margin: const EdgeInsets.only(left: 14.0),
            child: const Text("Medication Type",
                style: TextStyle(
                    color: kDeepBlueColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600))),
      ],
    );
  }

  Widget medicineTextField(TextEditingController controller) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ]),
      child: TextFormField(
        validator: (value) {
          return value!.isEmpty ? 'The field is empty' : null;
        },
        controller: controller,
        cursorColor: kBlackColor,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          contentPadding:
              EdgeInsets.only(right: 8.0, left: 16.0, bottom: 16.0, top: 8.0),
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Medicine Name',
          labelStyle: kTitleTextStyle,
          hintText: 'Enter Medicine Name',
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
      ),
    );
  }

  Widget noteTextField(TextEditingController controller) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ]),
      child: TextFormField(
        maxLines: 2,
        maxLength: 200,
        controller: controller,
        cursorColor: kBlackColor,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          contentPadding:
              EdgeInsets.only(right: 8.0, left: 16.0, bottom: 16.0, top: 8.0),
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Note',
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
      ),
    );
  }
}
