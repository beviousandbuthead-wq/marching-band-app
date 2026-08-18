import 'package:flutter/material.dart';

class Player {
  final String id;
  String name;
  String section;
  int number;
  Color color;

  Player({
    required this.id,
    required this.name,
    this.section = 'Brass',
    this.number = 0,
    this.color = Colors.blue,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'section': section,
        'number': number,
        'color': color.value,
      };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json['id'],
        name: json['name'],
        section: json['section'] ?? 'Brass',
        number: json['number'] ?? 0,
        color: Color(json['color'] ?? Colors.blue.value),
      );
}
