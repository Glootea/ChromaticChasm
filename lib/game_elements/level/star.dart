import 'dart:ui';
import 'package:tempest/game_elements/base_classes/drawable_old.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';

class Star extends Positionable with DrawableOld {
  Star(Positionable startPoint) : super.zero() {
    setFrom(startPoint);
  }
  final List<Positionable> points = [];
  @override
  void updateAndShow(Canvas canvas, DateTime frameTimestamp) {
    // TODO: implement updateAndShow
  }
}
