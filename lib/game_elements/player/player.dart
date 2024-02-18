import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/base_classes/transfromable.dart';
import 'package:tempest/game_elements/level/level.dart';

// TODO: implement different states on one tile
// TODO: time (not frame) dependent movement
// TODO: refactor
class Player extends TilePositionable with Transformable, Drawable, ChangeNotifier {
  Level level;
  Player(this.level, {super.offset}) : super(level.tiles[level.activeTile].mainLine, 0);

  ///List of states that player can be in on one tile. Default state is the middle one.
  ///
  ///To transition to another tile player have to move through all states to the left/right related to it. Then when moved to next tile player start in right/left state
  List<List<Positionable>> tileStates = [[]];
  late int currentState = (tileStates.length / 2).ceil();

  @override
  void show(Canvas canvas) {
    final direction = getMoveDirection(level.activeTile, targetTile, level.tiles.length, level.circlular);
    level.activeTile = (level.activeTile + direction) % level.tiles.length;
    drawCircle(
        canvas,
        level.tiles[level.activeTile].mainLine.close,
        Paint()
          ..color = Colors.red
          ..strokeWidth = Drawable.strokeWidth);
  }

  /// 1 - right, -1 - left, 0 - stay
  int getMoveDirection(int current, int target, int tileCount, bool circular) {
    if (target == current) return (tileStates.length / 2).ceil().compareTo(currentState);
    if (circular) {
      if ((target - current).abs() < tileCount / 2 && target - current < 0 ||
          (target - current).abs() > tileCount / 2 && target - current > 0) return -1;
      if ((target - current).abs() < tileCount / 2 && target - current > 0 ||
          (target - current).abs() > tileCount / 2 && target - current < 0) return 1;
    }
    return target.compareTo(current);
  }

  set setTargetTile(int value) {
    targetTile = value % level.tiles.length;
    notifyListeners();
  }

  late int targetTile = level.tiles.length ~/ 2;
}
