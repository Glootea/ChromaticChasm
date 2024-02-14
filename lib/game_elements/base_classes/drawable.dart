import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:tempest/game_elements/base_classes/positioned.dart';

abstract mixin class Drawable {
  @mustCallSuper
  void draw(Canvas canvas, Function prepareLines) {
    _project2D(prepareLines.call());
    //
  }

  /// Return projection of 3d spaced coordinates to offsets on 2d screen
  List<Offset> _project2D(List<Positioned> list);
}
