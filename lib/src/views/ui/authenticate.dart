import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/providers/profile_provider.dart';
import 'package:dpr_patient/src/services/shared_preference_services/shared_prefs_services.dart';
import 'package:dpr_patient/src/services/webrtc_services/webrtc_service.dart';
import 'package:dpr_patient/src/views/ui/call_screen.dart';
import 'package:dpr_patient/src/views/ui/login.dart';
import 'package:dpr_patient/src/views/ui/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  late ProfileProvider profileProvider;
  bool userLoggedIn = false;
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    getUserAuthState();
    var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      AwesomeNotifications().actionStream.listen((event) {
        if(event.buttonKeyPressed == 'decline') {
          Signaling().hangUp(RTCVideoRenderer(), event.payload?['room_id'] ?? '');
          // DBService.hangup(event.payload?['room_id'] ?? '');
        } else if(event.buttonKeyPressed == 'accept'){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CallScreen(
                        chatRoomID: event.payload?['room_id'] ?? '',
                        isVideo:
                            event.payload?['is_video'] == 'true' ? true : false,
                        image: event.payload?['image'],
                        otherName: event.payload?['name'],
                        userID: int.parse(event.payload?['other_id'] ?? '0'),
                      )));
        }
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(userLoggedIn) {
        profileProvider.getProfile();
        profileProvider.getSubProfileList(true);
      }
      changeOpacity();
      if(mounted) setState(() {});
    });
  }

  // get user auth state
  void getUserAuthState() async {
    UserData.accessToken = SharedPrefsServices.getStringData("accessToken") ?? "";
    print('Token: ${UserData.accessToken}');
    userLoggedIn = UserData.accessToken != "";
    if (mounted) {
      setState(() {});
    }
  }

  changeOpacity() {
    Future.delayed(const Duration(seconds: 1), () {
        opacity = opacity == 0.0 ? 1.0 : 0.0;
        changeOpacity();
    });
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    return userLoggedIn
    ? (profileProvider.profileLoaded
        ? const Navigation(selectedIndex: 0)
        : const Scaffold(
          body: Center(child: CircularProgressIndicator())
        )
    )
    : const Login();
  }
}
