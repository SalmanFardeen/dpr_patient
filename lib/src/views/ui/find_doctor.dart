import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dpr_patient/src/business_logics/providers/in_person_visit_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/patient_info_provider.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/views/ui/book_appointment.dart';
import 'package:dpr_patient/src/views/ui/recent_appointment_details.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FindDoctor extends StatefulWidget {
  const FindDoctor({Key? key}) : super(key: key);

  @override
  State<FindDoctor> createState() => _FindDoctorState();
}

class _FindDoctorState extends State<FindDoctor> {
  final _searchETController = TextEditingController();

  late InPersonVisitProvider inPersonVisitProvider;
  bool _nearbyFilterSelected = false;
  bool _telemedicineFilterSelected = false;

  @override
  void initState() {
    super.initState();
    inPersonVisitProvider = Provider.of<InPersonVisitProvider>(context, listen: false);
    // if (inPersonVisitProvider.inProgress && !inPersonVisitProvider.inSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) => inPersonVisitProvider.getInPersonVisitDoctorList(type: "chamber"));
    // }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    InPersonVisitProvider inPersonVisitProvider =
        Provider.of<InPersonVisitProvider>(context);

    final _debouncer = Debouncer(milliseconds: 200);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: const Text("In Person visit", style: kAppBarBlueTitleTextStyle),
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(height: 15),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ShadowContainer(
              radius: 16,
              child: WidgetFactory.buildPrefixPasswordField(
                context: context,
                onChanged: (String string) {
                  // _debouncer.run(() {
                    LogDebugger.instance.d("Search string: $string");
                    inPersonVisitProvider.clearData();
                    if (string.isEmpty) {
                      // inPersonVisitProvider.clearData();
                      return;
                    }
                    inPersonVisitProvider.getInPersonVisitDoctorSearch(string);
                  // });
                },
                validator: (val) {
                  return null;
                },
                obscurePassword: false,
                label: "",
                hint: "Eg: Speciality, Diseases, Area, Hospital",
                suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.mic,
                      color: kDeepBlueColor,
                    )),
                backgroundColor: kWhiteColor,
                textColor: Colors.black,
                borderRadius: 16,
                borderColor: kDarkGreyColor,
                controller: _searchETController,
                onPressed: () {},
                prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: kDeepBlueColor,
                    )),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ShadowContainer(
                    radius: 20,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Nearby Doctors",
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                                value: _nearbyFilterSelected,
                                onChanged: (value) {
                                  inPersonVisitProvider.clearData();
                                  if(!_nearbyFilterSelected) {
                                    if(_telemedicineFilterSelected) {
                                      setState(() {
                                        _telemedicineFilterSelected = false;
                                      });
                                    }
                                    inPersonVisitProvider.getNearbyDoctor(0, 0);
                                  }
                                  setState(() {
                                    _nearbyFilterSelected = !_nearbyFilterSelected;
                                  });
                                }
                            ),
                          )
                        ],
                      ),
                    )
                ),
                ShadowContainer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: Row(
                        children: [
                          const Text(
                            "Live Doctors",
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                                value: _telemedicineFilterSelected,
                                onChanged: (value) {
                                  inPersonVisitProvider.clearData();
                                  if(!_telemedicineFilterSelected) {
                                    if(_nearbyFilterSelected) {
                                      setState(() {
                                        _nearbyFilterSelected = false;
                                      });
                                    }
                                    inPersonVisitProvider.getOnlineDoctor();
                                  }
                                  setState(() {
                                    _telemedicineFilterSelected = !_telemedicineFilterSelected;
                                  });
                                }),
                          )
                        ],
                      ),
                    ),
                    radius: 20
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          inPersonVisitProvider.inSearch
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          inPersonVisitProvider.inProgress
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${inPersonVisitProvider.inPersonVisitSearchModel?.data?.length ?? 0} Doctors Found",
                                      style: kLargerTextStyle,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          inPersonVisitProvider.clearData();
                                          _searchETController.text = "";
                                          _nearbyFilterSelected = false;
                                          _telemedicineFilterSelected = false;
                                          FocusScope.of(context).requestFocus(FocusNode());
                                        },
                                        icon: const Icon(Icons.close))
                                  ],
                                ),
                          const SizedBox(height: 8),
                          ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                LogDebugger.instance.d('in person visit progress: ${inPersonVisitProvider.inPersonVisitSearchModel}');
                                return (inPersonVisitProvider.inPersonVisitSearchModel?.data?.length ?? 0) == 0
                                    ? topRatedDoctorShimmer(size.width)
                                    : FindDoctorCard(
                                        personNoPk: inPersonVisitProvider.inPersonVisitSearchModel?.data?[index].personNoPk,
                                        image: inPersonVisitProvider.inPersonVisitSearchModel?.data?[index].photoName,
                                        name: inPersonVisitProvider.inPersonVisitSearchModel?.data?[index].fullName,
                                        qualification: inPersonVisitProvider.inPersonVisitSearchModel?.data?[index].qualificationString,
                                        designation: inPersonVisitProvider.inPersonVisitSearchModel?.data?[index].designation,
                                        specialty: inPersonVisitProvider.inPersonVisitSearchModel?.data?[index].specialtyString,
                                        experience: inPersonVisitProvider.inPersonVisitSearchModel?.data?[index].experience,
                                        chamber: inPersonVisitProvider.inPersonVisitSearchModel?.data?[index].chamberName,
                                        visitingFee: inPersonVisitProvider.inPersonVisitSearchModel?.data?[index].visitingFee,
                                      );
                              },
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 15),
                              itemCount: inPersonVisitProvider
                                      .inPersonVisitSearchModel?.data?.length ??
                                  0),
                        ],
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      return Future.delayed(const Duration(seconds: 1), () async {
                        inPersonVisitProvider.getInPersonVisitDoctorList(type: "chamber");
                      });
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              "Specialties",
                              style: kLargerTextStyle,
                            ),
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: inPersonVisitProvider
                                          .inPersonVisitModel
                                          ?.data
                                          ?.specialities
                                          ?.length ??
                                      0,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        inPersonVisitProvider
                                            .getInPersonVisitDoctorSearch(
                                                inPersonVisitProvider
                                                        .inPersonVisitModel
                                                        ?.data
                                                        ?.specialities?[index]
                                                        .name ??
                                                    "");
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 8.0,
                                            top: 8.0,
                                            bottom: 8.0,
                                            left: 2),
                                        width: 120,
                                        child: inPersonVisitProvider.inPersonVisitModel?.data?.specialities == null
                                        ? specialityShimmer(size.width)
                                        : SingleSpeciality(
                                            image: inPersonVisitProvider.inPersonVisitModel?.data?.specialities?[index].image,
                                            title: inPersonVisitProvider.inPersonVisitModel?.data?.specialities?[index].name
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            ),
                            const SizedBox(height: 16),
                            if((inPersonVisitProvider.inPersonVisitModel?.data?.recentAppointments?.length ?? 0) > 0)...[
                            const Text(
                              "Recent Appointment",
                              style: kLargerTextStyle,
                            ),
                            SizedBox(
                              height: 180,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: inPersonVisitProvider.inPersonVisitModel?.data?.recentAppointments?.length ?? 0,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.only(
                                          right: 8.0,
                                          top: 8.0,
                                          bottom: 8.0,
                                          left: 2
                                      ),
                                      width: 200,
                                      child: (inPersonVisitProvider
                                                      .inPersonVisitModel
                                                      ?.data
                                                      ?.recentAppointments
                                                      ?.length ??
                                                  0) ==
                                              0
                                          ? recentAppointmentShimmer(size.width)
                                          : SingleReAppointment(
                                              width: size.width,
                                              image: inPersonVisitProvider
                                                  .inPersonVisitModel
                                                  ?.data
                                                  ?.recentAppointments?[index]
                                                  .image,
                                              name: inPersonVisitProvider
                                                  .inPersonVisitModel
                                                  ?.data
                                                  ?.recentAppointments?[index]
                                                  .name,
                                              specialty: inPersonVisitProvider
                                                  .inPersonVisitModel
                                                  ?.data
                                                  ?.recentAppointments?[index]
                                                  .specialtyString,
                                                    id: inPersonVisitProvider
                                                        .inPersonVisitModel
                                                        ?.data
                                                        ?.recentAppointments?[
                                                            index]
                                                        .appointNoPk,
                                                  ),
                                    );
                                  }),
                            )],
                            const SizedBox(height: 16),
                            const Text(
                              "Top Rated Doctors",
                              style: kLargerTextStyle,
                            ),
                            const SizedBox(height: 8),
                            (inPersonVisitProvider.inPersonVisitModel?.data?.topRatedDoctors?.length ?? 0) > 0 ? ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return (inPersonVisitProvider
                                                  .inPersonVisitModel
                                                  ?.data
                                                  ?.topRatedDoctors
                                                  ?.length ??
                                              0) ==
                                          0
                                      ? topRatedDoctorShimmer(size.width)
                                      : FindDoctorCard(
                                          personNoPk: inPersonVisitProvider.inPersonVisitModel?.data?.topRatedDoctors?[index].personNoPk,
                                          image: inPersonVisitProvider.inPersonVisitModel?.data?.topRatedDoctors?[index].photoName,
                                          name: inPersonVisitProvider.inPersonVisitModel?.data?.topRatedDoctors?[index].fullName,
                                          qualification: inPersonVisitProvider.inPersonVisitModel?.data?.topRatedDoctors?[index].qualificationString,
                                          designation: inPersonVisitProvider.inPersonVisitModel?.data?.topRatedDoctors?[index].designation,
                                          specialty: inPersonVisitProvider.inPersonVisitModel?.data?.topRatedDoctors?[index].specialtyString,
                                          experience: inPersonVisitProvider.inPersonVisitModel?.data?.topRatedDoctors?[index].experience,
                                          chamber: inPersonVisitProvider.inPersonVisitModel?.data?.topRatedDoctors?[index].chamberName,
                                          visitingFee: inPersonVisitProvider.inPersonVisitModel?.data?.topRatedDoctors?[index].visitingFee
                                      );
                                },
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 15),
                                itemCount: inPersonVisitProvider
                                        .inPersonVisitModel
                                        ?.data
                                        ?.topRatedDoctors
                                        ?.length ??
                                    0) : const SizedBox(height: 80, child: Center(child: Text("No top rated doctors found"))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      )),
    );
  }

  Widget specialityShimmer(width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey[200]!)),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(height: 4.0),
            Container(width: 80, height: 20, color: Colors.grey[200]),
          ],
        ),
      ),
    );
  }

  Widget recentAppointmentShimmer(width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 200,
        height: 150,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey[200]!)),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(height: 4.0),
            Container(width: 80, height: 20, color: Colors.grey[200]),
            const SizedBox(height: 4.0),
            Container(width: 60, height: 20, color: Colors.grey[200]),
          ],
        ),
      ),
    );
  }

  Widget topRatedDoctorShimmer(width) {
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

  @override
  void dispose() {
    super.dispose();
    inPersonVisitProvider.clearData(isTrue: false);
  }
}

class SingleSpeciality extends StatelessWidget {
  final String? image;
  final String? title;

  const SingleSpeciality({Key? key, this.image, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      radius: 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: image == null
                ? const Image(
                    image: AssetImage("assets/images/icon_e_pathology.png"))
                : CachedNetworkImage(
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    imageUrl: image!,
                    placeholder: (context, url) => Image.asset(
                      'assets/images/loading.gif',
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: Text(title ?? "N\\A", style: kTitleTextStyle),
          )
        ],
      ),
    );
  }
}

class SingleReAppointment extends StatelessWidget {
  final double width;
  final String? image;
  final String? name;
  final String? specialty;
  final int? id;

  const SingleReAppointment({
    Key? key,
    required this.width,
    required this.image,
    required this.name,
    required this.specialty,
    required this.id,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PatientInfoProvider patientInfoProvider =
            Provider.of<PatientInfoProvider>(context, listen: false);
        patientInfoProvider.getAppointmentDetails(id ?? 0).then((value) {
          if (value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RecentAppointmentDetails(provider: patientInfoProvider)));
          }
        });
      },
      child: ShadowContainer(
        radius: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: WidgetFactory.buildProfileAvatar(
                  context: context,
                  url: image ?? "assets/images/person.png",
                  imageType: image != null
                      ? ImageType.Network
                      : ImageType.Asset,
                  userName: name ?? "N\\A",
                  radius: width / 5,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, left: 4, right: 4, bottom: 2),
              child: Text(name ?? "", style: kTitleTextStyle),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(specialty ?? "", style: kSubTitleTextStyle),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text('Appointment ID: ${id ?? 0}', style: kSubTitleTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDoctorCard extends StatelessWidget {

  final int? personNoPk;
  final String? image;
  final String? name;
  final String? qualification;
  final String? specialty;
  final String? experience;
  final designation;
  final String? chamber;
  final String? visitingFee;

  const FindDoctorCard({
    Key? key,
    required this.personNoPk,
    required this.image,
    required this.name,
    required this.qualification,
    required this.specialty,
    required this.experience,
    required this.designation,
    required this.chamber,
    required this.visitingFee
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.width / 2.5,
      child: ShadowContainer(
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Center(
                          child: WidgetFactory.buildProfileAvatar(
                            context: context,
                            url: image ?? 'assets/images/person.png',
                            imageType: image == null || image == '' ? ImageType.Asset : ImageType.Network,
                            userName: name ?? "Doctor",
                            radius: size.width / 6,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(specialty ?? "N\\A",
                              style: TextStyle(
                                fontSize: size.width / 34
                              ),
                              textAlign: TextAlign.center
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Container(
                        padding: const EdgeInsets.only(bottom: 0),
                        decoration: const BoxDecoration(
                            color: kMediumBlueColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text("${visitingFee ?? 0} TK",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: kWhiteColor, fontSize: size.width / 30)),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(name ?? "N\\A",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: size.width / 28,
                                  fontWeight: FontWeight.w500,
                                  color: kDeepBlueColor
                                )
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          const Icon(Icons.star, color: Colors.yellow),
                          const SizedBox(width: 8,)
                        ],
                      ),
                      Text(qualification ?? "N\\A",
                        style: TextStyle(
                            fontSize: size.width / 30,
                            color: Colors.grey[600]
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text("${int.parse(DateFormat('yyyy').format(DateTime.now())) - int.parse(experience ?? "0")} years of experience",
                          style: TextStyle(
                          fontSize: size.width / 30,
                          fontWeight: FontWeight.w500,
                          color: kDarkGreyColor
                        )
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 18,
                            color: kDeepBlueColor,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                              child: Text(chamber ?? "N/A",
                                  style: TextStyle(
                                      fontSize: size.width / 35,
                                      fontWeight: FontWeight.w500,
                                      color: kDeepBlueColor
                                  )
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.work,
                            size: 16,
                            color: kDeepBlueColor,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                              child: Text(
                                  "${designation?[0].designation ?? 'N/A'} at ${designation?[0].institution ?? 'N/A'}",
                                  style: TextStyle(
                                      fontSize: size.width / 35,
                                      fontWeight: FontWeight.w500,
                                      color: kDeepBlueColor
                                  )
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  )),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BookAppointment(id: personNoPk ?? 0)));
                  },
                  child: Container(
                    height: 200,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: kMediumBlueColor),
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      color: kWhiteColor,
                      size: 45,
                    ),
                  ),
                ),
              ),
            ],
          ),
          radius: 8),
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
