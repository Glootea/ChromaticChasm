import 'package:tempest/game_elements/base_classes/positionable.dart';

abstract mixin class Transformable {
  // TODO: test transformation on player
  /// Angle is in radians
  void rotateX(Positionable pivot, List<Positionable> points, double angle) => points
      .map((point) => point.moveRotationPointToOrigin(pivot).rotateXAroundOrigin(angle).moveRotationPointBack(pivot));
  void rotateY(Positionable pivot, List<Positionable> points, double angle) => points
      .map((point) => point.moveRotationPointToOrigin(pivot).rotateYAroundOrigin(angle).moveRotationPointBack(pivot));
  void rotateZ(Positionable pivot, List<Positionable> points, double angle) => points
      .map((point) => point.moveRotationPointToOrigin(pivot).rotateZAroundOrigin(angle).moveRotationPointBack(pivot));
}
