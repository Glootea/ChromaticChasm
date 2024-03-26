import 'dart:math';
import 'package:chromatic_chasm/game_elements/base_classes/transformable.dart';
import 'package:chromatic_chasm/game_elements/level/level.dart';
import 'package:vector_math/vector_math.dart';

// typedef Positionable = Vector3;
class Positionable extends Vector3 implements Transformable {
  Positionable(double x, double y, double z) : super.zero() {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  Positionable.zero() : super.zero();
  factory Positionable.copy(Vector3 other) {
    return Positionable.zero()..setFrom(other);
  }
  @override
  Positionable operator +(covariant other) => Positionable.zero()..setValues(x + other.x, y + other.y, z + other.z);
  @override
  Positionable operator -(covariant other) => Positionable.zero()..setValues(x - other.x, y - other.y, z - other.z);
  @override
  Positionable operator *(covariant scale) => Positionable.zero()..setValues(x * scale, y * scale, z * scale);
  @override
  Positionable operator /(covariant scale) => Positionable.zero()..setValues(x / scale, y / scale, z / scale);

  factory Positionable.random() {
    return Vector3.random() as Positionable;
  }
  factory Positionable.all(double a) {
    return Positionable.zero()..setValues(a, a, a);
  }
  @override
  Positionable clone() => Positionable.zero()..setValues(x, y, z);

  @override
  void applyTransformation({double? angleX, double? angleY, double? angleZ, double? widthToScale}) {
    widthToScale != null ? scaleToWidth(widthToScale) : null;
    angleX != null ? rotateX(angleX) : null;
    angleY != null ? rotateY(angleY) : null;
    angleZ != null ? rotateZ(angleZ) : null;
  }

  @override
  List<Positionable> rotateX(double angle) =>
      [Positionable.copy(Matrix3(1, 0, 0, 0, cos(angle), -sin(angle), 0, sin(angle), cos(angle)).transformed(this))];
  @override
  List<Positionable> rotateY(double angle) =>
      [Positionable.copy(Matrix3(cos(angle), 0, sin(angle), 0, 1, 0, -sin(angle), 0, cos(angle)).transformed(this))];
  @override
  List<Positionable> rotateZ(double angle) =>
      [Positionable.copy(Matrix3(cos(angle), -sin(angle), 0, sin(angle), cos(angle), 0, 0, 0, 1).transformed(this))];

  @override
  List<Transformable> scaleToWidth(double width) {
    throw UnimplementedError();
  }
}

extension PositionFunctions on Positionable {
  static Positionable median(Positionable first, Positionable second) => (first + second) * 0.5;

  static Positionable positionWithFraction(Positionable first, Positionable second, double fraction) =>
      first + ((second - first) * fraction);
  Positionable toGlobal(Positionable pivot) => this + pivot;
}

///This position should be applied to everything that exist in the level and should be connected to level pivot
///
/// For example [tile.points]
class LevelPositionable extends Positionable {
  Positionable levelPivot;
  Positionable offsetPosition;
  LevelPositionable(this.levelPivot, this.offsetPosition) : super(0, 0, 0) {
    setFrom(levelPivot + offsetPosition);
  }
}

///This position should be applied to everything that exist on tiles
///
///For example [Player], [Enemy], [Shot]
class TilePositionable extends Positionable {
  final Level level;
  int tileNumber;

  ///0 - on close edge of level, 1 - on far edge
  double depthFraction;
  double widthFraction = 0.5;

  ///Aditional offset in global coordinates. For example, used by [Player] to fly outside the level
  Positionable? offset;
  TilePositionable(this.level, this.tileNumber, {this.depthFraction = 0, this.offset}) : super(0, 0, 0) {
    setFrom(globalPosition);
  }
  Positionable get globalPosition {
    final leftLinePoint = PositionFunctions.positionWithFraction(
        level.tiles[tileNumber].leftNearPointGlobal, level.tiles[tileNumber].leftFarPointGlobal, depthFraction);
    final rightLinePoint = PositionFunctions.positionWithFraction(
        level.tiles[tileNumber].rightNearPointGlobal, level.tiles[tileNumber].rightFarPointGlobal, depthFraction);

    return PositionFunctions.positionWithFraction(leftLinePoint, rightLinePoint, widthFraction) +
        (offset ?? Positionable.zero());
  }

  void updatePosition({double? depthFraction, double? widthFraction, Positionable? offset}) {
    this.depthFraction = depthFraction ?? this.depthFraction;
    this.widthFraction = widthFraction ?? this.widthFraction;
    this.offset = offset ?? this.offset;
    setFrom(globalPosition);
  }
}
