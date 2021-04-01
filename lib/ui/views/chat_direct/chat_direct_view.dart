import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/router.dart';

import '../../../models/user.dart';
import '../../../models/chat_direct.dart';
import 'chat_direct_viewmodel.dart';

class ChatDirectView extends StatelessWidget {
  final bodyController = TextEditingController();
  final User user;
  final ChatDirect chatDirect;

  ChatDirectView({this.user, this.chatDirect});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatDirectViewModel>.reactive(
      viewModelBuilder: () => ChatDirectViewModel(),
      onModelReady: (model) => model.initialise(chatDirect, user),
      disposeViewModel: true,
      createNewModelOnInsert: true,
      builder: (context, model, child) => Scaffold(
        backgroundColor: model.darkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: model.darkMode ? Colors.black : Colors.white,
          brightness: model.brightness,
          iconTheme: IconThemeData(
            color: model.darkMode ? Colors.white : Colors.black,
          ),
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, UserViewRoute, arguments: {
                    'user': user,
                  });
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(width: 10),
              Text(
                '${user.displayName}',
                style: TextStyle(
                    color: model.darkMode ? Colors.white : Colors.black),
              ),
            ],
          ),
          actions: [
            IconButton(
              color: Colors.grey,
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Flexible(
              child: model.chatDirect.logs.length > 0
                  ? ListView.builder(
                      itemCount: model.chatDirect.logs.length,
                      itemBuilder: (context, index) {
                        final message = model.chatDirect.logs[index];
                        return message.author == model.currentUser.id
                            ? ListTile(
                                trailing: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("${model.currentUser.displayName}"),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "${message.body}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: model.darkMode
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                        '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}'),
                                  ],
                                ),
                              )
                            : ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                title: Row(
                                  children: [
                                    Text("${model.user.displayName}"),
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "${message.body}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: model.darkMode
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                        '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}'),
                                  ],
                                ),
                              );
                      },
                    )
                  : Center(
                      child: Text(
                        "No message has been sent",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
            Divider(
              height: 1.0,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                minLines: 1,
                maxLines: 10,
                controller: bodyController,
                style: TextStyle(
                    color: model.darkMode ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter your message',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      if (bodyController.text.isNotEmpty) {
                        FocusScope.of(context).unfocus();
                        model.sendMessage(bodyController.text);
                        bodyController.clear();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
