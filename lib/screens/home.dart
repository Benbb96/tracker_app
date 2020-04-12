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
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void checkLoginStatus() async {
    final storage = new FlutterSecureStorage();
    String jwt = await storage.read(key: 'jwt');
    if (jwt == null) {
      // User is not connected, redirect him to login
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(child: CustomScrollView(
        slivers: [
          MyAppBar(),
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(
              child: Center(
                  child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        labelText: 'Commentaire (facultatif)',
                        icon: Icon(Icons.comment),
                      )
                  )
              )
          ),
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          Consumer<TrackerProvider>(
              builder: (context, trackers, child) =>
                  TrackerList(trackers: trackers.allTrackers, commentController: commentController)),
        ],
      ), onRefresh: () {
        return Provider.of<TrackerProvider>(context, listen: false).fetchTrackers(context);
        },)
    );
  }
}

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('Trackers', style: Theme.of(context).textTheme.display4),
      floating: true,
      actions: [
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            final storage = new FlutterSecureStorage();
            await storage.delete(key: 'jwt');
            await storage.delete(key: 'refresh');
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (Route<dynamic> route) => false);
          },
        ),
      ],
    );
  }
}
