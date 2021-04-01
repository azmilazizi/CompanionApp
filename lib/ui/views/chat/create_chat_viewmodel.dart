import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../app/router.dart';
import '../../../app/locator.dart';

import '../../../services/navigation_service.dart';
import '../../../services/user/user_firestore_service.dart';
import '../../../services/chat_direct/chat_direct_firestore_service.dart';
import '../../../services/chat_room/chat_room_firestore_service.dart';

import '../../../models/user.dart';
import '../../../models/chat_direct.dart';
import '../../../models/chat_room.dart';
import '../viewmodel.dart';

class CreateChatViewModel extends ViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserFirestoreService _userFirestoreService =
      locator<UserFirestoreService>();
  final ChatDirectFirestoreService _chatDirectFirestoreService =
      locator<ChatDirectFirestoreService>();
  final ChatRoomFirestoreService _chatRoomFirestoreService =
      locator<ChatRoomFirestoreService>();

  List<User> _companions = [];
  List<User> get companions => _companions;

  List<User> _participants = [];
  List<User> get participants => _participants;

  void addParticipant(User participant) {
    if (!_participants.contains(participant)) _participants.add(participant);
    notifyListeners();
  }

  void deleteParticipant(participant) {
    _participants.remove(participant);
    notifyListeners();
  }

  void deleteParticipantAt(int index) {
    _participants.removeAt(index);
    notifyListeners();
  }

  Future initialise() async {
    setBusy(true);
    if (currentUser != null) {
      final companions = currentUser.companions;
      if (companions.isNotEmpty)
        _companions = await _userFirestoreService.getUsersFromIds(companions);
    }
    setBusy(false);
  }

  Future createChatDirect() async {
    final users = _participants.map((user) => user.id).toList();
    users.add(currentUser.id);

    final chatDirect = ChatDirect.createNew(users: users);
    final result =
        await _chatDirectFirestoreService.createChatDirect(chatDirect);

    final tempUser = currentUser;
    if (result is DocumentReference) {
      chatDirect.id = result.id;
      tempUser.chatDirects.add(result.id);
    } else if (result is Map) {
      chatDirect.id = result['id'];
      tempUser.chatDirects.add(result['id']);
    }

    await _userFirestoreService.updateUser(
      tempUser.id,
      chatDirects: tempUser.chatDirects,
    );

    for (var participant in _participants) {
      final tempUser = participant;
      if (result is DocumentReference)
        tempUser.chatDirects.add(result.id);
      else if (result is Map) tempUser.chatDirects.add(result['id']);

      await _userFirestoreService.updateUser(
        tempUser.id,
        chatDirects: tempUser.chatDirects,
      );
    }

    await navigateToChatDirect(
        chatDirect,
        getUser(
            chatDirect.users.firstWhere((userId) => userId != currentUser.id)));
  }

  Future createChatRoom({@required String name}) async {}

  Future navigateToChatDirect(ChatDirect chatDirect, User user) async {
    await _navigationService.navigateReplacementTo(ChatDirectViewRoute,
        arguments: {'chatDirect': chatDirect, 'user': user});
  }

  User getUser(String id) => _companions.firstWhere((user) => user.id == id);
}
