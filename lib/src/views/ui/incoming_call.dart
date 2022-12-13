import 'package:dpr_patient/src/views/ui/call_screen.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';

class IncomingCall extends StatelessWidget {
  const IncomingCall(
      {Key? key,
      required this.callerName,
      required this.callerPic,
      required this.roomID,
      required this.isVideo})
      : super(key: key);
  final String callerName;
  final String callerPic;
  final String roomID;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: kBlackColor,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetFactory.buildProfileAvatar(
                      context: context,
                      userName: callerName,
                      radius: 100,
                      url: callerPic,
                      imageType: ImageType.Network),
                  const SizedBox(height: 16),
                  Text(callerName,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: kDeepBlueColor)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kRedColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.phone_disabled,
                        color: kWhiteColor,
                        size: 30,
                      ),
                    )),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CallScreen(
                                  chatRoomID: roomID,
                                  isVideo: isVideo)));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.phone,
                        color: kWhiteColor,
                        size: 30,
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
