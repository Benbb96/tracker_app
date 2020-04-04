import 'package:flutter/material.dart';
import 'package:trackerapp/common/hex_color.dart';
import 'package:trackerapp/models/tracker.dart';

class TrackerList extends StatelessWidget {
  final List<Tracker> trackers;

  TrackerList({@required this.trackers});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => _TrackerListItem(trackers[index]),
          childCount: trackers.length
      )
    );
  }
}

class _PlusOneButton extends StatelessWidget {
  final Tracker tracker;

  const _PlusOneButton({Key key, @required this.tracker}) : super(key: key);

  plusOneTrack() {
    String name = tracker.name;
    print('Add one track for $name');
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: plusOneTrack(),
      splashColor: Theme.of(context).primaryColor,
      child: Icon(Icons.plus_one, semanticLabel: '+1'),
    );
  }
}

class _TrackerListItem extends StatelessWidget {
  final Tracker tracker;

  _TrackerListItem(this.tracker, {Key key}) : super(key: key);

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
