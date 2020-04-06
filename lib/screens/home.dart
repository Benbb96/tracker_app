import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/providers/tracker_provider.dart';
import 'package:trackerapp/widgets/tracker_list.dart';

class MyTrackers extends StatefulWidget {
  @override
  MyTrackersState createState() => MyTrackersState();
}

class MyTrackersState extends State<MyTrackers> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    final storage = new FlutterSecureStorage();
    String jwt = await storage.read(key: 'jwt');
    if (jwt == null) {
      // User is not connected, redirect him to login
      Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _MyAppBar(),
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          Consumer<TrackerProvider>(builder: (context, trackers, child) => TrackerList(trackers: trackers.allTrackers)),
        ],
      ),
    );
  }
}

class _MyAppBar extends StatelessWidget {
  removeToken() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: 'jwt');
    await storage.delete(key: 'refresh');
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('Trackers', style: Theme.of(context).textTheme.display4),
      floating: true,
      actions: [
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            removeToken();
            Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
          },
        ),
      ],
    );
  }
}
