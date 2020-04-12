import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:trackerapp/models/track.dart';
import 'package:trackerapp/models/tracker.dart';

class TrackerProvider extends ChangeNotifier {
  static final String baseApiUrl = 'http://192.168.1.85:8000/fr/tracker/api';
//  static final String baseApiUrl = 'https://www.benbb96.com/fr/tracker/api';

  static final String baseApiTracker = '$baseApiUrl/tracker';
  static final String baseApiTrack = '$baseApiUrl/track';

  final storage = new FlutterSecureStorage();
  List<Tracker> _trackers = [];
  List<Tracker> get allTrackers => _trackers;

  TrackerProvider(context) {
    fetchTrackers(context);
  }

  fetchTrackers(context) async {
    String jwt = await storage.read(key: 'jwt');
    print(jwt);
    if (jwt == null) {
      print('No JWT');
      _trackers = [];
      return;
    }

    final response = await http.get(baseApiTracker, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $jwt"
    });
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes)) as List;
      _trackers = data.map<Tracker>((json) => Tracker.fromJson(json)).toList();
      notifyListeners();
    } else {
      print("Cannot fecth trackers");
      print(response.body);
      if (response.statusCode == 401) {
        refreshToken(context);
      }
    }
  }

  void refreshToken(context) async {
    String refresh = await storage.read(key: 'refresh');
    print(refresh);
    if (refresh == null) {
      print('No refresh token');
      return;
    }

    final response = await http.post('http://192.168.1.85:8000/api/token/refresh/',
        body: {'refresh': refresh});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      await storage.write(key: 'jwt', value:  data['access']);
      await storage.write(key: 'refresh', value: data['refresh']);
      fetchTrackers(context);
    } else {
      print('Erreur de refresh');
      print(response.body);
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Veuillez vous reconnecter..."),
      ));
      await storage.delete(key: 'jwt');
      await storage.delete(key: 'refresh');
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', (Route<dynamic> route) => false);
    }
  }

  void addTracker(Tracker tracker) async {
    String jwt = await storage.read(key: 'jwt');
    print(jwt);
    if (jwt == null) {
      print('No JWT');
      return;
    }

    final response = await http.post(
      baseApiTracker,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwt"
      },
      body: json.encode(tracker),
    );
    if (response.statusCode == 201) {
      tracker.id = json.decode(response.body)['id'];
      _trackers.add(tracker);
      notifyListeners();
    } else {
      print("Cannot add tracker");
      print(response.body);
    }
  }

  void plusOneTrack(Tracker tracker, String comment, context) async {
    String jwt = await storage.read(key: 'jwt');
    print(jwt);
    if (jwt == null) {
      print('No JWT');
      return;
    }

    Track track = Track(tracker: tracker.id, commentaire: comment);

    final response = await http.post(
      baseApiTrack,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwt"
      },
      body: json.encode(track)
    );
    if (response.statusCode == 201) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Track ajouté au tracker ${tracker.name} !"),
      ));
      // Refresh Trackers to have the new track (not really optimized)
      fetchTrackers(context);
    } else {
      print("Cannot add one track");
      print(response.body);
      if (response.statusCode == 401) {
        refreshToken(context);
      }
    }
  }

  void deleteTracker(Tracker tracker) async {
    String jwt = await storage.read(key: 'jwt');
    print(jwt);
    if (jwt == null) {
      print('No JWT');
      return;
    }

    final response = await http.delete("$baseApiTracker/${tracker.id}", headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $jwt"
    });
    if (response.statusCode == 204) {
      _trackers.remove(tracker);
      notifyListeners();
    } else {
      print("Cannot delete tracker");
      print(response.body);
    }
  }
}
