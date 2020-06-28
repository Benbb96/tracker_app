import 'package:flutter/material.dart';
import 'package:trackerapp/common/hex_color.dart';
import 'package:trackerapp/models/tracker.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/providers/tracker_provider.dart';
import 'package:trackerapp/screens/tracker.dart';

class TrackerList extends StatelessWidget {
  final List<Tracker> trackers;
  final TextEditingController commentController;

  TrackerList({@required this.trackers, @required this.commentController});

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) =>
                TrackerListItem(trackers[index], commentController),
            childCount: trackers.length));
  }
}

class TrackerListItem extends StatelessWidget {
  final Tracker tracker;
  final TextEditingController commentController;

  TrackerListItem(this.tracker, this.commentController, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme.title;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: HexColor(tracker.color),
                child: Center(
                  child: Text(
                      tracker.tracks.length.toString(),
                      style: TextStyle(color: HexColor(tracker.contrastColor))
                  ),
                ),
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      TrackerDetail.routeName,
                      arguments: tracker,
                    );
                  },
                  child: Text(tracker.name, style: textTheme)),
            ),
            SizedBox(width: 24),
            _PlusOneButton(
                tracker: tracker, commentController: commentController),
          ],
        ),
      ),
    );
  }
}

class _PlusOneButton extends StatelessWidget {
  final Tracker tracker;
  final TextEditingController commentController;

  const _PlusOneButton(
      {Key key, @required this.tracker, @required this.commentController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        String name = tracker.name;
        print('Add one track for $name');
        Provider.of<TrackerProvider>(context, listen: false)
            .plusOneTrack(tracker, commentController.text, context);
        commentController.clear();
      },
      splashColor: Theme.of(context).primaryColor,
      child: Icon(Icons.plus_one, semanticLabel: '+1'),
    );
  }
}
