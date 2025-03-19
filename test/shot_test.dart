import 'dart:ui';

import 'package:chromatic_chasm/game/elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game/elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game/elements/camera.dart';
import 'package:chromatic_chasm/game/elements/enemies/enemy.dart';
import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:chromatic_chasm/game/elements/shot.dart';
import 'package:test/test.dart';

void main() {
  group('Shot:', () {
    final level = Level1();
    const tileNumber = 1;
    Shot shot = Shot(level, tileNumber);

    final canvas = Canvas(PictureRecorder());
    final camera = Camera(Positionable(0, 0, 0));
    Drawable.setCanvasSize(const Size(100, 100));

    setUp(() {
      shot = Shot(level, tileNumber);
    });

    test('move along level', () {
      assert(shot.pivot.depthFraction == 0, 'Must start on front edge');

      DateTime time = DateTime.now().add(const Duration(milliseconds: 30));
      shot.onFrame(canvas, camera, time);
      final secondDepthFraction = shot.pivot.depthFraction;
      assert(secondDepthFraction != 0, 'Shot must fly towards end');

      time = time.add(const Duration(milliseconds: 30));
      shot.onFrame(canvas, camera, time);
      final thirdDepthFraction = shot.pivot.depthFraction;
      assert(
        thirdDepthFraction > secondDepthFraction,
        'Shot must fly towards end, be farer with each iteration',
      );
    });
    test('disappear on fly to end', () {
      assert(shot.pivot.depthFraction == 0, 'Must start on front edge');

      DateTime time = DateTime.now();
      int framesLeft = 100;
      while (!shot.disappear && framesLeft > 0) {
        time = time.add(const Duration(milliseconds: 30));
        shot.onFrame(canvas, camera, time);

        framesLeft--;
      }
      assert(framesLeft != 0, 'Shot must disappear after reaching end');
    });

    test('disappear on hit', () {
      final enemy = Spider(level, tileNumber);

      assert(shot.pivot.depthFraction == 0, 'Must start on front edge');

      DateTime time = DateTime.now();
      int framesLeft = 100;
      while (!shot.disappear && !enemy.disappear && framesLeft > 0) {
        time = time.add(const Duration(milliseconds: 30));
        shot.onFrame(canvas, camera, time);
        enemy.onFrame(canvas, camera, time);
        framesLeft--;
      }
      assert(framesLeft != 0, 'Shot must disappear after hitting enemy');
    });
  });
}
