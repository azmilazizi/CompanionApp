import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../chat/chat_view.dart';
import '../explore/explore_view.dart';
import '../feed/feed_view.dart';
import '../notification/notification_view.dart';
import './home_viewmodel.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final titles = ["Feed", "Explore", "", "Notification", "Chat"];
    final searches = [true, true, false, false, false];

    return ViewModelBuilder<HomeViewModel>.reactive(
      disposeViewModel: false,
      fireOnModelReadyOnce: true,
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: model.darkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: model.darkMode ? Colors.black : Colors.white,
          brightness: model.brightness,
          leading: !model.isSearch
              ? Container(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () => _scaffoldKey.currentState.openDrawer(),
                    child: CircleAvatar(
                      child: Image.asset('assets/icons/companion.png'),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: model.darkMode ? Colors.white : Colors.black,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _controller.text = "";
                    model.useSearch(false);
                  },
                ),
          title: searches[model.currentIndex]
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: model.darkMode ? Colors.white12 : Colors.black12,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onTap: () => model.useSearch(true),
                          style: TextStyle(
                            color: model.darkMode ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.grey),
                            isDense: true,
                            icon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  titles[model.currentIndex],
                  style: TextStyle(
                      color: model.darkMode ? Colors.white : Colors.black),
                ),
        ),
        drawer: Drawer(
          child: Container(
            color: model.darkMode ? Colors.black : Colors.white,
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(),
                    currentAccountPicture: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        model.navigateToProfile();
                      },
                      child: CircleAvatar(
                        child: Image.asset('assets/icons/companion.png'),
                      ),
                    ),
                    accountName: Text(
                      model.currentUser != null
                          ? model.currentUser.displayName
                          : "",
                      style: TextStyle(
                        color: model.darkMode ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: Text(
                      model.currentUser != null
                          ? "u/${model.currentUser.username}"
                          : "",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    model.navigateToMyCompanions();
                  },
                  leading: Icon(Icons.person),
                  title: Text('Companions'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    model.navigateToMyCommunities();
                  },
                  leading: Icon(Icons.group),
                  title: Text('Communities'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    model.navigateToSettings();
                  },
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                  child: FlatButton(
                    onPressed: () => model.signOut(),
                    child: Text(
                      'Sign out',
                      style: TextStyle(
                        color: model.darkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: getViewForIndex(model.isSearch, model.currentIndex),
        bottomNavigationBar: !model.isSearch
            ? BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: model.darkMode ? Colors.black : Colors.white,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Colors.grey,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                iconSize: 30,
                currentIndex: model.currentIndex,
                onTap: model.setIndex,
                items: [
                  BottomNavigationBarItem(
                    label: 'Feed',
                    icon: Icon(Icons.crop_square),
                  ),
                  BottomNavigationBarItem(
                    label: 'Explore',
                    icon: Icon(Icons.search),
                  ),
                  BottomNavigationBarItem(
                    label: 'Create Post',
                    icon: Icon(Icons.add_box),
                  ),
                  BottomNavigationBarItem(
                    label: 'Notification',
                    icon: Icon(Icons.favorite_border),
                  ),
                  BottomNavigationBarItem(
                    label: 'Chat',
                    icon: Icon(Icons.chat_bubble_outline),
                  ),
                ],
              )
            : SizedBox(),
      ),
    );
  }

  Widget getViewForIndex(bool isSearch, int index) {
    if (isSearch) return Container();

    switch (index) {
      case 0:
        return FeedView();
        break;
      case 1:
        return ExploreView();
        break;
      case 2:
        return Container();
        break;
      case 3:
        return NotificationView();
        break;
      case 4:
        return ChatView();
        break;
      default:
        return FeedView();
    }
  }
}
