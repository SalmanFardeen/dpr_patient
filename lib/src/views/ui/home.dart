import 'package:dpr_patient/src/business_logics/models/user_location.dart';
import 'package:dpr_patient/src/business_logics/providers/nearby_doctor_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/telemedicine_doctor_provider.dart';
import 'package:dpr_patient/src/services/location_services/location_service.dart';
import 'package:dpr_patient/src/views/ui/book_appointment.dart';
import 'package:dpr_patient/src/views/ui/chat_list_screen.dart';
import 'package:dpr_patient/src/views/ui/find_doctor.dart';
import 'package:dpr_patient/src/views/ui/future_work.dart';
import 'package:dpr_patient/src/views/ui/telemedicine_book_appointment.dart';
import 'package:dpr_patient/src/views/ui/telemedicine_find_doctor.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocationService _locationService = LocationService();
  @override
  void initState() {
    super.initState();
    _locationService.getLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserLocation>(context, listen: false);
      // ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      NearbyDoctorProvider nearbyDoctorProvider = Provider.of<NearbyDoctorProvider>(context, listen: false);
      TelemedicineDoctorProvider telemedicineDoctorProvider = Provider.of<TelemedicineDoctorProvider>(context, listen: false);
      initApiCall(nearbyDoctorProvider, telemedicineDoctorProvider);
    });
  }

  initApiCall( NearbyDoctorProvider nearbyDoctorProvider, TelemedicineDoctorProvider telemedicineDoctorProvider) {
    double lat = 0, lon = 0;
    // profileProvider.getProfile();
    nearbyDoctorProvider.getNearbyDoctor(lat, lon);
    telemedicineDoctorProvider.getOnlineDoctor();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    Provider.of<UserLocation>(context);
    NearbyDoctorProvider nearbyDoctorProvider = Provider.of<NearbyDoctorProvider>(context);
    TelemedicineDoctorProvider telemedicineDoctorProvider = Provider.of<TelemedicineDoctorProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        title: profileProvider.profileModel?.data?.profile?.patientName == null
        ? const Text("DPR", style: kAppBarBlueTitleTextStyle)
        : ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            profileProvider.profileModel?.data?.profile?.patientName ?? "",
            style: const TextStyle(color: kDeepBlueColor),
          ),
          subtitle: profileProvider.profileModel?.data?.profile?.address != null
          ? Row(children: [
            const Icon(
              Icons.place,
              size: 15,
              color: kDarkGreyColor,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                profileProvider.profileModel?.data?.profile?.address ?? "",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: kDeepBlueColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ]) :  _locationService.placemarks.length > 0
              ? Row(children: [
            const Icon(
              Icons.place,
              size: 15,
              color: kDarkGreyColor,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                profileProvider.profileModel?.data?.profile?.address ?? _locationService.placemarks.last.street ?? "",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: kDeepBlueColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ]) : Container(),
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
            initApiCall(nearbyDoctorProvider, telemedicineDoctorProvider);
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeBanner(
                  bannerTitle: 'Get an appointment',
                  bannerParagraph:
                      'We are committed towards being the most trusted provider of Health Care. Book an appointment now as low as 11tk!',
                  width: size.width,
                  image: "assets/images/image_banner.png"),
              SizedBox(
                width: size.width,
                height: size.width * 0.7,
                child: GridView.extent(
                  physics: const NeverScrollableScrollPhysics(),
                  primary: false,
                  padding: const EdgeInsets.all(16),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  maxCrossAxisExtent: size.width / 3.3,
                  children: <Widget>[
                    option(
                      context: context,
                      width: size.width,
                      title: 'In Person Visit',
                      image: 'assets/images/icon_in_person_visit.png',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const FindDoctor()));
                      },
                    ),
                    option(
                      context: context,
                      width: size.width,
                      title: 'Telemedicine',
                      image: 'assets/images/icon_telemedicine.png',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TelemedicineFindDoctor()));
                      },
                    ),
                    option(
                      context: context,
                      width: size.width,
                      title: 'Home Doctor',
                      image: 'assets/images/icon_home_doctor.png',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FutureWork()));
                      },
                    ),
                    option(
                      context: context,
                      width: size.width,
                      title: 'Blood Bank',
                      image: 'assets/images/icon_blood_bank.png',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FutureWork()));
                      },
                    ),
                    option(
                      context: context,
                      width: size.width,
                      title: 'Ambulance',
                      image: 'assets/images/icon_ambulance.png',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FutureWork()));
                      },
                    ),
                    option(
                      context: context,
                      width: size.width,
                      title: 'E-Pathology',
                      image: 'assets/images/icon_e_pathology.png',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FutureWork()));
                      },
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text(
                  "Nearby Available Doctors",
                  style: kTitleTextStyle,
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                width: size.width,
                height: 250,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Scrollbar(
                  controller: ScrollController(),
                  thickness: 2,
                  child: ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount:
                        nearbyDoctorProvider.nearbyDoctorModel?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      // LogDebugger.instance.v(nearbyDoctorProvider.nearbyDoctorModel);
                      return (nearbyDoctorProvider
                                      .nearbyDoctorModel?.data?.length ??
                                  0) ==
                              0
                          ? shimmer()
                          : SingleDoctorWidget(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BookAppointment(id: nearbyDoctorProvider
                                            .nearbyDoctorModel?.data?[index].personNoPk ?? 0)));
                              },
                              id: nearbyDoctorProvider.nearbyDoctorModel?.data?[index].personNoPk ?? 0,
                              name: nearbyDoctorProvider
                                  .nearbyDoctorModel?.data?[index].fullName,
                              image: nearbyDoctorProvider
                                  .nearbyDoctorModel?.data?[index].photoName,
                              qualification: nearbyDoctorProvider
                                  .nearbyDoctorModel?.data?[index].qualificationString,
                              specialization: nearbyDoctorProvider
                                  .nearbyDoctorModel?.data?[index].specialtyString,
                              doctorFee: nearbyDoctorProvider
                                  .nearbyDoctorModel
                                  ?.data?[index]
                                  .visitingFee ?? "0",
                              index: index,
                            );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 16.0);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text(
                  "Available Online - Telemedicine",
                  style: kTitleTextStyle,
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                width: size.width,
                height: 250,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Scrollbar(
                  controller: ScrollController(),
                  thickness: 2,
                  child: ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: telemedicineDoctorProvider
                            .telemedicineDoctorModel?.data?.length ??
                        0,
                    itemBuilder: (context, index) {
                      return (telemedicineDoctorProvider
                                      .telemedicineDoctorModel?.data?.length ??
                                  0) ==
                              0
                          ? shimmer()
                          : SingleDoctorWidget(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TelemedicineBookAppointment(id: telemedicineDoctorProvider
                                            .telemedicineDoctorModel?.data?[index].personNoPk ?? 0)));
                              },
                              id: telemedicineDoctorProvider
                                  .telemedicineDoctorModel?.data?[index].personNoPk ?? 0,
                              name: telemedicineDoctorProvider
                                  .telemedicineDoctorModel?.data?[index].fullName,
                              image: telemedicineDoctorProvider
                                  .telemedicineDoctorModel?.data?[index].photoName,
                              qualification: telemedicineDoctorProvider
                                  .telemedicineDoctorModel
                                  ?.data?[index]
                                  .qualificationString,
                              specialization: telemedicineDoctorProvider
                                  .telemedicineDoctorModel
                                  ?.data?[index]
                                  .specialtyString,
                              doctorFee: telemedicineDoctorProvider
                                  .telemedicineDoctorModel
                                  ?.data?[index]
                                  .visitingFee,
                              index: index,
                            );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 16.0);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget shimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 170,
        height: 250,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey[200]!)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(width: 50, height: 20, color: Colors.grey[200]),
            const SizedBox(height: 4.0),
            Container(width: 80, height: 20, color: Colors.grey[200]),
            const SizedBox(height: 4.0),
            Container(width: 80, height: 20, color: Colors.grey[200]),
          ],
        ),
      ),
    );
  }

  Widget option({required BuildContext context, required double width, required String title, required String image, required onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: ShadowContainer(
        radius: 8,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: width / 10,
                height: width / 10,
                child: Image.asset(
                  image,
                  fit: BoxFit.scaleDown,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                    fontSize: width / 30,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeBanner extends StatelessWidget {
  final String? bannerTitle;
  final String? bannerParagraph;
  final double? width;
  final String? image;

  const HomeBanner(
      {Key? key,
      @required this.bannerTitle,
      @required this.bannerParagraph,
      @required this.width,
      @required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        color: const Color.fromRGBO(197, 227, 246, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 0,
              child: SizedBox(
                width: width! / 2 - 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      bannerTitle.toString(),
                      style: kLargerTextStyle
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bannerParagraph.toString(),
                      style: kParagraphTextStyle,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: kPinkColor),
                        onPressed: () {},
                        child: const Text("Book Now",
                            style: TextStyle(fontSize: 16, color: kWhiteColor)))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
                width: width! / 2 - 20,
                child: Image.asset(
                  image!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ));
  }
}

class SingleDoctorWidget extends StatelessWidget {
  final int id;
  final String? name;
  final String? image;
  final String? specialization;
  final String? qualification;
  final String? doctorFee;
  final int index;
  final VoidCallback onTap;

  const SingleDoctorWidget({
    Key? key,
    required this.id,
    required this.name,
    required this.image,
    required this.specialization,
    required this.qualification,
    required this.doctorFee,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      width: 170,
      height: 250,
      child: InkWell(
        onTap: onTap,
        child: ShadowContainer(
          radius: 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                flex: 4,
                child: Center(
                  child: WidgetFactory.buildProfileAvatar(
                      context: context,
                      userName: name ?? 'User',
                      radius: 100.0,
                      url: image ?? 'assets/images/person.png',
                      imageType: image == null || image == '' ? ImageType.Asset : ImageType.Network
                  ),
                ),
              ),
              Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: Text(
                          name ?? "Doctor Name",
                          style: kTitleTextStyle,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(8, 0, 4, 4),
                        child: Text(
                          qualification ?? "Qualification",
                          style: kSubTitleTextStyle,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(8, 0, 4, 4),
                        child: Text(
                          specialization ?? "Specialization",
                          style: kSubTitleTextStyle,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  )),
              Container(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.only(top: 2),
                  decoration: const BoxDecoration(
                      color: kMediumBlueColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0), child: Text("${doctorFee ?? 0} TK",
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: kWhiteColor, fontSize: 14)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardOptionData {
  final String? title;
  final String? icon;

  const DashboardOptionData({this.title, this.icon});
}

const List<DashboardOptionData> choices = [
  DashboardOptionData(
      title: 'In Person Visit', icon: "assets/images/icon_in_person_visit.png"),
  DashboardOptionData(
      title: 'Telemedicine', icon: "assets/images/icon_telemedicine.png"),
  DashboardOptionData(
      title: 'Home Doctor', icon: "assets/images/icon_home_doctor.png"),
  DashboardOptionData(
      title: 'Blood Bank', icon: "assets/images/icon_blood_bank.png"),
  DashboardOptionData(
      title: 'Ambulance', icon: "assets/images/icon_ambulance.png"),
  DashboardOptionData(
      title: 'E-Pathology', icon: "assets/images/icon_e_pathology.png"),
];
