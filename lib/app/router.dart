import 'package:flutter/material.dart';
import 'route_transitions.dart';

import '../ui/views/initial/splash_view.dart';
import '../ui/views/initial/login_view.dart';
import '../ui/views/initial/register_view.dart';
import '../ui/views/initial/setup_user_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/feed/feed_view.dart';
import '../ui/views/explore/explore_view.dart';
import '../ui/views/create_community/create_community_view.dart';
import '../ui/views/create_post/create_post_view.dart';
import '../ui/views/create_post/select_where_to_post_view.dart';
import '../ui/views/notification/notification_view.dart';
import '../ui/views/chat/chat_view.dart';
import '../ui/views/chat/create_chat_view.dart';
import '../ui/views/misc/companions_view.dart';
import '../ui/views/misc/communities_view.dart';
import '../ui/views/settings/settings_view.dart';

import '../ui/views/user/user_view.dart';
import '../ui/views/user/edit_user_view.dart';
import '../ui/views/community/community_view.dart';
import '../ui/views/post/post_view.dart';
import '../ui/views/post/create_comment_view.dart';
import '../ui/views/chat_direct/chat_direct_view.dart';

const String SplashViewRoute = '/splash';
const String LoginViewRoute = '/login';
const String RegisterViewRoute = '/register';
const String SetupUserViewRoute = '/setupUser';
const String HomeViewRoute = '/';
const String FeedViewRoute = '/feed';
const String ExploreViewRoute = '/explore';
const String CreateCommunityViewRoute = '/createCommunity';
const String CreatePostViewRoute = '/createPost';
const String SelectWhereToPostViewRoute = '/selectWhereToPost';
const String NotificationViewRoute = '/notification';
const String ChatViewRoute = '/chat';
const String CreateChatViewRoute = '/createChat';
const String MyCompanionsViewRoute = '/myCompanions';
const String MyCommunitiesViewRoute = '/myCommunities';
const String SettingsViewRoute = '/settings';

const String UserViewRoute = '/user';
const String EditUserViewRoute = '/editUser';
const String CommunityViewRoute = '/community';
const String PostViewRoute = '/post';
const String CreateCommentViewRoute = '/createComment';
const String ChatDirectViewRoute = '/chatDirect';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashViewRoute:
      return ScaleRoute(page: SplashView());
    case LoginViewRoute:
      return ScaleRoute(page: LoginView());
    case SetupUserViewRoute:
      return FadeRoute(page: SetupUserView());
    case RegisterViewRoute:
      return FadeRoute(page: RegisterView());
    case HomeViewRoute:
      return FadeRoute(page: HomeView());
    case FeedViewRoute:
      return FadeRoute(page: FeedView());
    case ExploreViewRoute:
      return FadeRoute(page: ExploreView());
    case CreateCommunityViewRoute:
      return FadeRoute(page: CreateCommunityView());
    case CreatePostViewRoute:
      return SlideUpRoute(page: CreatePostView());
    case SelectWhereToPostViewRoute:
      return SlideUpRoute(page: SelectWhereToPostView());
    case NotificationViewRoute:
      return FadeRoute(page: NotificationView());
    case ChatViewRoute:
      return FadeRoute(page: ChatView());
    case CreateChatViewRoute:
      return SlideUpRoute(page: CreateChatView());
    case MyCompanionsViewRoute:
      var user = (settings.arguments as Map)['user'];
      return SlideLeftRoute(page: CompanionsView(user: user));
    case MyCommunitiesViewRoute:
      var user = (settings.arguments as Map)['user'];
      return SlideLeftRoute(page: CommunitiesView(user: user));
    case SettingsViewRoute:
      return SlideLeftRoute(page: SettingsView());
    case UserViewRoute:
      var user = (settings.arguments as Map)['user'];
      return SlideLeftRoute(page: UserView(user: user));
    case EditUserViewRoute:
      return SlideLeftRoute(page: EditUserView());
    case CommunityViewRoute:
      var community = (settings.arguments as Map)['community'];
      return SlideLeftRoute(page: CommunityView(community: community));
    case PostViewRoute:
      var user = (settings.arguments as Map)['user'];
      var community = (settings.arguments as Map)['community'];
      var post = (settings.arguments as Map)['post'];
      return SlideLeftRoute(
          page: PostView(user: user, community: community, post: post));
    case CreateCommentViewRoute:
      var post = (settings.arguments as Map)['post'];
      return SlideUpRoute(page: CreateCommentView(post: post));
    case ChatDirectViewRoute:
      var user = (settings.arguments as Map)['user'];
      var chatDirect = (settings.arguments as Map)['chatDirect'];
      return SlideLeftRoute(
          page: ChatDirectView(user: user, chatDirect: chatDirect));
  }
  return null;
}
