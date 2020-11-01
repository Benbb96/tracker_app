import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trackerapp/common/hex_color.dart';

class MyAppBar extends StatelessWidget {
  final String title;
  final String color;
  final String contrastColor;

  const MyAppBar({Key key, this.title='Trackers', this.color='#795548', this.contrastColor='#000000'});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: HexColor(color),
      iconTheme: IconThemeData(
        color: HexColor(contrastColor),
      ),
      title: Text(title, style: TextStyle(
        fontFamily: 'Corben',
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: HexColor(contrastColor),
      )),
      floating: true,
      actions: [
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            final storage = new FlutterSecureStorage();
            await storage.deleteAll();
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (Route<dynamic> route) => false);
          },
        ),
      ],
    );
  }
}