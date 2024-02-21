import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/base_classes/transfromable.dart';
import 'package:tempest/game_elements/level/level.dart';
import 'package:tempest/helpers/positionable_extension.dart';
import '../level/tile/level_tile.dart';

class Player extends TilePositionable with Transformable, Drawable, ChangeNotifier {
  Level level;
  Player(this.level, {super.offset}) : super(level.tiles[level.activeTile].mainLine, level.pivot, 0);

  ///Time to move from one [tileStates] to another
  ///
  ///Should be set as time to move from center of the tile to the center of the next tile divided by [tileStates.length]
  late final Duration _timeToMove = Duration(milliseconds: 100 ~/ tileStates.length);
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
  late final int _centralState =
      (tileStates.length / 2).floor(); //TODO: rewrite to getter for skin(with different tileStates.length) support
  late int _currentState = _centralState;

  LevelTile get activeTile => level.tiles[level.activeTile];
  late int _targetTile = level.tiles.length ~/ 2;

  int _movementCount = 0;

  List<Positionable> getRotatedLocalPoints(double angle) =>
      rotateZ(Positionable.zero(), tileStates[_currentState], angle);

  static final paint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = Drawable.strokeWidth;

  @override
  void show(Canvas canvas) {
    double getWidthFraction() => (_currentState + 1) / (tileStates.length + 1);

    final delta = activeTile.points.last - activeTile.points.first;
    final pivot = PositionFunctions.positionWithFraction(
        activeTile.points.first, activeTile.points.last, level.pivot, getWidthFraction());
    final points = getRotatedLocalPoints(atan2(delta.x, delta.y) - pi / 2).toGlobal(pivot);
    drawLooped(canvas, points, paint);
  }

  /// 1 - right, -1 - left, 0 - stay
  int _getMoveDirection(int current, int target, int tileCount, bool circular) {
    if (target == current) return _centralState.compareTo(_currentState);
    if (circular) {
      if ((target - current).abs() < tileCount / 2 && target - current < 0 ||
          (target - current).abs() > tileCount / 2 && target - current > 0) return -1;
      if ((target - current).abs() < tileCount / 2 && target - current > 0 ||
          (target - current).abs() > tileCount / 2 && target - current < 0) return 1;
    }
    return target.compareTo(current);
  }

  void _updatePosition(int direction) {
    _currentState += direction;
    if (_currentState == -1) {
      level.activeTile = (level.activeTile + direction) % level.tiles.length;
      _currentState = tileStates.length - 1;
    } else if (_currentState == tileStates.length) {
      level.activeTile = (level.activeTile + direction) % level.tiles.length;
      _currentState = 0;
    }
    notifyListeners();
  }

  set setTargetTile(int value) {
    if (_targetTile == value) return;
    _targetTile = value % level.tiles.length;
    _setTimesToMove();
    notifyListeners();
  }

  void _setTimesToMove() {
    int direction = _getMoveDirection(level.activeTile, _targetTile, level.tiles.length, level.circlular);
    _movementCount =
        ((_targetTile - level.activeTile).abs() * tileStates.length + (_currentState - _centralState)) * direction;
    _updatePositionTimer?.cancel();
    _updatePositionTimer = Timer.periodic(_timeToMove, (time) {
      _movementCount -= direction;
      if (_movementCount != 0) {
        _updatePosition(_movementCount.sign);
      } else {
        _updatePositionTimer?.cancel();
        _updatePositionTimer = null;
      }
    });
  }

  @override
  void dispose() {
    _updatePositionTimer?.cancel();
    super.dispose();
  }
}
