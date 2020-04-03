import 'package:flutter/material.dart';

class Tracker {
  int id;
  int creator;
  String name;
  String icon;
  String color;
  String creationDate;
  int order;

  Tracker({
    this.id,
    @required this.creator,
    @required this.name,
    @required this.icon,
    @required this.color,
    @required this.creationDate,
    @required this.order
  });

  factory Tracker.fromJson(Map<String, dynamic> json) {
    return Tracker(
      id: json['id'],
      creator: json['createur'],
      name: json['nom'],
      icon: json['icone'],
      color: json['color'],
      creationDate: json['date_creation'],
      order: json['order'],
    );
  }
  dynamic toJson() => {
    'createur': creator,
    'nom': name,
    'icone': icon,
    'color': color,
    'date_creation': creationDate,
    'order': order
  };
}