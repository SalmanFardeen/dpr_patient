import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/providers/favourite_provider.dart';
import 'package:dpr_patient/src/views/ui/book_appointment.dart';
import 'package:dpr_patient/src/views/ui/chat_list_screen.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FavouriteItems extends StatefulWidget {
  const FavouriteItems({Key? key}) : super(key: key);

  @override
  State<FavouriteItems> createState() => _FavouriteItemsState();
}

class _FavouriteItemsState extends State<FavouriteItems> with TickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    var favouriteProvider = Provider.of<FavouriteProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      favouriteProvider.getFavDocList();
      favouriteProvider.getFavMedList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    FavouriteProvider favouriteProvider = Provider.of<FavouriteProvider>(context);
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
      body: SafeArea(
        child:
        // Column(
        //   children: [
            // Row(
            //   children: [
            //     Expanded(
            //         flex: 2,
            //         child: Container(
            //           padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            //             child: PatientLocation(location: UserData.address)
            //         )
            //     ),
            //     Expanded(flex: 1, child: Container()),
            //     const Expanded(
            //       flex: 1,
            //       child: SizedBox(),
            //     )
            //   ],
            // ),
            // const SizedBox(height: 24.0),
            SizedBox(
              height: size.height - 150,
              child: tabInfo(context, favouriteProvider, size),
            )
        //   ],
        // ),
      ),
    );
  }

  Widget tabInfo(BuildContext context, FavouriteProvider favouriteProvider, Size size) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Container(
            color: kDeepBlueColor,
            child: TabBar(
              labelColor: kWhiteColor,
              indicatorColor: kWhiteColor,
              labelStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              controller: _tabController,
              tabs: const [
                Tab(
                  text: "Doctor",
                ),
                Tab(
                  text: "Medicine",
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(controller: _tabController, children: [
            (!favouriteProvider.inProgress &&
                    (favouriteProvider.favDocModel?.data?.length ?? 0) == 0)
                ? RefreshIndicator(
                    onRefresh: () {
                      return Future.delayed(const Duration(seconds: 1),
                          () async {
                        favouriteProvider.getFavDocList();
                        favouriteProvider.getFavMedList();
                      });
                    },
                    child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                            width: size.width,
                            height: 300,
                            child: const Center(
                                child: Text("No doctor added to favorite",
                                    style: kTitleTextStyle)))))
                : favDocList(favouriteProvider, size.width),
            // (!favouriteProvider.inProgress &&
            //         (favouriteProvider.favMedModel?.data?.length ?? 0) == 0)
            //     ? RefreshIndicator(
            //         onRefresh: () {
            //           return Future.delayed(const Duration(seconds: 1),
            //               () async {
            //             favouriteProvider.getFavDocList();
            //             favouriteProvider.getFavMedList();
            //           });
            //         },
            //         child: SingleChildScrollView(
            //           physics: const AlwaysScrollableScrollPhysics(),
            //           child: SizedBox(
            //               width: size.width,
            //               height: 300,
            //               child: const Center(
            //                   child: Text("No medicine added to favorite",
            //                       style: kTitleTextStyle))),
            //         ),
            //       )
            //     : favMedList(favouriteProvider, size.width)
            const Center(child: Text('For Future Work'),)
          ]),
        )
      ],
    );
  }

  Widget favDocList(FavouriteProvider favouriteProvider, double width){
    return  RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () async {
          favouriteProvider.getFavDocList();
          favouriteProvider.getFavMedList();
        });
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: favouriteProvider.favDocModel?.data?.length ?? 0,
            separatorBuilder: (_, __) => const SizedBox(height: 8.0),
            itemBuilder: (BuildContext context, int position) {
              return favouriteProvider.inProgress
                  ? shimmer(width)
                  : getSingleFavouriteDoctor(context, favouriteProvider, position);
            }),
      ),
    );
  }

  Widget favMedList(FavouriteProvider favouriteProvider, double width){
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () async {
          favouriteProvider.getFavDocList();
          favouriteProvider.getFavMedList();
        });
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: favouriteProvider.favMedModel?.data?.length ?? 0,
            separatorBuilder: (_, __) => const SizedBox(height: 8.0),
            itemBuilder: (BuildContext context, int position) {
              return favouriteProvider.inProgress
                  ? shimmer(width)
                  : getSingleFavoriteMedicine(context, favouriteProvider, position);
            }),
      ),
    );
  }

  Widget getSingleFavouriteDoctor(BuildContext context, FavouriteProvider favouriteProvider, int position) {
    return Container(
      height: 150,
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: ShadowContainer(
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Center(
                          child: WidgetFactory.buildProfileAvatar(
                            context: context,
                            url: favouriteProvider.favDocModel?.data?[position].photoName ?? "assets/images/person.png",
                            userName: favouriteProvider.favDocModel?.data?[position].fullName ?? "User",
                            imageType: favouriteProvider.favDocModel?.data?[position].photoName == null || favouriteProvider.favDocModel?.data?[position].photoName == '' ? ImageType.Asset : ImageType.Network,
                            radius: 60,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: kDeepBlueColor,
                              borderRadius: BorderRadius.circular(16.0)
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                          child: const Text("Recommended", textAlign: TextAlign.center, style: TextStyle(color: kWhiteColor, fontSize: 10)),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  )),
              Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(favouriteProvider.favDocModel?.data?[position].fullName ?? "N/A", style: kLargerBlueTextStyle),
                      const SizedBox(height: 8.0),
                      Text(favouriteProvider.favDocModel?.data?[position].specializationString ?? "N/A", style: TextStyle(color: Colors.grey[600]),),
                      const SizedBox(height: 4.0),
                      Text(favouriteProvider.favDocModel?.data?[position].qualificationString ?? "N/A", style: TextStyle(color: Colors.grey[600]),),
                      // const SizedBox(height: 4.0),
                      // Text(favouriteProvider.favDocModel?.data?[position].chamberHospitalName ?? "N/A", style: kSubTitleTextStyle),
                      // const SizedBox(height: 4.0),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     const Icon(
                      //       Icons.work,
                      //       size: 18,
                      //       color: kDeepBlueColor,
                      //     ),
                      //     const SizedBox(width: 5),
                      //     Expanded(
                      //         child: Text(
                      //             "Visiting Fee: ${favouriteProvider.favDocModel?.data?[position].doctorFee ?? "N/A"}",
                      //             style: kSemiTitleTextStyle)),
                      //   ],
                      // ),
                      const SizedBox(height: 10),
                    ],
                  )),
              Expanded(
                flex: 1,
                child: Container(
                  height: 160,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: kLightBlueColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: favouriteProvider.isFavSetting ? () {}
                          : () async {
                          final _response = await favouriteProvider.setFavDoc(
                              doctor: favouriteProvider.favDocModel?.data?[position].doctorPersonNoFk ?? 0,
                              isFav: 0
                          );
                          if(!_response) {
                            favouriteProvider.getFavDocList();
                          }
                        },
                        child: const Icon(
                          Icons.favorite,
                          color: kRedColor,
                          size: 30,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // if(favouriteProvider.favDocModel?.data?[position].chamberHospitalName != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookAppointment(id: favouriteProvider.favDocModel?.data?[position].doctorPersonNoFk ?? 0)));
                          // } else {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => TelemedicineBookAppointment(id: favouriteProvider.favDocModel?.data?[position].doctorPersonNoFk ?? 0)));
                          // }
                        },
                        child: const Icon(
                          Icons.keyboard_arrow_right,
                          color: kDarkGreyColor,
                          size: 45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          radius: 8
      ),
    );
  }

  Widget getSingleFavoriteMedicine(BuildContext context, FavouriteProvider favouriteProvider, int position) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: ShadowContainer(
          radius: 8.0,
          child: ListTile(
            title: Text(favouriteProvider.favMedModel?.data?[position].favouriteName ?? "", style: kTitleTextStyle),
            trailing: ShadowContainer(
              radius: 4.0,
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.favorite, color: kRedColor),
            ),
          )
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