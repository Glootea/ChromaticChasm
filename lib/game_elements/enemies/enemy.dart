import 'dart:ui';

import 'package:tempest/game_elements/base_classes/drawable.dart';

class Enemy with Drawable {
  @override
  void show(Canvas canvas, DateTime frameTimestamp) {
    // TODO: implement show
  }

  bool checkPlayerHit() {
    return false;
  }

  bool checkShotHit() {
    return false;
  }
}
