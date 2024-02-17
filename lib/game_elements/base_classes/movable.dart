import 'package:tempest/game_elements/base_classes/positioned.dart';

class Movable extends Positionable {
  double xSpeed = 0;
  double ySpeed = 0;
  double zSpeed = 0;

  Movable(double x, double y, double z) : super.zero() {
    setValues(x, y, z);
  }
  Movable.withSpeed(double x, double y, double z, this.xSpeed, this.ySpeed, this.zSpeed) : super.zero() {
    setValues(x, y, z);
  }

  void moveImmediately({double? x, double? y, double? z}) {
    this.x = x ?? this.x;
    this.y = y ?? this.y;
    this.z = z ?? this.z;
  }

  void setSpeed({double? x, double? y, double? z}) {
    xSpeed = x ?? xSpeed;
    ySpeed = y ?? ySpeed;
    zSpeed = z ?? zSpeed;
  }

  void updatePosition() {
    x += xSpeed;
    y += ySpeed;
    z += zSpeed;
  }
}
