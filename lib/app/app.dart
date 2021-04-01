import 'package:flutter/material.dart';

import '../app/router.dart';
import '../app/locator.dart';
import '../services/theme_service.dart';
import '../services/navigation_service.dart';
import '../services/dialog_service.dart';
import '../managers/dialog_manager.dart';

class App extends StatefulWidget {
  const App({
    Key key,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  bool darkMode;
  Brightness brightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    brightness = WidgetsBinding.instance.window.platformBrightness;
    darkMode = brightness == Brightness.dark;
    locator<ThemeService>().useDarkMode(darkMode);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    brightness = WidgetsBinding.instance.window.platformBrightness;
    darkMode = brightness == Brightness.dark;
    locator<ThemeService>().useDarkMode(darkMode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Companion',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: ThemeData.light().copyWith(primaryColor: Colors.teal),
      darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.teal),
      themeMode:
          locator<ThemeService>().darkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: SplashViewRoute,
      onGenerateRoute: generateRoute,
    );
  }
}
