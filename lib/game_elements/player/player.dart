import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/game_object.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/level/level.dart';
import 'package:tempest/helpers/tile_helper.dart';
import '../level/tile/level_tile.dart';

class Player extends StatefulTileGameObject {
  Player._(TilePositionable tile, List<Drawable> drawables) : super(tile, drawables, (drawables.length / 2).floor()) {
    assert(drawables.length == 3);
  }
  Player._create(TilePositionable tile) : this._(tile, createDrawables(tile));
  Player.create(Level level) : this._create(TilePositionable(level, level.children.length ~/ 2, depthFraction: 0));

  ///Time to move from one [tileStates] to another
  ///
  ///Should be set as time to move from center of the tile to the center of the next tile divided by [tileStates.length]
  late final Duration _timeToMove = Duration(milliseconds: Drawable.syncTime * 5 ~/ drawables.length);
  Timer? _updatePositionTimer;

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
  // late int _currentState = _centralState;

  LevelTile get activeTile => pivot.level.children[pivot.level.activeTile];
  late int _targetTile = pivot.level.children.length ~/ 2;
  set setActiveTile(int value) {
    pivot.tileNumber = value;
    pivot.level.activeTile = value;
  }

  ///Counter of movement calculated at the time target tile is set
  ///
  ///Positive value means player is moving right, negative - left
  int _movementCount = 0;

  static final paint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = Drawable.strokeWidth;

  @override
  void onFrame(Canvas canvas, DateTime frameTimestamp) {
    _updatePosition(_movementCount.sign, frameTimestamp);
    // final depth =
    // PositionFunctions.positionWithFraction(activeTile.mainLine.close, activeTile.mainLine.far, depthFraction).z;
    (drawables[state]..applyTransformation(angleZ: LevelTileHelper.getAngle(pivot) + pi / 2)).show(canvas, paint);
    // final playerivot = PositionFunctions.positionWithFraction(
    //   activeTile.leftNearPointGlobal,
    //   activeTile.rightNearPointGlobal,
    //   getWidthFraction(),
    // )..z += (depth - pivot.level.pivot.z);
    // final points = rotateZ(Positionable.zero(), tileStates[_currentState], activeTile.angle).toGlobal(pivot);
    // drawLoopedLines(canvas, points, paint);
  }

  /// 1 - right, -1 - left, 0 - stay
  int _getMovementCount(int current, int target, int tileCount, bool circular) {
    final sign = target.compareTo(current);
    int getLinearTiles() => (_targetTile - pivot.level.activeTile).abs();
    int getCurcularTiles() {
      final straight = getLinearTiles();
      final looped = (pivot.level.children.length - (_targetTile - pivot.level.activeTile).abs());
      return (straight < looped ? straight : -looped);
    }

    int getCircularDistance() => (getCurcularTiles() * drawables.length * sign + (_centralState - state));
    int getLinearDistance() => (getLinearTiles() * drawables.length * sign + (_centralState - state));

    return circular ? getCircularDistance() : getLinearDistance();
  }

  double get _getWidthFraction => (state + 1) / (drawables.length + 1);
  void _updatePosition(int direction, DateTime frameTimestamp) {
    if (_movementCount != 0) {
      state += direction;
      if (state == -1) {
        setActiveTile = (pivot.level.activeTile + direction) % pivot.level.children.length;

        // tileNumber = level.activeTile;
        state = drawables.length - 1;
      } else if (state == drawables.length) {
        setActiveTile = (pivot.level.activeTile + direction) % pivot.level.children.length;
        // pivot.updatePosition();
        // tileNumber = level.activeTile;
        state = 0;
      }
      _movementCount -= _movementCount.sign;
    } else {
      _updatePositionTimer?.cancel();
      _updatePositionTimer = null;
    }
    pivot.widthFraction = _getWidthFraction;
    pivot.updatePosition();
    lastFrameTimestamp = frameTimestamp;
  }

  set setTargetTile(int value) {
    if (_targetTile == value) return;
    _targetTile = value % pivot.level.children.length;
    _setMovementCount();
  }

  /// -1 - left, 1 - right
  void moveTargetTile(int direction) {
    if (direction != -1 && direction != 1) {
      throw ArgumentError("Unknown direction");
    }
    setTargetTile = _targetTile + direction;
  }

  void _setMovementCount() {
    _updatePositionTimer?.cancel();
    _movementCount =
        _getMovementCount(pivot.tileNumber, _targetTile, pivot.level.children.length, pivot.level.circlular);
    _updatePositionTimer = Timer.periodic(_timeToMove, (time) {});
  }
}
