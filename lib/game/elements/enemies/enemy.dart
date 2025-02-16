import 'package:chromatic_chasm/game/elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game/elements/base_classes/game_object.dart';
import 'package:chromatic_chasm/game/elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game/elements/camera.dart';
import 'package:chromatic_chasm/game/elements/enemies/entities/spider/drawables/spider_default_drawable.dart';
import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:chromatic_chasm/game/elements/player/player.dart';
import 'package:chromatic_chasm/game/elements/shot.dart';
import 'package:chromatic_chasm/game/helpers/tile_helper.dart';
import 'package:flutter/material.dart';

export 'package:chromatic_chasm/game/elements/enemies/enemy.dart';

part 'package:chromatic_chasm/game/elements/enemies/entities/spider/spider.dart';

sealed class Enemy extends StatelessTileGameObject {
  Enemy._(super.pivot, super.drawable);

  bool checkPlayerTookHit(Player player) {
    final hit =
        pivot.level.activeTile == pivot.tileNumber &&
        pivot.depthFraction <= 0.02;
    return hit;
  }

  ///Returns index of shot, that hit this enemy
  ///
  ///Returns null if no shot hit
  int? shotHitNumber(List<Shot> shots) {
    for (final (i, shot) in shots.indexed) {
      final hit =
          shot.pivot.tileNumber == pivot.tileNumber &&
          (shot.pivot.depthFraction - pivot.depthFraction).abs() < 0.05;
      if (hit) {
        _lifes -= 1;
        return i;
      }
    }
    return null;
  }

  int _lifes = 1;
  bool get checkDead => _lifes <= 0;

  void updatePosition(DateTime frameTimestamp);
  double get speed;
  bool get disappear;

  int scoreForKill = 50;
}
