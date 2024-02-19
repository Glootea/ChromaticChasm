import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/base_classes/transfromable.dart';
import 'package:tempest/game_elements/level/level.dart';

// TODO: time (not frame) dependent movement
// TODO: refactor
class Player extends TilePositionable with Transformable, Drawable, ChangeNotifier {
  Level level;
  Player(this.level, {super.offset}) : super(level.tiles[level.activeTile].mainLine, level.pivot, 0);

  ///List of states that player can be in on one tile. Default state is the middle one.
  ///
  ///To transition to another tile player have to move through all states to the left/right related to it. Then when moved to next tile player start in right/left state
  List<List<Positionable>> tileStates = [
    [
      Positionable(0, 5, 0),
      Positionable(7, 0, 0),
      Positionable(7, -4, 0),
      Positionable(5, 0, 0),
      Positionable(-5, 0, 0),
      Positionable(-2, -4, 0),
      Positionable(-7, 0, 0),
    ],
    [
      Positionable(0, 5, 0),
      Positionable(7, 0, 0),
      Positionable(3, -4, 0),
      Positionable(5, 0, 0),
      Positionable(-5, 0, 0),
      Positionable(-3, -4, 0),
      Positionable(-7, 0, 0),
    ],
    [
      Positionable(0, 5, 0),
      Positionable(7, 0, 0),
      Positionable(2, -4, 0),
      Positionable(5, 0, 0),
      Positionable(-5, 0, 0),
      Positionable(-7, -4, 0),
      Positionable(-7, 0, 0),
    ],
  ];
  late int currentState = (tileStates.length / 2).floor();
  int i = 0;
  @override
  void show(Canvas canvas) {
    if (i == 30) {
      updatePosition();
      i = 0;
    }
    i++;
    double getWidthFraction() => currentState / (tileStates.length - 1);

    final delta = level.tiles[level.activeTile].points.last - level.tiles[level.activeTile].points.first;
    final point = PositionFunctions.positionWithFraction(level.tiles[level.activeTile].points.first,
        level.tiles[level.activeTile].points.last, level.pivot, getWidthFraction());
    drawLooped(
        canvas,
        rotateZ(Positionable(0, 0, 0), tileStates[currentState], atan2(delta.x, delta.y) - pi / 2)
            .map((e) => e + point)
            .toList(),
        Paint()
          ..color = Colors.red
          ..strokeWidth = Drawable.strokeWidth);
  }

  /// 1 - right, -1 - left, 0 - stay
  int getMoveDirection(int current, int target, int tileCount, bool circular) {
    if (target == current) return (tileStates.length / 2).floor().compareTo(currentState);
    if (circular) {
      if ((target - current).abs() < tileCount / 2 && target - current < 0 ||
          (target - current).abs() > tileCount / 2 && target - current > 0) return -1;
      if ((target - current).abs() < tileCount / 2 && target - current > 0 ||
          (target - current).abs() > tileCount / 2 && target - current < 0) return 1;
    }
    return target.compareTo(current);
  }

  void updatePosition() {
    final direction = getMoveDirection(level.activeTile, targetTile, level.tiles.length, level.circlular);
    currentState += direction;
    if (currentState == -1) {
      level.activeTile = (level.activeTile + direction) % level.tiles.length;
      currentState = tileStates.length - 1;
      return;
    }
    if (currentState == tileStates.length) {
      level.activeTile = (level.activeTile + direction) % level.tiles.length;
      currentState = 0;
      return;
    }
  }

  set setTargetTile(int value) {
    targetTile = value % level.tiles.length;
    notifyListeners();
  }

  late int targetTile = level.tiles.length ~/ 2;
}
