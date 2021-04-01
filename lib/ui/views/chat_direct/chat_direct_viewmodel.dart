import '../../../app/locator.dart';

import '../../../services/chat_direct/chat_direct_firestore_service.dart';

import '../../../models/user.dart';
import '../../../models/chat_direct.dart';
import '../../../models/message.dart';
import '../viewmodel.dart';

class ChatDirectViewModel extends ViewModel {
  final ChatDirectFirestoreService _chatDirectFirestoreService =
      locator<ChatDirectFirestoreService>();

  ChatDirect _chatDirect;
  ChatDirect get chatDirect => _chatDirect;

  User _user;
  User get user => _user;

  Future initialise(ChatDirect target, User user) async {
    setBusy(true);
    _user = user;
    fetchChatDirect(target);
    setBusy(false);
  }

  Future fetchChatDirect(ChatDirect target) async {
    setBusy(true);
    _chatDirect = target;
    _chatDirect = await _chatDirectFirestoreService.getChatDirect(target.id);
    setBusy(false);
  }

  Future sendMessage(String body) async {
    setBusy(true);
    final message = Message.createNew(
      author: currentUser.id,
      body: body,
    );
    _chatDirect.logs.add(message);
    await _chatDirectFirestoreService.updateChatDirect(
      _chatDirect.id,
      logs: _chatDirect.logs,
      lastUpdated: DateTime.now(),
    );
    fetchChatDirect(_chatDirect);
    setBusy(false);
  }
}
