import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpr_patient/src/services/webrtc_services/webrtc_service.dart';
import 'package:dpr_patient/src/views/ui/chat_screen.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CallScreen extends StatefulWidget {
  final String chatRoomID;
  final bool isVideo;
  final String? image;
  final String? otherName;
  final int? userID;

  const CallScreen(
      {Key? key, required this.chatRoomID, required this.isVideo, this.image, this.otherName, this.userID})
      : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool video = false;
  bool audio = true;

  @override
  void initState() {
    video = widget.isVideo;
    addPostFrameCallback();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _localRenderer.initialize();
      _remoteRenderer.initialize();

      signaling.onAddRemoteStream = ((stream) {
        _remoteRenderer.srcObject = stream;
        setState(() {});
      });

      signaling
          .openUserMedia(_localRenderer, _remoteRenderer, widget.isVideo)
          .then((value) {
        _localRenderer.srcObject = value.localsrcObject;
        _remoteRenderer.srcObject = value.remotesrcObject;
        setState(() {});
        signaling.joinRoom(widget.chatRoomID, _remoteRenderer);
      });
    });
    super.initState();
  }

  late StreamSubscription _streamSubscription;
  addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _streamSubscription = FirebaseFirestore.instance.collection('CallRoom').doc(widget.chatRoomID).snapshots().listen((event) {
        switch (event.data()) {
          case null:
            signaling.hangUp(_localRenderer, widget.chatRoomID);
            Navigator.pop(context);
            break;
          default:
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    signaling.disposeWebRTC();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kRedColor,
        onPressed: () {
          signaling.hangUp(_localRenderer, widget.chatRoomID);
          Navigator.pop(context);
        },
        child: const Icon(Icons.phone, color: kWhiteColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: kWhiteColor,
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: (){
                setState(() {
                  video = !video;
                });
                signaling
                    .openUserMedia(_localRenderer, _remoteRenderer, video)
                    .then((value) {
                  _localRenderer.srcObject = value.localsrcObject;
                  _remoteRenderer.srcObject = value.remotesrcObject;
                  setState(() {});
                });
              }, icon: Icon(video ? Icons.videocam : Icons.videocam_off, color: kThemeColor,)),
              IconButton(onPressed: (){
                setState(() {
                  audio = !audio;
                });
                signaling
                    .openUserMedia(_localRenderer, _remoteRenderer, widget.isVideo)
                    .then((value) {
                  _localRenderer.srcObject = value.localsrcObject;
                  _remoteRenderer.srcObject = value.remotesrcObject;
                  setState(() {});
                });
              }, icon: Icon(audio ? Icons.mic : Icons.mic_off, color: kThemeColor,)),
              IconButton(onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                chatroomID: widget.chatRoomID,
                                otherName: widget.otherName ?? '',
                                userID: widget.userID ?? 0)));
                  }, icon: const FaIcon(FontAwesomeIcons.facebookMessenger,color: kThemeColor,)),
              IconButton(onPressed: (){}, icon: const ImageIcon(AssetImage('assets/images/call_screen_icon.png'), color: kThemeColor,)),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          RTCVideoView(
            _remoteRenderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          ),
          Positioned(
              bottom: 0,
              left: MediaQuery.of(context).size.width - 150,
              right: 0,
              child: Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                    height: 150,
                    width: 150,
                    child: RTCVideoView(
                      _localRenderer,
                      mirror: true,
                      objectFit:
                      RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    )),
              )),
        ],
      ),
    );
  }
}
