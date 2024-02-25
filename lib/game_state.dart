import 'dart:developer' as dev;
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
        enemies = [],
        shots = [];
  @override
  void onFireButtonPressed() => shots.add(Shot(level, level.activeTile));

  @override
  void draw(Canvas canvas) {
    final frameTimestamp = DateTime.now();
    if (_direction != null) throttler.throttle(() => player.moveTargetTile(_direction!));
    level.show(canvas, frameTimestamp);
    for (int i = 0; i < enemies.length; i++) {
      final enemy = enemies[i];
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
