import 'package:chromatic_chasm/database/database.dart';
import 'package:flutter/material.dart';

class LevelSelectorNotifier extends ChangeNotifier {
  LevelSelectorNotifier({required ChromaticChasmDatabase database})
    : _database = database;
  bool _loading = true;
  final ChromaticChasmDatabase _database;
  bool get loading => _loading;
  List<LevelSelectionItem> levels = [];

  Future<void> getLevels() async {
    levels = await _database.getLevels().then((v) => v.toList());
    _loading = false;
    notifyListeners();
  }

  void renameLevel(int index, String name) {
    levels[index].name = name;
    // notifyListeners();
    _database.insertLevelBasicInfo(levels[index]);
  }

  void toggleLevel(int index) {
    levels[index].activated = !levels[index].activated;
    notifyListeners();
    _database.insertLevelBasicInfo(levels[index]);
  }

  void deleteLevel(int index) {
    _database.deleteLevel(levels[index]);
    levels.removeAt(index);
    notifyListeners();
  }

  void addLevel(String levelName) {
    levels.add(
      LevelSelectionItem(name: levelName, activated: false, id: levels.length),
    );
    notifyListeners();
    _database.insertLevelBasicInfo(levels[levels.length - 1]);
  }
}

class LevelSelectionItem {
  String name;
  bool activated;
  final int id;

  LevelSelectionItem({
    required this.name,
    required this.activated,
    required this.id,
  });
}
