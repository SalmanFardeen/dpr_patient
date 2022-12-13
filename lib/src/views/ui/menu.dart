import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/services/shared_preference_services/shared_prefs_services.dart';
import 'package:dpr_patient/src/views/ui/addresses.dart';
import 'package:dpr_patient/src/views/ui/favourite_items.dart';
import 'package:dpr_patient/src/views/ui/future_work.dart';
import 'package:dpr_patient/src/views/ui/login.dart';
import 'package:dpr_patient/src/views/ui/medication_plan.dart';
import 'package:dpr_patient/src/views/ui/payment_method_settings.dart';
import 'package:dpr_patient/src/views/ui/prescription_list_screens/prescription_list.dart';
import 'package:dpr_patient/src/views/ui/profile.dart';
import 'package:dpr_patient/src/views/ui/subprofile_screens/sub_profile_list.dart';
import 'package:dpr_patient/src/views/ui/terms_and_conditions.dart';
import 'package:dpr_patient/src/views/ui/uploaded_document.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: WidgetFactory.buildProfileAvatar(
                            context: context,
                            userName: profileProvider.profileModel?.data?.profile?.patientName ?? "userName",
                            radius: 80.0,
                            url: profileProvider.profileModel?.data?.profile?.image ?? 'assets/images/person.png',
                            imageType: profileProvider.profileModel?.data?.profile?.image == null ? ImageType.Asset : ImageType.Network
                        ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8.0),
                          Text(
                            profileProvider.profileModel?.data?.profile?.patientName ?? "User",
                            style: kLargerBlueTextStyle,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            "Phone:" + (profileProvider.profileModel?.data?.profile?.mobile ?? ""),
                            style:
                                const TextStyle(color: kDeepBlueColor, fontSize: 16),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            "DPR ID:" + (profileProvider.profileModel?.data?.profile?.dprId ?? ""),
                            style:
                                const TextStyle(color: kDeepBlueColor, fontSize: 16),
                          ),
                          const SizedBox(height: 8.0),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(thickness: 2, height: .8, color: Colors.grey.shade300),
              const DrawerSegment(
                  title: "Account", getDrawerItems: DrawerData.account),
              const DrawerSegment(
                  title: "Reports", getDrawerItems: DrawerData.reports),
              const DrawerSegment(
                  title: "Misc", getDrawerItems: DrawerData.misc),
              const DrawerSegment(
                  title: "Help and Legal",
                  getDrawerItems: DrawerData.helpAndLegal),
              const DrawerSegment(
                  title: "Settings", getDrawerItems: DrawerData.settings),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerSegment extends StatelessWidget {
  final String? title;
  final Function getDrawerItems;

  const DrawerSegment(
      {Key? key, required this.title, required this.getDrawerItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title!, style: kTitleTextStyle),
          ),
          ...getDrawerItems(context).map((drawer) {
            return SingleDrawer(drawer: drawer);
          }),
          Divider(thickness: 2, height: .8, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}

class SingleDrawer extends StatelessWidget {
  final SingleDrawerData drawer;

  const SingleDrawer({Key? key, required this.drawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            drawer.icon,
            size: 30,
            color: kDeepBlueColor,
          ),
          title: Text(drawer.title,
              style: const TextStyle(color: kDeepBlueColor, fontSize: 16)),
          onTap: drawer.onPressed,
        ),
        Divider(
          thickness: 1,
          height: .8,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}

class DrawerData {
  static List<SingleDrawerData> account(BuildContext context) {
    List<SingleDrawerData> drawers = [
      SingleDrawerData(
          title: "Profile",
          icon: Icons.account_circle,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Profile()));
          }),
      SingleDrawerData(
          title: "Sub Profile", icon: Icons.groups, onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SubProfileList()));
      }),
      SingleDrawerData(
          title: "Payment Methods",
          icon: Icons.payment,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PaymentMethodSettings()));
          }),
      SingleDrawerData(
          title: "Addresses",
          icon: Icons.place,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Addresses()));
          }),
    ];
    return drawers;
  }

  static List<SingleDrawerData> reports(BuildContext context) {
    List<SingleDrawerData> drawers = [
      SingleDrawerData(
          title: "Prescriptions", icon: Icons.note_add, onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Prescription()));
      }),
      SingleDrawerData(
          title: "Lab Reports", icon: Icons.science, onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const FutureWork()));
      }),
      SingleDrawerData(
          title: "Uploaded Documents",
          icon: Icons.snippet_folder_rounded,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UploadedDocument()));
          }),
    ];
    return drawers;
  }

  static List<SingleDrawerData> misc(BuildContext context) {
    List<SingleDrawerData> drawers = [
      SingleDrawerData(title: "Reminder", icon: Icons.alarm, onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const FutureWork()));
      }),
      SingleDrawerData(
          title: "Medicine Plan", icon: Icons.medication, onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MedicationPlan()));
      }),
      SingleDrawerData(
          title: "Favorite", icon: Icons.favorite, onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const FavouriteItems()));
      }),
    ];
    return drawers;
  }

  static List<SingleDrawerData> helpAndLegal(BuildContext context) {
    List<SingleDrawerData> drawers = [
      SingleDrawerData(
          title: "Helpline",
          icon: Icons.phone_in_talk,
          onPressed: () {
            _modalBottomSheetMenu(context);
          }),
      SingleDrawerData(
          title: "Terms And Condition",
          icon: Icons.file_copy,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TermsAndConditions()));
          }),
    ];
    return drawers;
  }

  static List<SingleDrawerData> settings(BuildContext context) {
    List<SingleDrawerData> drawers = [
      // SingleDrawerData(
      //     title: "Language",
      //     icon: Icons.language,
      //     onPressed: () {
      //       _showLanguageDialog(context);
      //     }),
      // SingleDrawerData(
      //     title: "Theme",
      //     icon: Icons.mode,
      //     onPressed: () {
      //       _showThemeDialog(context);
      //     }),
      SingleDrawerData(
          title: "Notifications", icon: Icons.notifications, onPressed: () {}),
      SingleDrawerData(
          title: "About",
          icon: Icons.info,
          onPressed: () {
            _modalAboutApp(context);
          }),
      SingleDrawerData(
          title: "Logout",
          icon: Icons.logout,
          onPressed: () async {
            await SharedPrefsServices.setStringData("accessToken", "");
            ProfileProvider provider = Provider.of<ProfileProvider>(context, listen: false);
            provider.getSubProfileList(false);
            provider.clear();
            UserData.accessToken = null;
            UserData.username = null;
            UserData.phone = null;
            UserData.address = null;
            UserData.gender = null;
            UserData.age = null;
            UserData.dprId = null;
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false);
          }),
    ];
    return drawers;
  }
}

class SingleDrawerData {
  final String title;
  final IconData icon;
  final VoidCallback? onPressed;

  SingleDrawerData({required this.title, required this.icon, this.onPressed});
}

void _modalBottomSheetMenu(context) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.phone, color: kVioletColor),
              title: const Text('National Hotline Number 333',
                  style: kTitleTextStyle),
              onTap: () {
                // print('Call 333');
                launch(('tel://333'));
              },
            ),
            const Divider(thickness: 1),
            ListTile(
              leading: const Icon(Icons.phone, color: kVioletColor),
              title: const Text('Health Call Centre DGHS 16203',
                  style: kTitleTextStyle),
              onTap: () {
                // print('Call phone');
                launch(('tel://16263'));
              },
            ),
          ],
        );
      });
}

// language change dialog
Future<void> _showLanguageDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select language',
              style: TextStyle(fontSize: 16),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: kBlackColor,
                  size: 20,
                ))
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 12),
            ListTile(
              onTap: () {},
              title: const Text('English'),
              leading: const Icon(Icons.language),
              trailing: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.done,
                    size: 12,
                    color: kWhiteColor,
                  )),
            ),
            const Divider(height: 0),
            ListTile(
              onTap: () {},
              title: const Text('Bangla'),
              leading: const Icon(Icons.lightbulb_outline),
            ),
          ],
        ),
      );
    },
  );
}

// theme change dialog
Future<void> _showThemeDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select theme',
              style: TextStyle(fontSize: 16),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: kBlackColor,
                  size: 20,
                ))
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 12),
            ListTile(
              onTap: () {},
              title: const Text('Dark'),
              leading: const Icon(Icons.nightlight_round),
              trailing: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.done,
                    size: 12,
                    color: kWhiteColor,
                  )),
            ),
            const Divider(height: 0),
            ListTile(
              onTap: () {},
              title: const Text('Light'),
              leading: const Icon(Icons.lightbulb_outline),
            ),
          ],
        ),
      );
    },
  );
}

void _modalAboutApp(context) {
  showAboutDialog(
      context: context,
      applicationIcon: const Icon(Icons.info_outline),
      applicationName: 'About DPR',
      applicationVersion: 'Version : 1.0.3',
      applicationLegalese: 'Developed By NextGen Ltd.',
      children: [
        const Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
      ]);
}
