import 'package:dpr_patient/src/business_logics/models/chamber_data_model.dart';
import 'package:dpr_patient/src/business_logics/models/slot_data_model.dart';
import 'package:dpr_patient/src/business_logics/providers/doctor_details_provider.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/views/ui/patient_details.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/custom_calender.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentSlot extends StatefulWidget {

  final int id;

  const AppointmentSlot({Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<AppointmentSlot> createState() => _AppointmentSlotState();
}

class _AppointmentSlotState extends State<AppointmentSlot> {

  int? _selectedTimeSlot;
  int? _selectedChamberFkNo;
  DateTime selectedDate = DateTime.now();
  late String _date, _timeSlotTxt, _chamberHospitalName;
  late DateTime today;

  var expiredSlotList = [];

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    _date = formatter.format(selectedDate);
    today = DateFormat('yyyy-MM-dd').parse(_date);
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
        title: const Text("Book Appointment", style: kAppBarBlueTitleTextStyle),
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: doctorDetailsProvider.inProgress
                  ? shimmer(size.width)
                  : const Header(),
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
                    selectedDayBackgroundColor: kMediumBlueColor,
                    bodyHeight: 100.0,
                    currentDate: DateTime.now(),
                    dateCallback: (date) => {
                      selectedDate = date,
                      _date = date.toString(),
                      doctorDetailsProvider.getSlotList(
                        doctor: doctorDetailsProvider.doctorDetailsModel?.data?.personNoPk ?? 0,
                        chamber: _selectedChamberFkNo,
                        date: date.toString(),
                        type: "chamber"
                      ),
                      LogDebugger.instance.d('date: $date')
                    },
                    typeCollapse: true,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Select Chamber",
                    style: kLargerTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ShadowContainer(
                  radius: 8.0,
                  child: SizedBox(
                    width: double.infinity,
                    child: DropdownButtonFormField<Chambers>(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(right: 5, left: 20),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      hint: const Text(
                        "Please select a chamber",
                        style: TextStyle(color: Color(0xFFCBCBCB)),
                      ),
                      items: doctorDetailsProvider.chamberResponseModel?.data?.map<DropdownMenuItem<Chambers>>((val) {
                        return DropdownMenuItem(value: val, child: Text(val.chamberName ?? ""));
                      }).toList(),
                      onTap: () {},
                      onChanged: (Chambers? value) {
                        if(value?.chamberNoPk != null) {
                          _selectedChamberFkNo = value?.chamberNoPk ?? 0;
                          _chamberHospitalName = value?.chamberName ?? '';
                          doctorDetailsProvider.getSlotList(
                              doctor: doctorDetailsProvider.doctorDetailsModel?.data?.personNoPk ?? 0,
                              chamber: _selectedChamberFkNo,
                              date: _date,
                              type: "chamber"
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                        size: 25.0,
                      ),
                    ),
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
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 32.0),
                  Container(
                    decoration: BoxDecoration(
                        color: doctorDetailsProvider.inProgress ? kLightGreyColor : kMediumBlueColor,
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
                          if(_selectedChamberFkNo == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select a chamber"),
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
                                PatientDetails(
                                  slotNoPk: _selectedTimeSlot ?? 0,
                                  slotTxt: _timeSlotTxt,
                                  chamberFkNo: _selectedChamberFkNo,
                                  chamberHospitalName: _chamberHospitalName,
                                  date: _date,
                                  doctorFkNo: doctorDetailsProvider
                                      .doctorDetailsModel?.data?.personNoPk ?? 0,
                                  doctorFee: doctorDetailsProvider
                                      .doctorDetailsModel?.data?.visitingFee ?? '0',
                                  reportingFee: doctorDetailsProvider.doctorDetailsModel?.data?.reportingFee ?? '0',
                                  name: doctorDetailsProvider.doctorDetailsModel?.data?.fullName,
                                  expertise: doctorDetailsProvider.doctorDetailsModel?.data?.specialtyString ?? '',
                                  degree: doctorDetailsProvider.doctorDetailsModel?.data?.qualificationString  ?? '',
                                  image: doctorDetailsProvider.doctorDetailsModel?.data?.photoName,
                                ))
                            );
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
                              color: kMediumBlueColor,
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
      child: SizedBox(
        height: 30,
        child: ShadowContainer(
            radius: 16.0,
            color: _selectedTimeSlot == slot?.scheduleNoPk ? kMediumBlueColor : kWhiteColor,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Center(child: Text((slot?.startTime ?? "") + " - " + (slot?.endTime ?? ""), style: TextStyle(color: _selectedTimeSlot == slot?.scheduleNoPk ? kWhiteColor : kMediumBlueColor)))
        ),
      ),
    );
    } else {
      if(!(expiredSlotList.contains(slot?.scheduleNoPk))) {
        expiredSlotList.add(slot?.scheduleNoPk);
      }
      return const Text('');
    }
  }

  Widget shimmer(width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 130, height: 15, color: Colors.grey[200]),
                  const SizedBox(height: 4.0),
                  Container(width: 100, height: 15, color: Colors.grey[200]),
                  const SizedBox(height: 4.0),
                  Container(width: 180, height: 15, color: Colors.grey[200]),
                  const SizedBox(height: 4.0),
                  Container(width: 150, height: 15, color: Colors.grey[200]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DoctorDetailsProvider provider = Provider.of<DoctorDetailsProvider>(context);
    return Row(
      children: [
        WidgetFactory.buildProfileAvatar(
            context: context,
            url: provider.doctorDetailsModel?.data?.photoName ?? "assets/images/person.png",
            userName: provider.doctorDetailsModel?.data?.fullName ?? "User",
            imageType: provider.doctorDetailsModel?.data?.photoName == null || provider.doctorDetailsModel?.data?.photoName == '' ? ImageType.Asset : ImageType.Network,
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
                        "${(provider.doctorDetailsModel?.data?.visitingFee ?? 0)} Tk",
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
                onPressed: provider.isFavSetting ? () {}
                    : () async {
                  await provider.setFavDoc(
                      doctor: provider.doctorDetailsModel?.data?.personNoPk ?? 0,
                      isFav: ((provider.doctorDetailsModel?.data?.docFavInd ?? 0) == 1) ? 0 : 1
                  ).then((value) {
                    provider.getDoctorDetails(id: provider.doctorDetailsModel?.data?.personNoPk ?? 0, type: "chamber");
                  });
                },
                icon: Icon(
                  (provider.doctorDetailsModel?.data?.docFavInd ?? 0) == 1 ? Icons.favorite : Icons.favorite_outline,
                  size: 30,
                  color: (provider.doctorDetailsModel?.data?.docFavInd ?? 0) == 1 ? Colors.red : Colors.grey,
                )
            ),
          ],
        ),
      ],
    );
  }
}
