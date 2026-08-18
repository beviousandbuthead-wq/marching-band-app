import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'player.dart';
import 'set_data.dart';

class ShowData extends ChangeNotifier {
  List<Player> players = [];
  List<SetData> sets = [];
  String showName = 'My Show';

  final _uuid = const Uuid();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('show_data');
    if (data != null) {
      final json = jsonDecode(data);
      showName = json['showName'] ?? 'My Show';
      players = (json['players'] as List)
          .map((e) => Player.fromJson(e))
          .toList();
      sets = (json['sets'] as List).map((e) => SetData.fromJson(e)).toList();
    } else {
      // Create default empty show
      sets = [
        SetData(id: _uuid.v4(), name: 'Set 1'),
        SetData(id: _uuid.v4(), name: 'Set 2'),
      ];
    }
    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'showName': showName,
      'players': players.map((p) => p.toJson()).toList(),
      'sets': sets.map((s) => s.toJson()).toList(),
    };
    await prefs.setString('show_data', jsonEncode(data));
  }

  void addPlayer(String name, {String section = 'Brass', int number = 0}) {
    players.add(Player(
      id: _uuid.v4(),
      name: name,
      section: section,
      number: number,
      color: Colors.primaries[players.length % Colors.primaries.length],
    ));
    save();
    notifyListeners();
  }

  void removePlayer(String id) {
    players.removeWhere((p) => p.id == id);
    for (var set in sets) {
      set.positions.remove(id);
    }
    save();
    notifyListeners();
  }

  void addSet(String name) {
    sets.add(SetData(id: _uuid.v4(), name: name));
    save();
    notifyListeners();
  }

  void updatePosition(String setId, String playerId, Offset pos) {
    final set = sets.firstWhere((s) => s.id == setId);
    set.positions[playerId] = pos;
    save();
    notifyListeners();
  }

  void deleteSet(String id) {
    if (sets.length > 1) {
      sets.removeWhere((s) => s.id == id);
      save();
      notifyListeners();
    }
  }
}
