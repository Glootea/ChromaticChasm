import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable_old.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/level/level.dart';
import 'package:tempest/helpers/positionable_list_extension.dart';
import '../level/tile/level_tile.dart';

class Player extends TilePositionable with DrawableOld {
  Player(super.level, super.tileNumber);
  Player.create(Level level) : this(level, level.children.length ~/ 2);

  ///Time to move from one [tileStates] to another
  ///
  ///Should be set as time to move from center of the tile to the center of the next tile divided by [tileStates.length]
  late final Duration _timeToMove = Duration(milliseconds: DrawableOld.syncTime ~/ tileStates.length);
  Timer? _updatePositionTimer;

  ///List of states that player can be in on one tile. Default state is the middle one.
  ///
  ///To transition to another tile player have to move through all states to the left/right related to it. Then when moved to next tile player start in right/left state
  final List<List<Positionable>> tileStates = [
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
  late final int _centralState = (tileStates.length / 2).floor();
  late int _currentState = _centralState;

  LevelTile get activeTile => level.children[tileNumber];
  late int _targetTile = level.children.length ~/ 2;

  ///Counter of movement calculated at the time target tile is set
  ///
  ///Positive value means player is moving right, negative - left
  int _movementCount = 0;

  static final paint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = DrawableOld.strokeWidth;

  @override
  void updateAndShow(Canvas canvas, DateTime frameTimestamp) {
    double getWidthFraction() => (_currentState + 1) / (tileStates.length + 1);

    _updatePosition(_movementCount.sign, frameTimestamp);
    final depth =
        PositionFunctions.positionWithFraction(activeTile.mainLine.close, activeTile.mainLine.far, depthFraction).z;

    final pivot = PositionFunctions.positionWithFraction(
      activeTile.leftNearPointGlobal,
      activeTile.rightNearPointGlobal,
      getWidthFraction(),
    )..z += (depth - level.pivot.z);
    final points = rotateZ(Positionable.zero(), tileStates[_currentState], activeTile.angle).toGlobal(pivot);
    drawLoopedLines(canvas, points, paint);
  }

  /// 1 - right, -1 - left, 0 - stay
  int _getMovementCount(int current, int target, int tileCount, bool circular) {
    final sign = target.compareTo(current);
    int getLinearTiles() => (_targetTile - tileNumber).abs();
    int getCurcularTiles() {
      final straight = getLinearTiles();
      final looped = (level.children.length - (_targetTile - tileNumber).abs());
      return (straight < looped ? straight : -looped);
    }

    int getCircularDistance() => (getCurcularTiles() * tileStates.length * sign + (_centralState - _currentState));
    int getLinearDistance() => (getLinearTiles() * tileStates.length * sign + (_centralState - _currentState));

    return circular ? getCircularDistance() : getLinearDistance();
  }

  void _updatePosition(int direction, DateTime frameTimestamp) {
    if (avoidRedraw) return;
    lastFrameTimestamp = frameTimestamp;
    if (_movementCount != 0) {
      _currentState += direction;
      if (_currentState == -1) {
        level.activeTile = (level.activeTile + direction) % level.children.length;
        tileNumber = level.activeTile;
        _currentState = tileStates.length - 1;
      } else if (_currentState == tileStates.length) {
        level.activeTile = (level.activeTile + direction) % level.children.length;
        tileNumber = level.activeTile;
        _currentState = 0;
      }
      _movementCount -= _movementCount.sign;
    } else {
      _updatePositionTimer?.cancel();
      _updatePositionTimer = null;
    }
  }

  set setTargetTile(int value) {
    if (_targetTile == value) return;
    _targetTile = value % level.children.length;
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
    _movementCount = _getMovementCount(tileNumber, _targetTile, level.children.length, level.circlular);
    _updatePositionTimer = Timer.periodic(_timeToMove, (time) {});
  }
}
