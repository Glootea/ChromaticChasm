import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/game_object.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';

class Star extends StatelessGlobalGameObject {
  Star(super.pivot, super.drawable);

  @override
  void onFrame(Canvas canvas, Positionable camera, DateTime frameTimestamp) {
    // TODO: implement onFrame
  }
}
