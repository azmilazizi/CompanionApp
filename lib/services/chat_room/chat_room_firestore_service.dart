import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/chat_room.dart';
import '../../models/message.dart';

class ChatRoomFirestoreService {
  final CollectionReference _chatRoomsRef =
      FirebaseFirestore.instance.collection('chatRooms');

  Future<ChatRoom> getChatRoom(String id) async {
    DocumentSnapshot snapshot = await _chatRoomsRef.doc(id).get();
    return ChatRoom.fromSnapshot(snapshot);
  }

  Future<List<ChatRoom>> getChatRooms() async {
    QuerySnapshot snapshots = await _chatRoomsRef.get();
    return snapshots.docs
        .map((snapshot) => ChatRoom.fromSnapshot(snapshot))
        .toList();
  }

  Future<List<ChatRoom>> getChatRoomsFromIds(List<String> ids) async {
    QuerySnapshot snapshots =
        await _chatRoomsRef.where(FieldPath.documentId, whereIn: ids).get();
    return snapshots.docs.map((snapshot) {
      return ChatRoom.fromSnapshot(snapshot);
    }).toList();
  }

  Future createChatRoom(ChatRoom chatRoom) async {
    return _chatRoomsRef.add(chatRoom.toJson());
  }

  Future updateChatRoom(
    String id, {
    String name,
    String description,
    int userCount,
    List<String> users,
    List<String> admins,
    List<Message> logs,
    DateTime lastUpdated,
  }) async {
    Map<String, dynamic> data = Map();
    ({
      'name': name,
      'description': description,
      'userCount': userCount,
      'users': users,
      'admins': admins,
      'logs': logs.map((e) => e.toJson()).toList(),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    }).forEach((key, value) {
      if (value != null) data[key] = value;
    });

    return _chatRoomsRef.doc(id).update(data);
  }

  Future deleteChatRoom(String id) async {
    await _chatRoomsRef.doc(id).delete();
  }
}
