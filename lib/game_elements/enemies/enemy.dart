library enemy;

import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/game_object.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/level/level.dart';
export 'package:tempest/game_elements/enemies/enemy.dart';
import 'package:tempest/game_elements/player/player.dart';
import 'package:tempest/game_elements/shot.dart';
import 'package:tempest/helpers/tile_helper.dart';

part 'package:tempest/game_elements/enemies/entities/spider.dart';

sealed class Enemy extends StatelessTileGameObject {
  Enemy._(super.pivot, super.drawable);

  bool checkPlayerHit(Player player) {
    final hit = pivot.level.activeTile == pivot.tileNumber && pivot.depthFraction <= 0.02;
    return hit;
  }

  ///Returns number of shot, that hit this enemy
  ///
  ///Returns null if no shot hit
  int? shotHitNumber(List<Shot> shots) {
    for (final (i, shot) in shots.indexed) {
      final hit =
          shot.pivot.tileNumber == pivot.tileNumber && (shot.pivot.depthFraction - pivot.depthFraction).abs() < 0.05;
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
}
