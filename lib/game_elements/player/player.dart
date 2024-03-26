import 'package:chromatic_chasm/game_elements/player/skins/player_skin_abst.dart';
import 'package:flutter/material.dart';
import 'package:chromatic_chasm/game_elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game_elements/base_classes/game_object.dart';
import 'package:chromatic_chasm/game_elements/base_classes/game_object_lifecycle.dart';
import 'package:chromatic_chasm/game_elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game_elements/camera.dart';
import 'package:chromatic_chasm/game_elements/level/level.dart';
import 'package:chromatic_chasm/helpers/tile_helper.dart';

class Player extends StatefulTileGameObject {
  Player(Level level) : this._(TilePositionable(level, level.tiles.length ~/ 2, depthFraction: 0));
  Player._(TilePositionable tile) : this.__(tile, PlayerSkin1().getDrawables(tile));
  Player.__(TilePositionable tile, List<Drawable> drawables) : super(tile, drawables, (drawables.length / 2).floor()) {
    super.lifecycleState = PlayerFlyToLevel(tile.level);
  }

  ///Time to move from one [tileStates] to another
  ///
  ///Should be set as time to move from center of the tile to the center of the next tile divided by [tileStates.length]
  late final Duration _timeToMove = Duration(milliseconds: Drawable.syncTime ~/ drawables.length);
  static double playerSize = 7;
  // PlayerLifecycle lifecycleState;

  ///List of states that player can be in on one tile. Default state is the middle one.
  ///
  ///To transition to another tile player have to move through all states to the left/right related to it. Then when moved to next tile player start in right/left state

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

  final paint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = Drawable.strokeWidth;

  @override
  void onFrame(Canvas canvas, Camera camera, DateTime frameTimestamp) {
    _updatePosition(frameTimestamp);
    (drawables[state]
          ..applyTransformation(
              widthToScale: playerSize,
              angleZ: (lifecycleState is PlayerFlyOutsideLevel)
                  ? (lifecycleState as PlayerFlyOutsideLevel).getAngle
                  : LevelTileHelper.getAngle(pivot)))
        .show(canvas, camera, paint);
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
    switch (lifecycleState.runtimeType) {
      case PlayerLive || PlayerFlyThroughLevel:
        {
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
          pivot.updatePosition(
              widthFraction: (state + 1) / (drawables.length + 1),
              depthFraction: lifecycleState.runtimeType == PlayerFlyThroughLevel
                  ? (lifecycleState as PlayerFlyThroughLevel).timeFraction
                  : 0);
        }
      case PlayerFlyFromLevel || PlayerFlyToLevel:
        {
          pivot.updatePosition(offset: (lifecycleState as PlayerFlyOutsideLevel).currentPosition);
        }
      default:
        throw UnimplementedError("Unhandled player lifecycle state, ${lifecycleState.runtimeType}");
    }
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
