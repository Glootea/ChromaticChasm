import 'package:tempest/game_elements/base_classes/positionable.dart';

abstract mixin class Transformable {
  /// Angle is in radians
  List<Positionable> rotateX(Positionable pivot, List<Positionable> points, double angle) => points
      .map((point) => point.moveRotationPointToOrigin(pivot).rotateXAroundOrigin(angle).moveRotationPointBack(pivot))
      .toList();
  List<Positionable> rotateY(Positionable pivot, List<Positionable> points, double angle) => points
      .map((point) => point.moveRotationPointToOrigin(pivot).rotateYAroundOrigin(angle).moveRotationPointBack(pivot))
      .toList();
  List<Positionable> rotateZ(Positionable pivot, List<Positionable> points, double angle) => points
      .map((point) => point.moveRotationPointToOrigin(pivot).rotateZAroundOrigin(angle).moveRotationPointBack(pivot))
      .toList();
}
