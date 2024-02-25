import 'dart:ui';
import 'dart:developer' as dev;
import 'package:tempest/game_elements/enemies/enemy.dart';
import 'package:tempest/game_elements/level/level.dart';
import 'package:tempest/game_elements/player/player.dart';
import 'package:tempest/game_elements/shot.dart';

sealed class GameState {
  void onFireButtonPressed();
  void onAngleChanged(double angle);
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
  void onFireButtonPressed() => shots.add(Shot(level, player.tileNumber));

  @override
  void draw(Canvas canvas) {
    level.show(canvas);
    for (final element in enemies) {
      element.show(canvas);
    }
    for (final element in shots) {
      element.show(canvas);
    }

    player.show(canvas);
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
}
