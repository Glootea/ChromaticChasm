import 'dart:math';
import 'package:tempest/game_elements/level/level.dart';
import 'package:vector_math/vector_math.dart';

typedef Positionable = Vector3;

extension PositionFunctions on Positionable {
  static Positionable median(Positionable first, Positionable second) => first
    ..add(second)
    ..scale(0.5);

  static Positionable positionWithFraction(
          Positionable first, Positionable second, Positionable pivot, double fraction) =>
      first + ((second - first) * fraction) + pivot;

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
  Level level;
  int tileNumber;

  ///0 - on close edge of level, 1 - on far edge
  double depthFraction;
  double widthFraction = 0.5;
  Positionable? offset;
  TilePositionable(this.level, this.tileNumber, {this.depthFraction = 0, this.offset}) : super.zero() {
    setFrom(
      PositionFunctions.positionWithFraction(level.tiles[tileNumber].mainLine.close,
              level.tiles[tileNumber].mainLine.far, level.pivot, depthFraction) +
          (offset ?? Positionable(0, 0, 0)),
    );
  }
}
