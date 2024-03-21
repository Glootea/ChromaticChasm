import 'dart:math';

import 'package:chromatic_chasm/game_elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game_elements/base_classes/game_object.dart';
import 'package:chromatic_chasm/game_elements/base_classes/game_object_lifecycle.dart';
import 'package:chromatic_chasm/game_elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game_elements/camera.dart';
import 'package:chromatic_chasm/game_elements/level/level.dart';
import 'package:chromatic_chasm/helpers/positionable_generator.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show Vector3;

class Star extends StatelessGlobalGameObject {
  Star.createStationary(Level level) : this._createStationary(PositionableGenerator.aroundLevel(level));
  Star._createStationary(Positionable pivot)
      : super(
          pivot,
          Drawable3D(pivot, _vertices, _faces)
            ..applyTransformation(
                scaleToWidth: Random().nextDouble() * 10,
                angleX: Random().nextDouble() * 2 * pi,
                angleY: Random().nextDouble() * 2 * pi,
                angleZ: Random().nextDouble() * 2 * pi),
          lifecycle: ObjectStationary(),
        );

  Star.createMoving() : this._createMoving(Positionable.random().scaled(1000));
  Star._createMoving(Positionable startPivot)
      : super(
          startPivot,
          Drawable3D(startPivot, _vertices, _faces),
          lifecycle: FlyingLifecycle()..configureFlying(startPivot, Vector3.random().scaled(10.0)),
        );

  @override
  void onFrame(Canvas canvas, Camera camera, DateTime frameTimestamp) {
    if (lifecycleState.runtimeType == FlyingLifecycle) {
      pivot.setFrom((lifecycleState as FlyingLifecycle).getCurrentPosition(frameTimestamp));
    }
    drawable.show(canvas, camera, paint);
  }

  final paint = Paint()
    ..color = Colors.white
    ..strokeWidth = Drawable.strokeWidthLight;

  static final List<Positionable> _vertices = [
    Positionable(0.0, 0.0, -1.0),
    Positionable(0.72, -0.53, -0.45),
    Positionable(-0.28, -0.85, -0.45),
    Positionable(-0.89, 0.0, -0.45),
    Positionable(-0.28, 0.85, -0.45),
    Positionable(0.72, 0.53, -0.45),
    Positionable(0.28, -0.85, 0.45),
    Positionable(-0.72, -0.53, 0.45),
    Positionable(-0.72, 0.53, 0.45),
    Positionable(0.28, 0.85, 0.45),
    Positionable(0.89, 0.0, 0.45),
    Positionable(0.0, 0.0, 1.0)
  ];

  static final List<List<int>> _faces = [
    [0, 1, 2],
    [1, 0, 5],
    [0, 2, 3],
    [0, 3, 4],
    [0, 4, 5],
    [1, 5, 10],
    [2, 1, 6],
    [3, 2, 7],
    [4, 3, 8],
    [5, 4, 9],
    [1, 10, 6],
    [2, 6, 7],
    [3, 7, 8],
    [4, 8, 9],
    [5, 9, 10],
    [6, 10, 11],
    [7, 6, 11],
    [8, 7, 11],
    [9, 8, 11],
    [10, 9, 11]
  ];
}
