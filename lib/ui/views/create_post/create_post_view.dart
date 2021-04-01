import 'package:companion/ui/shared/shared_styles.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'create_post_viewmodel.dart';

class CreatePostView extends StatefulWidget {
  @override
  _CreatePostViewState createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  String title = '';
  String body = '';
  String tag = '';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreatePostViewModel>.reactive(
      viewModelBuilder: () => CreatePostViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: model.darkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: model.darkMode ? Colors.black : Colors.white,
          brightness: model.brightness,
          leading: IconButton(
            icon: Icon(Icons.close),
            color: model.darkMode ? Colors.white : Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
          iconTheme: IconThemeData(
            color: model.darkMode ? Colors.white : Colors.black,
          ),
          actions: [
            FlatButton(
              onPressed: () async {
                model.createPost(title: title, body: body);
                await Future.delayed(Duration(seconds: 1));
                Navigator.pop(context);
              },
              child: Text(
                "Post",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 128,
            child: Column(
              children: [
                SizedBox(height: 10),
                ListTile(
                  leading: CircleAvatar(
                    radius: 16.0,
                    child: Image.asset('assets/icons/companion.png'),
                  ),
                  title: Text(
                    model.target == null
                        ? 'Select where to post ▼'
                        : model.target == model.currentUser
                            ? 'Personal profile'
                            : 'c/${model.target.name}',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  onTap: () => model.selectWhereToPost(),
                ),
                Divider(),
                TextField(
                  onChanged: (val) => setState(() => title = val),
                  decoration: postInputDecoration.copyWith(
                      hintText: 'An interesting title'),
                ),
                Divider(),
                TextField(
                  onChanged: (val) => setState(() => body = val),
                  decoration: postInputDecoration.copyWith(
                      hintText: 'Your post content'),
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                ),
                model.isBusy
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      )
                    : Container(),
                Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 10,
                        children: [
                          for (var tag in model.tags)
                            ActionChip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              label: Text(
                                tag,
                                style: TextStyle(fontSize: 12),
                              ),
                              onPressed: () =>
                                  model.deleteTag(model.tags.indexOf(tag)),
                            ),
                        ],
                      ),
                      TextField(
                        style: TextStyle(
                            color:
                                model.darkMode ? Colors.white : Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Add tags',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add_circle),
                            onPressed: () {
                              if (tag.isNotEmpty) model.addTag(tag);
                            },
                          ),
                        ),
                        onChanged: (val) => setState(() => tag = val),
                      ),
                    ],
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
