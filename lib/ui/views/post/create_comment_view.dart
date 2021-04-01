import 'package:companion/ui/shared/shared_styles.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/post.dart';
import './post_viewmodel.dart';

class CreateCommentView extends StatelessWidget {
  final Post post;

  CreateCommentView({this.post});

  @override
  Widget build(BuildContext context) {
    final bodyController = TextEditingController();

    return ViewModelBuilder<PostViewModel>.reactive(
      viewModelBuilder: () => PostViewModel(),
      onModelReady: (model) => model.fetchPost(post),
      disposeViewModel: true,
      createNewModelOnInsert: true,
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
          title: Text(
            'Add comment',
            style:
                TextStyle(color: model.darkMode ? Colors.white : Colors.black),
          ),
          actions: [
            FlatButton(
              onPressed: () async {
                model.createComment(body: bodyController.text);
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
        body: Container(
          height: double.maxFinite,
          child: Stack(
            children: [
              model.isBusy
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    )
                  : Container(),
              Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    width: double.maxFinite,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        post.title.isEmpty
                            ? Container()
                            : Text(
                                post.title,
                                style: TextStyle(
                                  color: model.darkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        SizedBox(height: 4.0),
                        post.body.isEmpty
                            ? Container()
                            : Text(
                                post.body,
                                style: TextStyle(
                                  color: model.darkMode
                                      ? Colors.white70
                                      : Colors.black87,
                                  fontSize: 15.0,
                                ),
                              ),
                      ],
                    ),
                  ),
                  Divider(),
                  TextField(
                    controller: bodyController,
                    decoration:
                        postInputDecoration.copyWith(hintText: 'Your comment'),
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
