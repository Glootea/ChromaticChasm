import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/enemies/enemy.dart';
import 'package:tempest/game_elements/level/level.dart';
import 'package:tempest/game_elements/player/player.dart';
import 'package:tempest/game_elements/shot.dart';
import 'package:tempest/helpers/easing.dart';
import 'package:tempest/helpers/throttler.dart';

sealed class GameState {
  void onFireButtonPressed();
  void onAngleChanged(double angle);
  KeyEventResult onKeyboardEvent(KeyEvent event);
  void draw(Canvas canvas);
  StreamController<GameState> setStateStream;
  GameState(this.setStateStream);
}

class LevelAppearState extends GameState {
  final Level level;

  late final DateTime _startTime;
  LevelAppearState(super.setStateStream, this.level) {
    _startTime = DateTime.now();
  }
  static const Duration _levelAppearTime = Duration(seconds: 3);
  static final Positionable _startPivot = Positionable(0, 0, 5000);
  late final Positionable _targetPivot = Positionable.copy(level.pivot);

  @override
  void draw(Canvas canvas) {
    final frameTimestamp = DateTime.now();
    double timeFracton =
        (frameTimestamp.difference(_startTime).inMilliseconds / _levelAppearTime.inMilliseconds).easeInOutCubic;
    if (timeFracton >= 1) {
      setStateStream.add(PlayingState.create(setStateStream, level));
      timeFracton = 1;
    }

    final position =
        PositionFunctions.positionWithFraction(_startPivot, _targetPivot, Positionable.zero(), timeFracton);
    level.pivot.setFrom(position);
    level.show(canvas, frameTimestamp);
  }

  @override
  void onAngleChanged(double angle) {}

  @override
  void onFireButtonPressed() {}

  @override
  KeyEventResult onKeyboardEvent(KeyEvent event) {
    return KeyEventResult.handled;
  }
}

class PlayingState extends GameState {
  final Level level;
  final Player player;
  final List<Enemy> enemies;
  final List<Shot> shots;

  PlayingState(super.setStateStream, this.level, this.player, this.enemies, this.shots);
  PlayingState.create(super.setStateStream, this.level)
      : player = Player(level, level.tiles.length ~/ 2),
        enemies = [Spider(level, 4)],
        shots = [];
  @override
  void onFireButtonPressed() => shots.add(Shot(level, level.activeTile));

  @override
  void draw(Canvas canvas) {
    if (_random.nextInt(180) == 0) {
      enemies.add(Spider(level, _random.nextInt(level.tiles.length)));
    }
    final frameTimestamp = DateTime.now();
    if (_direction != null) throttler.throttle(() => player.moveTargetTile(_direction!));
    level.show(canvas, frameTimestamp);
    for (int i = 0; i < enemies.length; i++) {
      final enemy = enemies[i];
      for (int j = 0; j < shots.length; j++) {
        final shot = shots[j];
        if (enemy.checkShotHit(shot)) {
          shots.removeAt(j);
          if (enemy.checkDead) {
            enemies.removeAt(i);
            continue;
          }
        }
      }
      if (enemy.disappear) {
        enemies.removeAt(i);
        continue;
      }
      enemy.show(canvas, frameTimestamp);
    }

    for (int i = 0; i < shots.length; i++) {
      final shot = shots[i];
      if (shot.disappear) {
        shots.removeAt(i);
        continue;
      }
      shot.show(canvas, frameTimestamp);
    }

    player.show(canvas, frameTimestamp);
  }

  @override
  void onAngleChanged(double angle) {
    player.setTargetTile = _calculateActiveTile(angle);
  }

  int _calculateActiveTile(double angle) {
    final tiles = level.tiles;
    for (final tile in tiles) {
      if ((angle <= tile.angleRange.last && angle >= tile.angleRange.first) ||
          (angle <= tile.angleRange.first && angle >= tile.angleRange.last)) {
        return tiles.indexOf(tile);
      }
    }
    if (angle < tiles.first.angleRange.first) return 0;
    if (angle >= tiles.last.angleRange.last) return tiles.length - 1;
    dev.log(angle.toString());
    dev.log("Tile no found");
    throw Exception("Tile no found");
  }

  final Random _random = Random();
  final throttler = Throttler(const Duration(milliseconds: Drawable.syncTime * 4));
  int? _direction;
  @override
  KeyEventResult onKeyboardEvent(KeyEvent event) {
    print(event.logicalKey.keyLabel);
    if (event is KeyRepeatEvent) return KeyEventResult.ignored;
    if (event is KeyDownEvent) {
      switch (event.logicalKey.keyLabel) {
        case "A":
          _direction = -1;
        // player.moveTargetTile(-1);

        case "D":
          _direction = 1;
        // player.moveTargetTile(1);
      }
    }
    if (event is KeyUpEvent) _direction = null;
    return KeyEventResult.handled;
  }
}
