import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpr_patient/src/business_logics/models/profile_data_model.dart';
import 'package:dpr_patient/src/business_logics/models/user_data.dart';
import 'package:dpr_patient/src/business_logics/providers/patient_info_provider.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/services/firebase_services/db_service.dart';
import 'package:dpr_patient/src/views/ui/chat_screen.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/widgets/profile_avatar.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  Stream<QuerySnapshot> chatListStream = const Stream<QuerySnapshot>.empty();
  ProfileData? userProfile;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PatientInfoProvider>(context, listen: false)
          .getPatientList()
          .then((value) {
        if (value) {
          userProfile = Provider.of<PatientInfoProvider>(context, listen: false)
              .patientInfoModel
              ?.data
              ?.subProfiles
              ?.firstWhere((element) => element.patientNoPk == UserData.id);
          DBService.getChatRooms(UserData.id ?? 0).then((value) {
            setState(() {
              chatListStream = value;
              LogDebugger.instance.w(UserData.id);
            });
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PatientInfoProvider patientInfoProvider =
        Provider.of<PatientInfoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat Room List',
          style: TextStyle(color: kDeepBlueColor),
        ),
        backgroundColor: kWhiteColor,
        iconTheme: const IconThemeData(color: kBlackColor),
      ),
      body: Column(
        children: [
          ShadowContainer(
            radius: 8.0,
            margin: const EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
            child: WidgetFactory.buildDropDown(
              context: context,
              items: patientInfoProvider.patientInfoModel?.data?.subProfiles
                  ?.map<DropdownMenuItem<ProfileData>>((val) {
                return DropdownMenuItem(
                    value: val,
                    onTap: () {
                      setState(() {
                        DBService.getChatRooms(val.patientNoPk ?? 0)
                            .then((value) {
                          setState(() {
                            chatListStream = value;
                            LogDebugger.instance.w(val.patientNoPk);
                          });
                        });
                      });
                    },
                    child: Text("${val.firstName} ${val.lastName}"));
              }).toList(),
              hint: 'Choose a user',
              value: userProfile,
              onTap: () {},
              onChanged: (value) {
                setState(() {
                  userProfile = value as ProfileData?;
                });
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: chatListStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? snapshot.data?.docs.length == 0
              ? const SizedBox(
                height: 200,
                child: Center(
                  child: Text('No chatroom created'),
                ),
              )
              :ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            String chatRoomID = snapshot.data?.docs[index]
                                .get("room_id");
                            int patientNoFk = snapshot.data?.docs[index]
                                .get("pat_id");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                        chatroomID: chatRoomID,
                                        otherName: snapshot.data!.docs[index]
                                            .get("doc_name"), userID: patientNoFk)));
                          },
                          title: Text(
                              snapshot.data!.docs[index].get("doc_name"),
                              style: const TextStyle(fontSize: 18)),
                          leading: WidgetFactory.buildProfileAvatar(
                              context: context,
                              userName:
                                  snapshot.data!.docs[index].get("doc_name"),
                              radius: 50,
                              url: snapshot.data?.docs[index].get("doc_image"),
                              imageType: ImageType.Network),
                        );
                      }, separatorBuilder: (_, __) => const Divider(),)
                  : const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text('No chatroom created'),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
