library position;

import 'package:tempest/game_elements/base_classes/positioned.dart';

abstract mixin class Movable implements Positioned {
  void moveImmediately({double x, double y, double z});
  void setSpeed({double x, double y, double z});
  void updatePosition();
}
