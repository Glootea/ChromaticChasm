import 'dart:math';

import 'package:chromatic_chasm/game/elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game/elements/base_classes/positionable.dart';
import 'package:test/test.dart';

void main() {
  group('Drawable: ', () {
    Positionable pivot = Positionable(0, 0, 0);
    Drawable drawable = Drawable2D(
      pivot,
      [Positionable(0, 0, 0), Positionable(1, 0, 0), Positionable(0, 1, 0)],
      [
        [0, 1],
        [1, 2],
        [0, 2],
      ],
    );

    setUp(() {
      pivot = Positionable(0, 0, 0);
      drawable = Drawable2D(
        pivot,
        [Positionable(0, 0, 0), Positionable(1, 0, 0), Positionable(0, 1, 0)],
        [
          [0, 1],
          [1, 2],
          [0, 2],
        ],
      );
    });

    test('rotate along z with zero pivot', () {
      drawable.rotateZ(pi / 2);
      final rotatedVertexes = drawable.getGlobalVertexes;
      assert(rotatedVertexes.contains(Positionable(0, 0, 0)));
      assert(
        rotatedVertexes.contains(Positionable(6.123234262925839e-17, -1, 0)),
      );
      assert(
        rotatedVertexes.contains(Positionable(1, 6.123234262925839e-17, 0)),
      );
    });
    test('rotate along y with shifted pivot', () {
      pivot = Positionable(1, 1, 1);
      drawable.rotateY(pi);
      final rotatedVertexes = drawable.getGlobalVertexes;
      assert(rotatedVertexes.contains(Positionable(0, 0, 0)));
      assert(
        rotatedVertexes.contains(
          Positionable(-1.0, 0.0, 1.2246468525851679e-16),
        ),
      );
      assert(rotatedVertexes.contains(Positionable(0, 1.0, 0)));
    });
  });
}
