import 'package:dpr_patient/src/business_logics/models/doctor_appointment_input_model.dart';
import 'package:dpr_patient/src/business_logics/providers/doctor_details_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/patient_info_provider.dart';
import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/views/ui/appointment_slot.dart';
import 'package:dpr_patient/src/views/ui/profile_edit.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BookAppointment extends StatefulWidget {

  final int id;
  const BookAppointment({Key? key, required this.id}) : super(key: key);

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> with TickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);

    DoctorDetailsProvider doctorDetailsProvider = Provider.of<DoctorDetailsProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      doctorDetailsProvider.clear();
      doctorDetailsProvider.getDoctorDetails(id: widget.id, type: "chamber");
      doctorDetailsProvider.getDoctorChambers(widget.id);
      doctorDetailsProvider.getSlotSummery(doctor: widget.id, type: "chamber");
      PatientInfoProvider.doctorAppointmentInputModel = DoctorAppointmentInputModel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DoctorDetailsProvider doctorDetailsProvider = Provider.of<DoctorDetailsProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
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
      body:  RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () async {
            doctorDetailsProvider.clear();
            doctorDetailsProvider.getDoctorDetails(id: widget.id, type: "chamber");
            doctorDetailsProvider.getDoctorChambers(widget.id);
            doctorDetailsProvider.getSlotSummery(doctor: widget.id, type: "chamber");
          });
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: doctorDetailsProvider.inProgress
                  ? shimmer(size.width)
                  : const Header(),
                ),
                Divider(
                  thickness: 1,
                  height: .05,
                  color: Colors.grey.shade400,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "About Me",
                        style: kLargerTextStyle,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ShadowContainer(
                  radius: 16.0,
                  child: SizedBox(
                    height: 300,
                    width: size.width - 32,
                    child: getTab(context, doctorDetailsProvider, size.width),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: WidgetFactory.buildButton(
                    context: context,
                    child: const Text(
                      "BOOK APPOINTMENT",
                      style: kButtonTextStyle,
                    ),
                    backgroundColor: doctorDetailsProvider.inProgress ? kLightGreyColor : kMediumBlueColor,
                    borderRadius: 32.0,
                    onPressed: doctorDetailsProvider.inProgress
                      ? () {}
                      : () {
                        if(profileProvider.profileLoaded && profileProvider.profileModel?.data?.profile?.age != null) {
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) =>
                              AppointmentSlot(
                                  id: doctorDetailsProvider.doctorDetailsModel
                                      ?.data?.personNoPk ?? 0)));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) =>
                              ProfileEdit(profileProvider: profileProvider)));
                        }
                      }
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getTab(BuildContext context, DoctorDetailsProvider provider, double width) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0)
                )
            ),
            child: TabBar(
              indicatorColor: Colors.blue,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              labelColor: kMediumBlueColor,
              labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              controller: _tabController,
              tabs: const [
                Tab(
                  text: "Education",
                ),
                Tab(
                  text: "Experience",
                ),
                Tab(
                  text: "Slot",
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 230,
          child: TabBarView(controller: _tabController, children: [
            provider.inProgress
            ? tabShimmer(width)
            : Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.separated(
                  itemBuilder: (context, index) => Text(
                    "${provider.doctorDetailsModel?.data?.qualification?[index].degreeTypeName}, ${provider.doctorDetailsModel?.data?.qualification?[index].institution}",
                    style: const TextStyle(color: kThemeColor, fontSize: 16),
                  ),
                  itemCount: provider.doctorDetailsModel?.data?.qualification?.length ?? 0,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                )
            ),
            provider.inProgress
            ? tabShimmer(width)
            : Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.separated(
                  itemBuilder: (context, index) => Text(
                      "${provider.doctorDetailsModel?.data?.designation?[index].designation} at ${provider.doctorDetailsModel?.data?.designation?[index].institution}",
                    style: const TextStyle(color: kThemeColor, fontSize: 16),
                  ),
                  itemCount: provider.doctorDetailsModel?.data?.designation?.length ?? 0,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                )
            ),
            provider.inProgress
            ? tabShimmer(width)
            : Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              height: 150,
              child: Scrollbar(
                thickness: 2,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: provider.slotSummeryResponseModel?.data?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0, left: 2.0),
                        width: width,
                        child: Slot(index: index),
                      );
                    }
                ),
              ),
            ),
          ]),
        )
      ],
    );
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

  Widget tabShimmer(width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16.0),
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
                  "${provider.doctorDetailsModel?.data?.designation?[0].designation ?? 'N/A'} at ${provider.doctorDetailsModel?.data?.designation?[0].institution ?? 'N/A'}",
                  style: kSubTitleTextStyle,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Icon(Icons.payment,size: 12,),
                      const SizedBox(width: 2.0),
                      Text(
                        provider.doctorDetailsModel?.data?.visitingFee == null ? "Visiting Fee: " : "",
                        style: const TextStyle(color: kMediumBlueColor, fontSize: 12),
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


class Slot extends StatelessWidget {
  final int index;
  final String? searchedChamber;
  const Slot({Key? key, required this.index, this.searchedChamber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DoctorDetailsProvider provider = Provider.of<DoctorDetailsProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 0, child: Text("${provider.slotSummeryResponseModel?.data?[index].startTime} - ${provider.slotSummeryResponseModel?.data?[index].endTime}", style: const TextStyle(color: kOrangeColor, fontSize: 16, fontWeight: FontWeight.w600))),
        const SizedBox(height: 4.0),
        Expanded(flex: 0, child: Text(provider.slotSummeryResponseModel?.data?[index].day ?? "", style: kSubTitleTextStyle)),
        const SizedBox(height: 4.0),
        Expanded(flex: 0, child: Text(provider.slotSummeryResponseModel?.data?[index].chamberHospitalName ?? "", style: kTitleTextStyle)),
      ],
    );
  }
}

