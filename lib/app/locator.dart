import 'package:get_it/get_it.dart';

import '../services/theme_service.dart';
import '../services/navigation_service.dart';
import '../services/dialog_service.dart';
import '../services/push_notification_service.dart';
import '../utils/image_selector.dart';

import '../services/authentication_service.dart';
import '../services/user/user_firestore_service.dart';
import '../services/community/community_firestore_service.dart';
import '../services/post/post_firestore_service.dart';
import '../services/comment/comment_firestore_service.dart';
import '../services/chat_direct/chat_direct_firestore_service.dart';
import '../services/chat_room/chat_room_firestore_service.dart';

import '../services/rest_service.dart';
import '../services/user/user_rest_service.dart';
import '../services/community/community_rest_service.dart';
import '../services/post/post_rest_service.dart';
import '../services/comment/comment_rest_service.dart';

import '../ui/views/home/home_viewmodel.dart';
import '../ui/views/initial/splash_viewmodel.dart';
import '../ui/views/initial/login_viewmodel.dart';
import '../ui/views/initial/register_viewmodel.dart';
import '../ui/views/initial/setup_user_viewmodel.dart';
import '../ui/views/feed/feed_viewmodel.dart';
import '../ui/views/explore/explore_viewmodel.dart';
import '../ui/views/create_community/create_community_viewmodel.dart';
import '../ui/views/create_post/create_post_viewmodel.dart';
import '../ui/views/notification/notification_viewmodel.dart';
import '../ui/views/chat/chat_viewmodel.dart';
import '../ui/views/chat/create_chat_viewmodel.dart';
import '../ui/views/misc/communities_viewmodel.dart';
import '../ui/views/misc/companions_viewmodel.dart';
import '../ui/views/settings/settings_viewmodel.dart';
import '../ui/views/user/user_viewmodel.dart';
import '../ui/views/user/edit_user_viewmodel.dart';
import '../ui/views/community/community_viewmodel.dart';
import '../ui/views/post/post_viewmodel.dart';
import '../ui/views/chat_direct/chat_direct_viewmodel.dart';

final GetIt locator = GetIt.instance;

void initializeLocator() {
  // Services
  locator.registerLazySingleton(() => ThemeService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => ImageSelector());

  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => UserFirestoreService());
  locator.registerLazySingleton(() => CommunityFirestoreService());
  locator.registerLazySingleton(() => PostFirestoreService());
  locator.registerLazySingleton(() => CommentFirestoreService());
  locator.registerLazySingleton(() => ChatDirectFirestoreService());
  locator.registerLazySingleton(() => ChatRoomFirestoreService());

  locator.registerLazySingleton(() => RestService());
  locator.registerLazySingleton(() => UserRestService());
  locator.registerLazySingleton(() => CommunityRestService());
  locator.registerLazySingleton(() => PostRestService());
  locator.registerLazySingleton(() => CommentRestService());

  // Viewmodels
  locator.registerLazySingleton(() => SplashViewModel());
  locator.registerLazySingleton(() => LoginViewModel());
  locator.registerLazySingleton(() => RegisterViewModel());
  locator.registerLazySingleton(() => SetupUserViewModel());
  locator.registerLazySingleton(() => HomeViewModel());
  locator.registerLazySingleton(() => FeedViewModel());
  locator.registerLazySingleton(() => ExploreViewModel());
  locator.registerLazySingleton(() => CreateCommunityViewModel());
  locator.registerLazySingleton(() => CreatePostViewModel());
  locator.registerLazySingleton(() => NotificationViewModel());
  locator.registerLazySingleton(() => ChatViewModel());
  locator.registerLazySingleton(() => CreateChatViewModel());
  locator.registerLazySingleton(() => CompanionsViewModel());
  locator.registerLazySingleton(() => CommunitiesViewModel());
  locator.registerLazySingleton(() => SettingsViewModel());
  locator.registerLazySingleton(() => UserViewModel());
  locator.registerLazySingleton(() => EditUserViewModel());
  locator.registerLazySingleton(() => CommunityViewModel());
  locator.registerLazySingleton(() => PostViewModel());
  locator.registerLazySingleton(() => ChatDirectViewModel());
}
