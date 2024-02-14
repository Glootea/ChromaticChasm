import 'package:tempest/game_elements/level/tile/tile_main_line.dart';

class Positioned {
  /// Horizontal coordinate
  double x;

  /// Vertical coordinate
  double y;

  /// Depth coordinate
  double z;
  Positioned(this.x, this.y, this.z);
  Positioned.from(Positioned other) : this(other.x, other.y, other.z);

  static Positioned median(Positioned first, Positioned second) {
    return Positioned((first.x + second.x) / 2, (first.y + second.y) / 2, (first.z + second.z) / 2);
  }

  static Positioned positionWithFraction(Positioned first, Positioned second, double fraction) {
    throw UnimplementedError();
  }

  Positioned operator +(Positioned other) {
    return Positioned(x + other.x, y + other.y, z + other.z);
  }
}

class LevelPositioned extends Positioned {
  Positioned levelPivot;
  Positioned offsetPosition;
  LevelPositioned(this.levelPivot, this.offsetPosition)
      : super(
          levelPivot.x + offsetPosition.x,
          levelPivot.y + offsetPosition.y,
          levelPivot.z + offsetPosition.z,
        );
}

class TilePositioned extends Positioned {
  TileMainLine tileMainLine;
  double depthFraction;
  Positioned? offset;
  TilePositioned(this.tileMainLine, this.depthFraction, {this.offset})
      : super.from(Positioned.positionWithFraction(
              tileMainLine.close,
              tileMainLine.far,
              depthFraction,
            ) +
            (offset ?? Positioned(0, 0, 0)));
}
