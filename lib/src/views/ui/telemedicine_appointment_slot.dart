import 'package:dpr_patient/src/business_logics/models/slot_data_model.dart';
import 'package:dpr_patient/src/business_logics/providers/doctor_details_provider.dart';
import 'package:dpr_patient/src/views/ui/telemedicine_patient_details.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/custom_calender.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TelemedicineAppointmentSlot extends StatefulWidget {
  final int id;
  const TelemedicineAppointmentSlot({Key? key, required this.id}) : super(key: key);

  @override
  State<TelemedicineAppointmentSlot> createState() => _TelemedicineAppointmentSlotState();
}

class _TelemedicineAppointmentSlotState extends State<TelemedicineAppointmentSlot> {

  int? _selectedTimeSlot;
  DateTime selectedDate = DateTime.now();
  String _date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  late DateTime today;
  late String _timeSlotTxt;
  int _selectedMethod = 0;

  var expiredSlotList = [];

  @override
  void initState() {
    super.initState();
    today = DateFormat('yyyy-MM-dd').parse(_date);
    DoctorDetailsProvider doctorDetailsProvider = Provider.of<DoctorDetailsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      doctorDetailsProvider.getDoctorDetails(id: widget.id, type: "telemedicine");
      selectedDate = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      _date = formatter.format(selectedDate);
      doctorDetailsProvider.getSlotList(
          doctor: doctorDetailsProvider.doctorDetailsModel?.data?.personNoPk ?? 0,
          chamber: 0,
          date: _date,
          type: "telemedicine"
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DoctorDetailsProvider doctorDetailsProvider = Provider.of<DoctorDetailsProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: const Text("Book Appointment", style: kAppBarGreenTitleTextStyle),
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: HeaderInfo(),
              ),
              const SizedBox(height: 16.0),
              Divider(
                thickness: 1,
                height: .05,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 24.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Select Date",
                    style: kLargerTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ]),
                  child: CustomWeekViewCalendar(
                    selectedDayBackgroundColor: kMediumGreenColor,
                    bodyHeight: 100.0,
                    currentDate: DateTime.now(),
                    dateCallback: (date) => {
                      selectedDate = date,
                      _date = date.toString(),
                      doctorDetailsProvider.getSlotList(
                        doctor: doctorDetailsProvider.doctorDetailsModel?.data?.personNoPk ?? 0,
                        chamber: 0,
                        date: _date,
                        type: "telemedicine"
                      )
                    },
                    typeCollapse: true,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              doctorDetailsProvider.slotResponseModel?.data == null
                  ? Container()
                  : (doctorDetailsProvider.slotResponseModel!.data!.isEmpty
                  ? const Center(
                child: Text("No Slot available!"),
              )
              : const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Select Slot",
                    style: kLargerTextStyle),
              )),
              const SizedBox(height: 16.0),
              doctorDetailsProvider.slotInProgress
              ? const Center(child: CircularProgressIndicator())
              : (doctorDetailsProvider.slotResponseModel?.data == null
              ? Container()
              : DateFormat('yyyy-MM-dd').parse(_date) == today && expiredSlotList.isNotEmpty && expiredSlotList.length == doctorDetailsProvider.slotResponseModel?.data?.length
                  ? const Center(child: Text("All slots has expired "))
                  : Container(
                color: kWhiteColor,
                width: size.width,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, position) => getSlot(doctorDetailsProvider.slotResponseModel?.data?[position] ?? Slot()),
                    separatorBuilder: (context, position) => const SizedBox(width: 8.0),
                    itemCount: doctorDetailsProvider.slotResponseModel?.data?.length ?? 0
                ),
              )),
              const SizedBox(height: 24.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Preferred Mode",
                    style: kLargerTextStyle),
              ),
              const SizedBox(height: 16.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ShadowContainer(
                        radius: 32.0,
                        child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.call),
                              ),
                              const Text("Voice Call"),
                              Checkbox(
                                onChanged: (value) {
                                  setState(() {
                                    _selectedMethod = 1;
                                  });
                                  doctorDetailsProvider.getSlotList(
                                      doctor: doctorDetailsProvider.doctorDetailsModel?.data?.personNoPk ?? 0,
                                      chamber: 0,
                                      date: _date,
                                      type: "telemedicine"
                                  );
                                },
                                value: _selectedMethod == 1)
                            ]
                        )
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShadowContainer(
                              radius: 32.0,
                              child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Icon(Icons.call),
                                    ),
                                    const Text("Video Call"),
                                    Checkbox(
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedMethod = 2;
                                        });
                                        doctorDetailsProvider.getSlotList(
                                            doctor: doctorDetailsProvider.doctorDetailsModel?.data?.personNoPk ?? 0,
                                            chamber: 0,
                                            date: _date,
                                            type: "telemedicine"
                                        );
                                      },
                                      value: _selectedMethod == 2
                                    )
                                  ]
                              )
                          )
                        ]
                    ),
                  ]
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 32.0),
                  Container(
                    decoration: BoxDecoration(
                        color: doctorDetailsProvider.inProgress ? kLightGreyColor : kMediumGreenColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            bottomLeft: Radius.circular(24.0)
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                      child: IconButton(
                        onPressed: doctorDetailsProvider.inProgress
                            ? () {}
                            : () {
                          if(_selectedMethod == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select a Method"),
                                  duration: Duration(seconds: 1),
                                ));
                          } else if(_selectedTimeSlot == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select a time slot"),
                                  duration: Duration(seconds: 1),
                                ));
                          } else {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>
                                TelemedicinePatientDetails(
                                  date: _date,
                                  doctorFkNo: doctorDetailsProvider
                                      .doctorDetailsModel?.data?.personNoPk ?? 0,
                                  doctorFee: doctorDetailsProvider.doctorDetailsModel?.data?.visitingFee ?? '0',
                                  reportFee: doctorDetailsProvider.doctorDetailsModel?.data?.reportingFee ?? '0',
                                  slotNoPk: _selectedTimeSlot ?? 0,
                                  slotTxt: _timeSlotTxt,
                                  preferredMethod: _selectedMethod,
                                  name:doctorDetailsProvider.doctorDetailsModel?.data?.fullName,
                                  expertise:doctorDetailsProvider.doctorDetailsModel?.data?.specialtyString,
                                  degree:doctorDetailsProvider.doctorDetailsModel?.data?.qualificationString,
                                  image:doctorDetailsProvider.doctorDetailsModel?.data?.photoName,
                                )));
                          }
                        },
                        icon: const Center(child: Icon(Icons.arrow_forward_ios_rounded, color: kWhiteColor, size: 32.0)),
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
                              color: kMediumGreenColor,
                              borderRadius: BorderRadius.all(Radius.circular(4.0))
                          )
                      ),
                      const SizedBox(width: 16.0),
                      Container(
                          width: 48.0,
                          height: 4.0,
                          decoration: const BoxDecoration(
                              color: kLightGreyColor,
                              borderRadius: BorderRadius.all(Radius.circular(4.0))
                          )
                      ),
                      const SizedBox(width: 16.0),
                      Container(
                          width: 48.0,
                          height: 4.0,
                          decoration: const BoxDecoration(
                              color: kLightGreyColor,
                              borderRadius: BorderRadius.all(Radius.circular(4.0))
                          )
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0)
                ],
              ),
              const SizedBox(height: 16.0)
            ],
          ),
        ),
      ),
    );
  }

  Widget getSlot(Slot? slot) {
    String strDate = DateFormat('yyyy-MM-dd hh:mm a').format(selectedDate);
    DateTime selectedDT = DateFormat('yyyy-MM-dd hh:mm a').parse(strDate);
    DateTime dtS = DateFormat('yyyy-MM-dd hh:mm').parse('${_date.split(' ').first} ${slot?.startTime}');
    String dtSStr = DateFormat('yyyy-MM-dd hh:mm a').format(dtS);
    DateTime dtStart = DateFormat('yyyy-MM-dd hh:mm a').parse(dtSStr);
    DateTime dtE = DateFormat('yyyy-MM-dd hh:mm a').parse('${_date.split(' ').first} ${slot?.endTime}');
    String dtEStr = DateFormat('yyyy-MM-dd hh:mm a').format(dtE);
    DateTime dtEnd = DateFormat('yyyy-MM-dd hh:mm a').parse(dtEStr);
    DateTime now = DateTime.now();
    String nowStr = DateFormat('yyyy-MM-dd').format(now);
    DateTime date = DateFormat('yyyy-MM-dd').parse(nowStr);
    DateTime dateTimeFormat = DateFormat('yyyy-MM-dd').parse(strDate);
    if (dateTimeFormat.isAfter(date) || dateTimeFormat.isBefore(date) || selectedDT.isBefore(dtEnd) || selectedDT.isAtSameMomentAs(dtEnd)) {
      return InkWell(
      onTap: () {
        setState(() {
            _selectedTimeSlot = slot?.scheduleNoPk;
            _timeSlotTxt = '${slot?.startTime} - ${slot?.endTime}';
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: _selectedTimeSlot == slot?.scheduleNoPk ? kMediumGreenColor : kWhiteColor,
          border: Border.all(color: kLightGreyColor),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: const [
            BoxShadow(
              color: kDarkGreyColor,
              spreadRadius: 0.1,
              blurRadius: 0.1,
              offset: Offset(0, 0.1),
            )
          ],
        ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Center(child: Text((slot?.startTime ?? "") + " - " + (slot?.endTime ?? ""), style: TextStyle(color: _selectedTimeSlot == slot?.scheduleNoPk ? kWhiteColor : kMediumGreenColor)))
      ),
    );
    } else {
      if(!(expiredSlotList.contains(slot?.scheduleNoPk))) {
        expiredSlotList.add(slot?.scheduleNoPk);
      }
      return const Text('');
    }
  }
}

class HeaderInfo extends StatelessWidget {

  const HeaderInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DoctorDetailsProvider provider = Provider.of<DoctorDetailsProvider>(context);
    return Row(
      children: [
        WidgetFactory.buildProfileAvatar(
            context: context,
            url: provider.doctorDetailsModel?.data?.photoName ?? "assets/images/person.png",
            userName: provider.doctorDetailsModel?.data?.fullName ?? "",
            imageType: provider.doctorDetailsModel?.data?.photoName == null ? ImageType.Asset : ImageType.Network,
            radius: 80
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.doctorDetailsModel?.data?.fullName ?? "",
                style: kTitleTextStyle,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  provider.doctorDetailsModel?.data?.specialtyString ?? "",
                  style: kSubTitleTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  provider.doctorDetailsModel?.data?.qualificationString ?? "",
                  style: kSubTitleTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  provider.doctorDetailsModel?.data?.designationString ?? "",
                  style: kSubTitleTextStyle,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.payment,size: 12,),
                      const SizedBox(width: 2.0),
                      const Text(
                        "Visiting Fee: ",
                        style: TextStyle(color: kMediumBlueColor, fontSize: 12),
                      ),
                      const SizedBox(width: 2.0),
                      Text(
                        "${(provider.doctorDetailsModel?.data?.visitingFee ?? 0)} TK",
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: kOrangeColor,
                            letterSpacing: 0.2
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      const Icon(
                        Icons.info,
                        color: Colors.blue,
                        size: 12,
                      ),
                    ],
                  )),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 30,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_outline,
                  size: 30,
                  color: Colors.grey,
                )),
          ],
        ),
      ],
    );
  }
}
