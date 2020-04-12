import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyAppBar extends StatelessWidget {
  final String title;

  const MyAppBar({Key key, this.title='Trackers'});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(title, style: Theme.of(context).textTheme.display4),
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