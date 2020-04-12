import 'package:flutter/material.dart';
import 'package:trackerapp/models/track.dart';
import 'package:intl/intl.dart';

class Tracker {
  int id;
  int creator;
  String name;
  String icon;
  String color;
  DateTime creationDate;
  int order;
  List<Track> tracks;

  Tracker({
    this.id,
    @required this.creator,
    @required this.name,
    @required this.icon,
    @required this.color,
    @required this.creationDate,
    @required this.order,
    this.tracks
  });

  factory Tracker.fromJson(Map<String, dynamic> json) {
    return Tracker(
      id: json['id'],
      creator: json['createur'],
      name: json['nom'],
      icon: json['icone'],
      color: json['color'],
      creationDate: DateTime.parse(json['date_creation']).toLocal(),
      order: json['order'],
      tracks: json['tracks'].map<Track>((json) => Track.fromJson(json)).toList()
    );
  }
  dynamic toJson() => {
    'createur': creator,
    'nom': name,
    'icone': icon,
    'color': color,
    'date_creation': DateFormat("yyyy-MM-ddTH:m:s").format(creationDate.toUtc()),
    'order': order,
    'tracks': tracks.map((track) => track.toJson())
  };
}