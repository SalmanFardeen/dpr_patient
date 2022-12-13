import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  static final DBService _instance = DBService._();

  DBService._();

  DBService get instance => _instance;



  static createChatRoom(String chatRoomID, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomID)
        .set(chatRoomMap)
        .catchError((err) {
      print(err.toString());
    });
  }

  static addAppointmentTiming(String chatRoomID, msgMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomID)
        .collection('timing')
        .add(msgMap)
        .catchError((err) {
          print(err.toString());
    });
  }

  static getAppointmentTiming(String chatRoomID) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomID)
        .collection("timing")
        .orderBy("start_time")
        .snapshots();
  }

  static addConversationMsgs(String chatRoomID, msgMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomID)
        .collection("chats")
        .add(msgMap)
        .catchError((err) {
      print(err.toString());
    });
  }

  static getConversationMsgs(String chatRoomID) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomID)
        .collection("chats")
        .orderBy("time")
        .snapshots();
  }

  static getChatRooms(int userID) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("user_list", arrayContains: userID)
        .snapshots();
  }

  static createCallRoom(String chatRoomID) {
    return FirebaseFirestore.instance.collection('CallRoom').doc(chatRoomID);
  }

  static joinCallRoom(String chatroomId) {
    return FirebaseFirestore.instance.collection('CallRoom').doc(chatroomId);
  }

  static Future<void> hangup(String roomId) async {
    var db = FirebaseFirestore.instance;
    var roomRef = db.collection('CallRoom').doc(roomId);
    var calleeCandidates = await roomRef.collection('calleeCandidates').get();
    calleeCandidates.docs.forEach((document) => document.reference.delete());

    var callerCandidates = await roomRef.collection('callerCandidates').get();
    callerCandidates.docs.forEach((document) => document.reference.delete());

    await roomRef.delete();
  }
}