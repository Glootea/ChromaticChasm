import 'dart:ui';

import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/game_object.dart';
import 'package:tempest/game_elements/base_classes/game_object_lifecycle.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';

class Camera extends StatelessGlobalGameObject {
  Camera(Positionable pivot, {CameraLifeCycle? cameraLifeCycle})
      : super(pivot, Drawable2D(pivot, [], []), lifecycle: cameraLifeCycle ?? CameraStationary());

  @override
  void onFrame(Canvas canvas, Camera camera, DateTime frameTimestamp) {
    print(lifecycleState.runtimeType);
    switch (lifecycleState.runtimeType) {
      case CameraStationary:
        null;
      case CameraMoving:
        {
          pivot.setFrom((lifecycleState as CameraMoving).currentPosition);
          print("Camera pivot: $pivot");
        }

      case _:
        throw UnimplementedError("Unimplemented camera lifecycleState: ${lifecycleState.runtimeType} ");
    }
  }
}
