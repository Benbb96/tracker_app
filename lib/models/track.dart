import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Track {
  int id;
  int tracker;
  String datetime;
  String commentaire;

  Track({
    this.id,
    @required this.tracker,
    this.datetime,
    this.commentaire
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'],
      tracker: json['tracker'],
      datetime: json['datetime'],
      commentaire: json['commentaire']
    );
  }
  dynamic toJson() {
    dynamic result = {
      'id': id,
      'tracker': tracker,
      'datetime': datetime,
      'commentaire': commentaire
    };
    result.removeWhere((key, value) => value == null);
    return result;
  }

  DateTime get getDateTime {
    return datetime != null ? DateTime.parse(datetime).toLocal() : null;
  }

  String get getFormatedDateTime {
    return datetime != null ? DateFormat("dd/MM/yyyy à HH:mm:ss").format(DateTime.parse(datetime).toLocal()) : '';
  }

  set setDateTime(DateTime newDateTime) {
    datetime = DateFormat("yyyy-MM-ddTHH:mm:ss").format(newDateTime.toUtc());
  }
}