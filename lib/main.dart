import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/common/theme.dart';
import 'package:trackerapp/providers/tracker_provider.dart';
import 'package:trackerapp/screens/home.dart';
import 'package:trackerapp/screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return ChangeNotifierProvider(
      create: (context) => TrackerProvider(),
      child: MaterialApp(
        title: 'Trackers App',
        theme: appTheme,
        initialRoute: '/trackers',
        routes: {
          '/login': (context) => MyLogin(),
          '/trackers': (context) => MyTrackers(),
        },
      ),
    );
  }
}