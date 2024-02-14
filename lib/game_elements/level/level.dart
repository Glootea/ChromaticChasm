import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/level/tile/level_tile.dart';
import 'package:tempest/game_elements/base_classes/movable.dart';

class Level extends ChangeNotifier with Drawable {
  Movable pivot;
  List<LevelTile> tiles;
  Level(this.pivot, this.tiles);
  @override
  void draw(Canvas canvas, Function prepareLines) {
    super.draw(canvas, prepareLines);
  }
}
