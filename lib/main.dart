import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/common/theme.dart';
import 'package:trackerapp/providers/tracker_provider.dart';
import 'package:trackerapp/screens/home.dart';
import 'package:trackerapp/screens/login.dart';
import 'package:trackerapp/screens/tracker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return ChangeNotifierProvider(
      create: (context) => TrackerProvider(context),
      child: MaterialApp(
        title: 'Trackers App',
        theme: appTheme,
        initialRoute: MyTrackers.routeName,
        routes: {
          MyLogin.routeName: (context) => MyLogin(),
          MyTrackers.routeName: (context) => MyTrackers(),
          TrackerDetail.routeName: (context) => TrackerDetail(),
        },
      ),
    );
  }
}