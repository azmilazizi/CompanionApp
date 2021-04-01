import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../ui/shared/shared_styles.dart';
import './widgets/companion_item.dart';
import './create_chat_viewmodel.dart';

class CreateChatView extends StatefulWidget {
  @override
  _CreateChatViewState createState() => _CreateChatViewState();
}

class _CreateChatViewState extends State<CreateChatView> {
  String groupName = '';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateChatViewModel>.reactive(
      viewModelBuilder: () => CreateChatViewModel(),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: model.darkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: model.darkMode ? Colors.black : Colors.white,
          brightness: model.brightness,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: model.darkMode ? Colors.white : Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
          iconTheme: IconThemeData(
            color: model.darkMode ? Colors.white : Colors.black,
          ),
          title: Text(
            'New chat',
            style:
                TextStyle(color: model.darkMode ? Colors.white : Colors.black),
          ),
          actions: [
            FlatButton(
              onPressed: model.participants.length == 1
                  ? () => model.createChatDirect()
                  : model.participants.length > 1 && groupName.isNotEmpty
                      ? () => model.createChatRoom(name: groupName)
                      : null,
              child: Text(
                "Start Chat",
                style: TextStyle(
                    color: model.participants.length == 1
                        ? Theme.of(context).primaryColor
                        : model.participants.length > 1 && groupName.isNotEmpty
                            ? Theme.of(context).primaryColor
                            : Colors.grey),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 10),
                if (model.participants.length > 1)
                  TextField(
                    onChanged: (val) => setState(() => groupName = val),
                    decoration: postInputDecoration.copyWith(
                        hintText: 'Group name (required)'),
                  ),
                if (model.participants.length > 1) Divider(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text('To: '),
                      ),
                      SizedBox(width: 10),
                      Wrap(
                        spacing: 10,
                        children: [
                          for (var participant in model.participants)
                            ActionChip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              label: Text(
                                participant.displayName,
                                style: TextStyle(fontSize: 12),
                              ),
                              onPressed: () => model.deleteParticipantAt(
                                  model.participants.indexOf(participant)),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(),
                if (model.companions.isNotEmpty)
                  for (var companion in model.companions)
                    GestureDetector(
                      onTap: model.participants.contains(companion)
                          ? () => model.deleteParticipant(companion)
                          : () => model.addParticipant(companion),
                      child: CompanionItem(
                        user: companion,
                        value: model.participants.contains(companion),
                        darkMode: model.darkMode,
                      ),
                    )
                else
                  ListTile(
                    title: Center(
                      child: Text(
                        "There's no companion to show",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
