import 'package:flutter/material.dart';
import 'package:trackerapp/common/hex_color.dart';
import 'package:trackerapp/models/tracker.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/providers/tracker_provider.dart';

class TrackerList extends StatelessWidget {
  final List<Tracker> trackers;

  TrackerList({@required this.trackers});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => TrackerListItem(trackers[index]),
          childCount: trackers.length
      )
    );
  }
}

class _PlusOneButton extends StatelessWidget {
  final Tracker tracker;

  const _PlusOneButton({Key key, @required this.tracker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        String name = tracker.name;
        print('Add one track for $name');
        Provider.of<TrackerProvider>(context, listen: false).plusOneTrack(tracker, context);
      },
      splashColor: Theme.of(context).primaryColor,
      child: Icon(Icons.plus_one, semanticLabel: '+1'),
    );
  }
}

class TrackerListItem extends StatelessWidget {
  final Tracker tracker;

  TrackerListItem(this.tracker, {Key key}) : super(key: key);

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
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: Text(tracker.name, style: textTheme),
            ),
            SizedBox(width: 24),
            _PlusOneButton(tracker: tracker),
          ],
        ),
      ),
    );
  }
}
