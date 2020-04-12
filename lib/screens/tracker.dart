import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/models/track.dart';
import 'package:trackerapp/providers/tracker_provider.dart';
import 'package:trackerapp/widgets/my_app_bar.dart';
import 'package:trackerapp/models/tracker.dart';

class TrackerDetail extends StatelessWidget {
  static const routeName = '/tracker';
  @override
  Widget build(BuildContext context) {
    final Tracker tracker = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: RefreshIndicator(child: CustomScrollView(
        slivers: [
          MyAppBar(title: tracker.name),
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          TracksList(tracks: tracker.tracks),
        ],
      ), onRefresh: () {
        return Provider.of<TrackerProvider>(context, listen: false).fetchTrackers(context);
        },)
    );
  }
}

class TracksList extends StatelessWidget {
  final List<Track> tracks;

  TracksList({@required this.tracks});

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => Container(
                  height: 50.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          Text(tracks[index].getFormatedDateTime, style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Expanded(child: Text(tracks[index].commentaire)),
                        ],
                      )
                    ),
                  ),
                ),
            childCount: tracks.length
        )
    );
  }
}
