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

class ChatViewModel extends ViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserFirestoreService _userFirestoreService =
      locator<UserFirestoreService>();
  final ChatDirectFirestoreService _chatDirectFirestoreService =
      locator<ChatDirectFirestoreService>();
  final ChatRoomFirestoreService _chatRoomFirestoreService =
      locator<ChatRoomFirestoreService>();

  List<User> _chatDirectUsers = [];
  List<User> get chatDirectUsers => _chatDirectUsers;

  List<User> _chatRoomUsers = [];
  List<User> get chatRoomUsers => _chatRoomUsers;

  List<ChatDirect> _chatDirects = [];
  List<ChatDirect> get chatDirects => _chatDirects;

  List<ChatRoom> _chatRooms = [];
  List<ChatRoom> get chatRooms => _chatRooms;

  Future initialise() async {
    setBusy(true);
    if (currentUser != null) {
      await getChatDirects();
      await getChatRooms();
    }
    setBusy(false);
  }

  Future getChatDirects() async {
    setBusy(true);
    final chatDirects = [...currentUser.chatDirects];

    // retrieve chatDirects
    if (chatDirects.isNotEmpty) {
      _chatDirects =
          await _chatDirectFirestoreService.getChatDirectsFromIds(chatDirects);
      _chatDirects.sort((b, a) => a.lastUpdated.millisecondsSinceEpoch
          .compareTo(b.lastUpdated.millisecondsSinceEpoch));

      final users = _chatDirects.map((chat) {
        for (var user in chat.users) if (user != currentUser.id) return user;
      }).toList();

      _chatDirectUsers = await _userFirestoreService.getUsersFromIds(users);
    }
    setBusy(false);
  }

  Future getChatRooms() async {
    setBusy(true);
    final chatRooms = [...currentUser.chatRooms];

    // retrieve chatRooms
    if (chatRooms.isNotEmpty) {
      _chatRooms =
          await _chatRoomFirestoreService.getChatRoomsFromIds(chatRooms);
      _chatRooms.sort((b, a) => a.lastUpdated.millisecondsSinceEpoch
          .compareTo(b.lastUpdated.millisecondsSinceEpoch));

      final users = _chatRooms.map((chat) {
        for (var user in chat.users) if (user != currentUser.id) return user;
      }).toList();

      _chatRoomUsers = await _userFirestoreService.getUsersFromIds(users);
    }
    setBusy(false);
  }

  Future navigateToCreateChat() async {
    await _navigationService.navigateTo(CreateChatViewRoute);
    await initialise();
  }

  User getChatDirectUser(String id) =>
      _chatDirectUsers.firstWhere((author) => author.id == id);

  User getChatRoomUser(String id) =>
      _chatRoomUsers.firstWhere((author) => author.id == id);
}
