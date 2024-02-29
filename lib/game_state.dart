import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/enemies/enemy.dart';
import 'package:tempest/game_elements/level/level.dart';
import 'package:tempest/game_elements/player/player.dart';
import 'package:tempest/game_elements/shot.dart';
import 'package:tempest/helpers/throttler.dart';

sealed class GameState {
  void onFireButtonPressed();
  void onAngleChanged(double angle);
  KeyEventResult onKeyboardEvent(KeyEvent event);
  void draw(Canvas canvas);
}

class PlayingState extends GameState {
  final Level level;
  final Player player;
  final List<Enemy> enemies;
  final List<Shot> shots;

  PlayingState(this.level, this.player, this.enemies, this.shots);
  PlayingState.create(this.level)
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
    if (_direction != null) _throttler.throttle(() => player.moveTargetTile(_direction!));
    level.updateAndShow(canvas, frameTimestamp);
    enemyOnNewFrame(canvas, frameTimestamp);
    shotOnNewFrame(canvas, frameTimestamp);
    player.updateAndShow(canvas, frameTimestamp);
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
      shot.updateAndShow(canvas, frameTimestamp);
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
      enemy.updateAndShow(canvas, frameTimestamp);
    }
  }

  @override
  void onAngleChanged(double angle) {
    player.setTargetTile = _calculateActiveTile(angle);
  }

  int _calculateActiveTile(double angle) {
    final tiles = level.tiles;
    for (int i = 0; i < tiles.length; i++) {
      final tile = tiles[i];
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
  final _throttler = Throttler(const Duration(milliseconds: Drawable.syncTime * 4));
  int? _direction;

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
