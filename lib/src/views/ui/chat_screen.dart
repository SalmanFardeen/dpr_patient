
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpr_patient/src/business_logics/providers/document_provider.dart';
import 'package:dpr_patient/src/business_logics/utils/log_debugger.dart';
import 'package:dpr_patient/src/services/firebase_services/db_service.dart';
import 'package:dpr_patient/src/views/utils/chat_file_upload.dart';
import 'package:dpr_patient/src/views/utils/colors.dart';
import 'package:dpr_patient/src/views/utils/custom_styles.dart';
import 'package:dpr_patient/src/views/widgets/scaffold_message.dart';
import 'package:dpr_patient/src/views/widgets/shadow_container.dart';
import 'package:dpr_patient/src/views/widgets/widget_factory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.chatroomID,
    required this.otherName,
    required this.userID,
  }) : super(key: key);
  final String chatroomID;
  final String otherName;
  final int userID;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgController = TextEditingController();

  Stream<QuerySnapshot> chatMsgStream = const Stream<QuerySnapshot>.empty();

  late File _uploadDocumentImage;
  List<File> files = [];
  final picker = ImagePicker();
  String date = '';

  ScrollController _scrollController = ScrollController();

  sendMsg() {
    if (msgController.text.isNotEmpty) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 200);
      Map<String, dynamic> msgMap = {
        "message": msgController.text,
        "sentby": widget.userID,
        "type": 'message',
        "time": DateTime.now()
      };
      DBService.addConversationMsgs(widget.chatroomID, msgMap);
      msgController.text = "";
    }
  }

  sendImg() async {
    if(files.isNotEmpty) {
      List<File> compressFile = await ChatFileUpload.compressImage(files);
      for (var element in compressFile) {
        await Provider.of<DocumentProvider>(context, listen: false).upload('Chat Files', DateFormat('yyyy-MM-dd').format(DateTime.now()), element).then((value) {
          if(value) {
            Provider.of<DocumentProvider>(context, listen: false).documentUploadModel?.data?.forEach((element) {
              LogDebugger.instance.d('upload ${element.pathName}');
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 200);
              Map<String, dynamic> msgMap = {
                "message": element.pathName,
                "sentby": widget.userID,
                "type": 'upload_images',
                "time": DateTime.now()
              };
              DBService.addConversationMsgs(widget.chatroomID, msgMap);
            });
            setState(() {
              files.clear();
            });
            LogDebugger.instance.d('Done uploading images');
          }
        });
      }
    }
  }

  Widget chatMessageList(Size size) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatMsgStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? Expanded(
              child: ListView.builder(
                controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    Timestamp date = snapshot.data?.docs[index].get('time');
                    String dt = DateFormat('hh:mm a').format(date.toDate());
                    String title =
                        DateFormat('dd/MM/yyyy').format(date.toDate());
                    if (DateTime.now().year == date.toDate().year &&
                        DateTime.now().month == date.toDate().month) {
                      if (DateTime.now().day == date.toDate().day) {
                        title = 'Today';
                      } else if (DateTime.now().day - 1 ==
                          date.toDate().day) {
                        title = 'Yesterday';
                      } else {
                        title =
                            DateFormat('dd/MM/yyyy').format(date.toDate());
                      }
                    } else {
                      title =
                          DateFormat('dd/MM/yyyy').format(date.toDate());
                    }
                    String compareNow =
                        DateFormat.yMMMEd().format(date.toDate());
                    bool prevSameDate = false;
                    if (index > 0) {
                      Timestamp prevDate =
                          snapshot.data?.docs[index - 1].get('time');
                      String comparePrev =
                          DateFormat.yMMMEd().format(prevDate.toDate());
                      prevSameDate = compareNow == comparePrev;
                    }
                    return messageTile(
                      size: size,
                        message: snapshot.data?.docs[index].get("message"),
                        date: dt,
                        title: title,
                        type: snapshot.data?.docs[index].get("type"),
                        isSentByMe: snapshot.data?.docs[index].get("sentby") ==
                            widget.userID,
                        prevSameDate: prevSameDate);
                  }),
            )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future getImage(double width) async {
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
          width: width,
          height: 150,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          getImageOptions(width, true);
                        },
                        child: Icon(FontAwesomeIcons.camera, color: kThemeColor, size: width / 6)
                    ),
                    const SizedBox(height: 16.0),
                    const Text("Capture Image", style: kLargerBlueTextStyle)
                  ],
                ),
              ),
              Container(
                height: 150,
                width: 1,
                color: kBlackColor,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          getImageOptions(width, false);
                        },
                        child: Icon(FontAwesomeIcons.photoVideo, color: kThemeColor, size: width / 6)
                    ),
                    const SizedBox(height: 16.0),
                    const Text("Gallery", style: kLargerBlueTextStyle)
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  getImageOptions(double width, bool isCamera) async {
    if(isCamera){
      final pickedFile =
      await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        if (mounted) {
          setState(() {
            _uploadDocumentImage = File(pickedFile.path);
            files.add(_uploadDocumentImage);
          });
        }
      }
    } else {
      final pickedFile =
      await picker.pickMultiImage();
      if (pickedFile != null) {
        if (mounted) {
          setState(() {
            for (var element in pickedFile) {
              if(element.path != '') {
                _uploadDocumentImage = File(element.path);
                files.add(_uploadDocumentImage);
              }
            }
          });
        }
      }
    }
  }



  Widget messageTile(
      {required String message,
      required String date,
      required String title,
      required String type,
      required bool isSentByMe,
      required bool prevSameDate,
        required Size size}) {
    return Column(
      children: [
        const SizedBox(height: 16),
        if (!prevSameDate)
          Stack(
            alignment: Alignment.center,
            children: [
              Divider(
                color: kChatBubbleColor.withOpacity(0.7),
                indent: 10,
                endIndent: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                    color: kChatBubbleColor,
                    backgroundColor: kWhiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          width: size.width,
          alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          padding: EdgeInsets.only(
              left: isSentByMe ? 45 : 15, right: isSentByMe ? 15 : 45),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
                color: isSentByMe ? kChatBubbleColor : kWhiteColor,
                border: isSentByMe
                    ? Border.all(color: Colors.transparent)
                    : Border.all(color: kDeepBlueColor),
                borderRadius: isSentByMe
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(0))
                    : const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                type == 'upload_images'
                ? GestureDetector(
                  onTap: () {
                    launchURLMethod(message);
          },
                  child: SizedBox(
                    height: 100,
                      child: Image.network(message)),
                )
                : Text(
                  message,
                  style: TextStyle(
                      color: isSentByMe ? kWhiteColor : kDeepBlueColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                      color: isSentByMe ? kWhiteColor : kDeepBlueColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    DBService.getConversationMsgs(widget.chatroomID).then((value) {
      setState(() {
        chatMsgStream = value;
      });
    });
    DBService.getAppointmentTiming(widget.chatroomID).then((value) {
      setState(() {
        Stream<QuerySnapshot> stream = value;
        stream.asyncMap((event) {

        });

      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          iconTheme: const IconThemeData(color: kBlackColor),
          title: Text(
            widget.otherName,
            style: const TextStyle(color: kDeepBlueColor),
          ),
        ),
        body: Column(
          children: [
            chatMessageList(size),
            files.isEmpty
                ? Container(
              height: 60,
              color: kWhiteColor,
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                       getImage(size.width);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            color: kChatIconBorderColor,
                              borderRadius: BorderRadius.circular(20)),
                          child:
                              const Icon(Icons.add, color: kChatBubbleColor))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onSubmitted: (val) => sendMsg(),
                      controller: msgController,
                      decoration: InputDecoration(
                          hintText: "Enter Message",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                      onTap: () => sendMsg(),
                      child: const Icon(
                        Icons.send,
                        color: kChatBubbleColor,
                      ))
                ],
              ),
            ) : SizedBox(
              height: size.height/4,
              child: Card(
                elevation: 4,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                    child: Provider.of<DocumentProvider>(context, listen: false).inProgress
                      ? const Center(child: CircularProgressIndicator(),)
                      :Column(
                      children: [
                        Wrap(
                          children: [
                            ...files.map((element) => Stack(
                              children: [
                                Image.file(
                                  element,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    left: 70,
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            files.remove(element);
                                          });
                                        },
                                        child: ShadowContainer(
                                          radius: 50,
                                          padding: const EdgeInsets.all(1.0),
                                          child: const Icon(
                                            Icons.close,
                                            color: kRedColor,
                                            size: 15,
                                          ),
                                        ))),
                              ],
                            )).toList()
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 80,
                              child: WidgetFactory.buildButton(
                                  context: context,
                                  child: const Text('Cancel', style: kTitleTextStyle),
                                  backgroundColor: kWhiteColor,
                                  borderRadius: 8,
                                  onPressed: () => setState(() {
                                    files.clear();
                                  })),
                            ),
                            SizedBox(
                              width: 80,
                              child: WidgetFactory.buildButton(
                                  context: context,
                                  child: const Text('Send', style: kButtonTextStyle,),
                                  backgroundColor: kThemeColor,
                                  borderRadius: 8,
                                  onPressed: () {
                                    sendImg();
                                  }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
