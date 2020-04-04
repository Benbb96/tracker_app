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
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    String jwt = await storage.read(key: 'jwt');
    print(jwt);
    if (jwt == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
    } else {

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
