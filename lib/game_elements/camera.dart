import 'dart:ui';

import 'package:chromatic_chasm/game_elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game_elements/base_classes/game_object.dart';
import 'package:chromatic_chasm/game_elements/base_classes/game_object_lifecycle.dart';
import 'package:chromatic_chasm/game_elements/base_classes/positionable.dart';

class Camera extends StatelessGlobalGameObject {
  Camera(Positionable pivot, {ObjectLifeCycle? cameraLifeCycle})
      : super(pivot, Drawable2D(pivot, [], []), lifecycle: cameraLifeCycle ?? ObjectStationary());

  @override
  void onFrame(Canvas canvas, Camera camera, DateTime frameTimestamp) {
    switch (lifecycleState.runtimeType) {
      case ObjectStationary:
        null;
      case ObjectMoving:
        {
          pivot.setFrom((lifecycleState as ObjectMoving).currentPosition);
        }

      case _:
        throw UnimplementedError("Unimplemented camera lifecycleState: ${lifecycleState.runtimeType} ");
    }
  }
}
