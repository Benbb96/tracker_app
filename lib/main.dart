import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/common/theme.dart';
import 'package:trackerapp/providers/tracker_provider.dart';
import 'package:trackerapp/screens/home.dart';
import 'package:trackerapp/screens/login.dart';

const String loginRoute = '/login';
const String trackersRoute = '/trackers';

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
        initialRoute: trackersRoute,
        routes: {
          loginRoute: (context) => MyLogin(),
          trackersRoute: (context) => MyTrackers(),
        },
      ),
    );
  }
}