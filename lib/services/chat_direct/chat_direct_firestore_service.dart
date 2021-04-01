import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/chat_direct.dart';
import '../../models/message.dart';

class ChatDirectFirestoreService {
  final CollectionReference _chatDirectsRef =
      FirebaseFirestore.instance.collection('chatDirects');

  Future<ChatDirect> getChatDirect(String id) async {
    DocumentSnapshot snapshot = await _chatDirectsRef.doc(id).get();
    return ChatDirect.fromSnapshot(snapshot);
  }

  Future<List<ChatDirect>> getChatDirects() async {
    QuerySnapshot snapshots = await _chatDirectsRef.get();
    return snapshots.docs
        .map((snapshot) => ChatDirect.fromSnapshot(snapshot))
        .toList();
  }

  Future<List<ChatDirect>> getChatDirectsFromIds(List<String> ids) async {
    QuerySnapshot snapshots =
        await _chatDirectsRef.where(FieldPath.documentId, whereIn: ids).get();
    return snapshots.docs.map((snapshot) {
      return ChatDirect.fromSnapshot(snapshot);
    }).toList();
  }

  Future createChatDirect(ChatDirect chatDirect) async {
    return _chatDirectsRef.add(chatDirect.toJson());
  }

  Future updateChatDirect(
    String id, {
    List<Message> logs,
    DateTime lastUpdated,
  }) async {
    Map<String, dynamic> data = Map();
    ({
      'logs': logs.map((e) => e.toJson()).toList(),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    }).forEach((key, value) {
      if (value != null) data[key] = value;
    });

    return _chatDirectsRef.doc(id).update(data);
  }

  Future deleteChatDirect(String id) async {
    await _chatDirectsRef.doc(id).delete();
  }
}
