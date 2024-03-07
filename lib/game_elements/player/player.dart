import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/game_object.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/level/level.dart';
import 'package:tempest/helpers/tile_helper.dart';

class Player extends StatefulTileGameObject {
  Player(Level level) : this._(TilePositionable(level, level.tiles.length ~/ 2, depthFraction: 0));
  Player._(TilePositionable tile) : this.__(tile, createDrawables(tile));
  Player.__(TilePositionable tile, List<Drawable> drawables) : super(tile, drawables, (drawables.length / 2).floor());

  ///Time to move from one [tileStates] to another
  ///
  ///Should be set as time to move from center of the tile to the center of the next tile divided by [tileStates.length]
  late final Duration _timeToMove = Duration(milliseconds: Drawable.syncTime ~/ drawables.length);

  ///List of states that player can be in on one tile. Default state is the middle one.
  ///
  ///To transition to another tile player have to move through all states to the left/right related to it. Then when moved to next tile player start in right/left state
  static List<Drawable2D> createDrawables(TilePositionable pivot) => [
        Drawable2D(pivot, [
          Positionable(0, 5, 0),
          Positionable(7, 0, 0),
          Positionable(7, -4, 0),
          Positionable(5, 0, 0),
          Positionable(-5, 0, 0),
          Positionable(-2, -4, 0),
          Positionable(-7, 0, 0),
        ], [
          [0, 1, 2, 3, 4, 5, 6]
        ]),
        Drawable2D(pivot, [
          Positionable(0, 5, 0),
          Positionable(7, 0, 0),
          Positionable(3, -4, 0),
          Positionable(5, 0, 0),
          Positionable(-5, 0, 0),
          Positionable(-3, -4, 0),
          Positionable(-7, 0, 0),
        ], [
          [0, 1, 2, 3, 4, 5, 6]
        ]),
        Drawable2D(pivot, [
          Positionable(0, 5, 0),
          Positionable(7, 0, 0),
          Positionable(2, -4, 0),
          Positionable(5, 0, 0),
          Positionable(-5, 0, 0),
          Positionable(-7, -4, 0),
          Positionable(-7, 0, 0),
        ], [
          [0, 1, 2, 3, 4, 5, 6]
        ]),
      ];
  late final int _centralState = (drawables.length / 2).floor();
  Level get level => pivot.level;
  late int _targetTile = level.tiles.length ~/ 2;

  set setActiveTile(int value) {
    pivot.tileNumber = value;
    level.activeTile = value;
  }

  ///Counter of movement, calculated at the time target tile is set
  ///
  ///Positive value means player is moving right, negative - left
  int _movementCount = 0;

  static final _paint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = Drawable.strokeWidth;

  @override
  void onFrame(Canvas canvas, DateTime frameTimestamp) {
    _updatePosition(frameTimestamp);
    (drawables[state]..applyTransformation(angleZ: LevelTileHelper.getAngle(pivot) + pi / 2))
        .show(canvas, _paint); //TODO: draw player in blender and remove pi / 2
  }

  /// 1 - right, -1 - left, 0 - stay
  int _getMovementCount(int current, int target, int tileCount, bool circular) {
    final sign = target.compareTo(current);
    int getLinearTiles() => (_targetTile - level.activeTile).abs();
    int getCurcularTiles() {
      final straight = getLinearTiles();
      final looped = (level.tiles.length - (_targetTile - level.activeTile).abs());
      return (straight < looped ? straight : -looped);
    }

    int getCircularDistance() => (getCurcularTiles() * drawables.length * sign + (_centralState - state));
    int getLinearDistance() => (getLinearTiles() * drawables.length * sign + (_centralState - state));

    return circular ? getCircularDistance() : getLinearDistance();
  }

  void _updatePosition(DateTime frameTimestamp) {
    if (frameTimestamp.difference(lastFrameTimestamp) > _timeToMove) {
      if (_movementCount != 0) {
        state += _movementCount.sign;
        if (state == -1) {
          setActiveTile = (level.activeTile + _movementCount.sign) % level.tiles.length;
          state = drawables.length - 1;
        } else if (state == drawables.length) {
          setActiveTile = (level.activeTile + _movementCount.sign) % level.tiles.length;
          state = 0;
        }
        _movementCount -= _movementCount.sign;
      }
      lastFrameTimestamp = frameTimestamp;
    }
    pivot.updatePosition(widthFraction: (state + 1) / (drawables.length + 1));
  }

  set setTargetTile(int value) {
    if (_targetTile == value) return;
    _targetTile = value % level.tiles.length;
    _movementCount = _getMovementCount(pivot.tileNumber, _targetTile, level.tiles.length, level.circlular);
  }

  /// -1 - left, 1 - right
  void moveTargetTile(int direction) {
    if (direction != -1 && direction != 1) {
      throw ArgumentError("Unknown direction");
    }
    setTargetTile = _targetTile + direction;
  }
}
