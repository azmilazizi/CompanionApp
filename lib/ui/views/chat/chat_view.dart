import 'package:companion/ui/views/chat/widgets/chat_direct_item.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import './chat_viewmodel.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <Tab>[Tab(text: 'Direct'), Tab(text: 'Room')];

    return ViewModelBuilder<ChatViewModel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => ChatViewModel(),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: model.darkMode ? Colors.black : Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => model.navigateToCreateChat(),
          child: Icon(
            Icons.mail_outline,
            size: 32.0,
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            Container(
              color: model.darkMode ? Colors.black : Colors.white,
              child: TabBar(
                tabs: tabs,
                controller: controller,
                labelColor: Theme.of(context).primaryColor,
                indicatorColor: Theme.of(context).primaryColor,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  !model.isBusy
                      ? model.chatDirects.isNotEmpty
                          ? ListView.builder(
                              itemCount: model.chatDirects.length,
                              itemBuilder: (context, index) {
                                final chatDirect = model.chatDirects[index];
                                final userId = chatDirect.users.firstWhere(
                                    (userId) => userId != model.currentUser.id);
                                return ChatDirectItem(
                                    user: model.getChatDirectUser(userId),
                                    chatDirect: chatDirect,
                                    darkMode: model.darkMode);
                              })
                          : Center(
                              child: Text(
                                "Ooops! There's no message here",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                        ),
                  !model.isBusy
                      ? model.chatRooms.isNotEmpty
                          ? ListView.builder(
                              itemCount: model.chatRooms.length,
                              itemBuilder: (context, index) {
                                final chatRoom = model.chatRooms[index];
                                return ListTile();
                              })
                          : Center(
                              child: Text(
                                "Ooops! There's no message here",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                        ),
                ],
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
