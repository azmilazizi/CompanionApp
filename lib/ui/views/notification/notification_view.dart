import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import './notification_viewmodel.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView>
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
    final tabs = <Tab>[Tab(text: 'All'), Tab(text: 'Mention')];

    return ViewModelBuilder<NotificationViewModel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => NotificationViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: model.darkMode ? Colors.black : Colors.white,
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
                  ListView(),
                  ListView(),
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
