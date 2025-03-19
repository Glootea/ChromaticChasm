import 'dart:ui';

import 'package:chromatic_chasm/game/elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game/elements/base_classes/game_object_lifecycle.dart';
import 'package:chromatic_chasm/game/elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game/elements/camera.dart';
import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:chromatic_chasm/game/elements/player/player.dart';
import 'package:test/test.dart';

void main() {
  group('Player:', () {
    final canvas = Canvas(PictureRecorder());
    final camera = Camera(Positionable(0, 0, 0));
    Drawable.setCanvasSize(const Size(100, 100));

    test('move on non circular level', () {
      final level = Level1();
      final player = Player(level)..lifecycleState = PlayerLive();

      assert(
        player.pivot.tileNumber == level.tiles.length ~/ 2,
        'Must start at center',
      );

      player.setTargetTile = (level.tiles.length ~/ 2) - 2;
      int framesLeft = 100;

      DateTime time = DateTime.now();
      while (framesLeft < 100) {
        time = time.add(const Duration(milliseconds: 30));
        player.onFrame(canvas, camera, time);
        framesLeft--;

        if (player.pivot.tileNumber == (level.tiles.length ~/ 2) - 2) break;
      }
      if (framesLeft == 0) {
        assert(false, 'Target tile has not been reached in time');
      }
    });

    test('move on circular level', () {
      final level = Level2();
      final player = Player(level)..lifecycleState = PlayerLive();

      assert(
        player.pivot.tileNumber == level.tiles.length ~/ 2,
        'Must start at center',
      );

      int targetTile = 0;
      player.setTargetTile = targetTile;
      int framesLeft = 100;
      DateTime time = DateTime.now();

      while (framesLeft > 0) {
        time = time.add(const Duration(milliseconds: 30));
        player.onFrame(canvas, camera, time);
        framesLeft--;

        if (player.pivot.tileNumber == targetTile) break;
      }
      if (framesLeft == 0) {
        assert(false, 'Target tile has not been reached in time');
      }

      targetTile = level.tiles.length - 1;
      player.setTargetTile = targetTile;
      framesLeft = 100;
      time = DateTime.now();
      while (framesLeft > 0) {
        time = time.add(const Duration(milliseconds: 30));
        player.onFrame(canvas, camera, time);
        framesLeft--;

        if (player.pivot.tileNumber == targetTile) break;
        assert(
          player.pivot.tileNumber != level.tiles.length ~/ 2,
          'Long path must not be taken as shorter/without full loop exists',
        );
      }
      if (framesLeft == 0) {
        assert(false, 'Target tile has not been reached in time');
      }
    });
  });
}
