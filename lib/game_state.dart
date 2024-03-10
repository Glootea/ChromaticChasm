// ignore_for_file: overridden_fields

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/game_object_lifecycle.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/enemies/enemy.dart';
import 'package:tempest/game_elements/level/level.dart';
import 'package:tempest/game_elements/player/player.dart';
import 'package:tempest/game_elements/shot.dart';
import 'package:tempest/helpers/easing.dart';
import 'package:tempest/helpers/throttler.dart';
import 'package:tempest/helpers/tile_helper.dart';

sealed class GameState {
  void init();
  KeyEventResult onKeyboardEvent(KeyEvent event);
  void onFireButtonPressed();
  void onAngleChanged(double angle);
  void draw(Canvas canvas);
  void handleKeyboardMovement();
  void handleNextState(bool check, GameState nextState) {
    if (check) setStateStream.add(nextState..init());
  }

  StreamController<GameState> setStateStream;
  int? _direction;
  Positionable camera;

  GameState(this.setStateStream, Positionable? camera, {int? direction})
      : _direction = direction,
        camera = camera ?? Positionable(0, 0, 0);

  final _throttler = Throttler(Duration(milliseconds: (Drawable.syncTime * 1.5).toInt()));

  double _getTimeFraction(DateTime now, DateTime last) =>
      (now.difference(last).inMilliseconds / LevelTransitionState.animationDuration.inMilliseconds);
}

class LevelAppearState extends PlayerFlyOutsideLevel {
  final _startCameraPivot = Positionable(0, 0, -5000);
  late final Positionable targetCameraPivot = Positionable.all(0);
  LevelAppearState(super.setStateStream, super.camera, super._level, super._player);
  LevelAppearState.newCycle(StreamController<GameState> setStateStream, Level level)
      : this(setStateStream, null, level, Player(level));

  @override
  void init() {
    _player.lifecycleState = PlayerFlyToLevel(_level);
  }

  @override
  void draw(Canvas canvas) {
    final frameTimestamp = DateTime.now();
    double timeFraction = _getTimeFraction(frameTimestamp, _startTime);
    handleNextState(
        timeFraction >= 1, PlayingState.create(setStateStream, camera, _level, Player(_level), direction: _direction));
    camera.setFrom(PositionFunctions.positionWithFraction(
        _startCameraPivot, targetCameraPivot, EasingFunctions.easeOutCubic(timeFraction)));
    _level.onFrame(canvas, camera, frameTimestamp);
    _player.onFrame(canvas, camera, frameTimestamp);
  }
}

class PlayingState extends GameState {
  final Level level;
  final Player player;
  final List<Enemy> enemies;
  final List<Shot> shots;

  int _enemiesToSpawnCount = 5;

  PlayingState(super.setStateStream, super.camera, this.level, this.player, this.enemies, this.shots,
      {super.direction});
  PlayingState.create(super.setStateStream, super.camera, this.level, this.player, {super.direction})
      : enemies = [],
        shots = [];
  @override
  void init() {
    player.lifecycleState = PlayerLive();
  }

  @override
  void onFireButtonPressed() => shots.add(Shot(level, level.activeTile));

  @override
  void draw(Canvas canvas) {
    handleNextState(_enemiesToSpawnCount <= 0 && enemies.isEmpty,
        LevelDisappearState(setStateStream, camera, level, player, direction: _direction));
    _spawnEnemy();
    final frameTimestamp = DateTime.now();
    handleKeyboardMovement();
    level.onFrame(canvas, camera, frameTimestamp);
    enemyOnNewFrame(canvas, frameTimestamp);
    shotOnNewFrame(canvas, frameTimestamp);
    player.onFrame(canvas, camera, frameTimestamp);
  }

  @override
  void handleKeyboardMovement() {
    if (_direction != null) _throttler.throttle(() => player.moveTargetTile(_direction!));
  }

  ///All operation on shot, that need to be done during every frame
  ///
  ///Contains: [disposeCheck], [show]
  void shotOnNewFrame(Canvas canvas, DateTime frameTimestamp) {
    for (int i = 0; i < shots.length; i++) {
      final shot = shots[i];
      if (shot.disappear) {
        shots.removeAt(i);
        continue;
      }
      shot.onFrame(canvas, camera, frameTimestamp);
    }
  }

  ///All operation on enemy, that need to be done during every frame
  ///
  ///Contains: [shotHitCheck], [disposeCheck], [show]
  void enemyOnNewFrame(Canvas canvas, DateTime frameTimestamp) {
    for (int enemyNum = 0; enemyNum < enemies.length; enemyNum++) {
      final enemy = enemies[enemyNum];
      final shotHitNum = enemy.shotHitNumber(shots);
      if (shotHitNum != null) {
        enemies.removeAt(enemyNum);
        shots.removeAt(shotHitNum);
        continue;
      }
      if (enemy.disappear) {
        enemies.removeAt(enemyNum);
        continue;
      }
      enemy.onFrame(canvas, camera, frameTimestamp);
    }
  }

  @override
  void onAngleChanged(double angle) {
    player.setTargetTile = _calculateActiveTile(angle);
  }

  int _calculateActiveTile(double angle) {
    final tiles = level.tiles;
    for (final (i, tile) in tiles.indexed) {
      if ((angle <= tile.angleRange.last && angle >= tile.angleRange.first) ||
          (angle <= tile.angleRange.first && angle >= tile.angleRange.last)) {
        return i;
      }
    }
    if (angle < tiles.first.angleRange.first) return 0;
    if (angle >= tiles.last.angleRange.last) return tiles.length - 1;
    dev.log(angle.toString());
    dev.log("Tile no found");
    throw Exception("Tile no found");
  }

  final Random _random = Random();

  @override
  KeyEventResult onKeyboardEvent(KeyEvent event) {
    if (event is KeyRepeatEvent) return KeyEventResult.ignored;
    if (event is KeyDownEvent) {
      switch (event.logicalKey.keyLabel) {
        case "A":
          _direction = -1;
          break;
        case "D":
          _direction = 1;
          break;
      }
    }
    if (event is KeyUpEvent) _direction = null;
    return KeyEventResult.handled;
  }

  void _spawnEnemy() {
    if (_enemiesToSpawnCount > 0 && _random.nextInt(90) == 0) {
      enemies.add(Spider(level, _random.nextInt(level.tiles.length)));
      _enemiesToSpawnCount--;
    }
  }
}

class LevelDisappearState extends LevelTransitionState {
  LevelDisappearState(super.setStateStream, super.camera, super.level, super.player, {super.direction});
  @override
  void init() {
    _player.lifecycleState = PlayerFlyThroughLevel();
  }

  @override
  late final Positionable targetPivot = Positionable(0, 0, _level.depth * 1.05);
  @override
  late final Positionable startPivot = Positionable.all(0);

  @override
  void draw(Canvas canvas) {
    final frameTimestamp = DateTime.now();
    double timeFraction = _getTimeFraction(frameTimestamp, _startTime);
    handleNextState(timeFraction >= 1, FlyAwayState(setStateStream, camera, _level, _player));
    handleDepth(timeFraction);
    handleKeyboardMovement();
    _level.onFrame(canvas, camera, frameTimestamp);
    _player.onFrame(canvas, camera, frameTimestamp);
  }

  void handleDepth(double timeFraction) {
    camera.setFrom(PositionFunctions.positionWithFraction(startPivot, targetPivot, timeFraction));
    _player.pivot.updatePosition(depthFraction: timeFraction);
  }

  @override
  void handleKeyboardMovement() {
    if (_direction != null) _throttler.throttle(() => _player.moveTargetTile(_direction!));
  }
}

class FlyAwayState extends PlayerFlyOutsideLevel {
  FlyAwayState(super.setStateStream, super.camera, super._level, super.player);
  @override
  void init() {
    _player.lifecycleState = PlayerFlyFromLevel(LevelTileHelper.getAngle(_player.pivot));
    _startCameraPivot = camera.clone();
  }

  late final Positionable _startCameraPivot;
  @override
  void draw(Canvas canvas) {
    final frameTimestamp = DateTime.now();
    double timeFraction = _getTimeFraction(frameTimestamp, _startTime);
    handleNextState(timeFraction >= 1, LevelAppearState.newCycle(setStateStream, Level.getRandomLevel()));
    camera.setFrom(PositionFunctions.positionWithFraction(_startCameraPivot, _startCameraPivot, timeFraction));
    _player.onFrame(canvas, camera, frameTimestamp);
  }

  @override
  void handleKeyboardMovement() {}

  @override
  void onAngleChanged(double angle) {}

  @override
  void onFireButtonPressed() {}

  @override
  KeyEventResult onKeyboardEvent(KeyEvent event) {
    return KeyEventResult.handled;
  }
}

abstract class PlayerFlyOutsideLevel extends LevelTransitionState {
  PlayerFlyOutsideLevel(super.setStateStream, super.camera, super._level, super._player, {super.direction});
  @override
  void handleKeyboardMovement() {}
  @override
  void onAngleChanged(double angle) {}
  @override
  void onFireButtonPressed() {}
  @override
  KeyEventResult onKeyboardEvent(KeyEvent event) {
    return KeyEventResult.handled;
  }
}

abstract class LevelTransitionState extends GameState {
  final Level _level;
  final Player _player;

  LevelTransitionState(super.setStateStream, super.camera, this._level, this._player, {super.direction});

  static const Duration animationDuration = Duration(seconds: 3);
  final DateTime _startTime = DateTime.now();

  late final Positionable startPivot;

  late final Positionable targetPivot;

  @override
  void onAngleChanged(double angle) {
    _player.setTargetTile = _calculateActiveTile(angle);
  }

  int _calculateActiveTile(double angle) {
    final tiles = _level.tiles;
    for (final (i, tile) in tiles.indexed) {
      if ((angle <= tile.angleRange.last && angle >= tile.angleRange.first) ||
          (angle <= tile.angleRange.first && angle >= tile.angleRange.last)) {
        return i;
      }
    }
    if (angle < tiles.first.angleRange.first) return 0;
    if (angle >= tiles.last.angleRange.last) return tiles.length - 1;
    dev.log(angle.toString());
    dev.log("Tile no found");
    throw Exception("Tile no found");
  }

  @override
  void onFireButtonPressed() {}

  @override
  KeyEventResult onKeyboardEvent(KeyEvent event) {
    if (event is KeyRepeatEvent) return KeyEventResult.ignored;
    if (event is KeyDownEvent) {
      switch (event.logicalKey.keyLabel) {
        case "A":
          _direction = -1;
          break;
        case "D":
          _direction = 1;
          break;
      }
    }
    if (event is KeyUpEvent) _direction = null;
    return KeyEventResult.handled;
  }
}
