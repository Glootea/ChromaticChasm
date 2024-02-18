import 'dart:math';

import 'package:tempest/game_elements/level/tile/tile_main_line.dart';
import 'package:vector_math/vector_math.dart';

typedef Positionable = Vector3;

extension PositionFunctions on Positionable {
  static Positionable median(Positionable first, Positionable second) => first
    ..add(second)
    ..scale(0.5);

  static Positionable positionWithFraction(Positionable first, Positionable second, double fraction) {
    return first + ((second - first) * fraction);
  }

  Positionable moveRotationPointToOrigin(Positionable pivot) => this - pivot;
  Positionable moveRotationPointBack(Positionable pivot) => this + pivot;
  Positionable rotateXAroundOrigin(double angle) =>
      Matrix3(1, 0, 0, 0, cos(angle), -sin(angle), 0, sin(angle), cos(angle)).transformed(this);
  Positionable rotateYAroundOrigin(double angle) =>
      Matrix3(cos(angle), 0, sin(angle), 0, 1, 0, -sin(angle), 0, cos(angle)).transformed(this);
  Positionable rotateZAroundOrigin(double angle) =>
      Matrix3(cos(angle), -sin(angle), 0, sin(angle), cos(angle), 0, 0, 0, 1).transformed(this);
}

///This position should be applied to everything that exist in the level and should be connected to level pivot
///
/// For example [tile.points]
class LevelPositionable extends Positionable {
  Positionable levelPivot;
  Positionable offsetPosition;
  LevelPositionable(this.levelPivot, this.offsetPosition) : super.zero() {
    setFrom(levelPivot + offsetPosition);
  }
}

///This position should be applied to everything that exist on tiles
///
///For example [player], [enemies], [shots]
class TilePositionable extends Positionable {
  TileMainLine tileMainLine;
  double depthFraction;
  double widthFraction = 0.5;
  Positionable? offset;
  TilePositionable(this.tileMainLine, this.depthFraction, {this.offset}) : super.zero() {
    setFrom(
      PositionFunctions.positionWithFraction(tileMainLine.close, tileMainLine.far, depthFraction) +
          (offset ?? Positionable(0, 0, 0)),
    );
  }
}
