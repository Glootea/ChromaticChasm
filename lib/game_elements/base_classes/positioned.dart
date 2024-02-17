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
}

///This position should be applied to everything that exist in the level and should be connected to level pivot
///
/// For example [tile.points]
class LevelPositioned extends Positionable {
  Positionable levelPivot;
  Positionable offsetPosition;
  LevelPositioned(this.levelPivot, this.offsetPosition) : super.zero() {
    setFrom(levelPivot + offsetPosition);
  }
}

///This position should be applied to everything that exist on tiles
///
///For example [player], [enemies], [shots]
class TilePositioned extends Positionable {
  TileMainLine tileMainLine;
  double depthFraction;
  Positionable? offset;
  TilePositioned(this.tileMainLine, this.depthFraction, {this.offset}) : super.zero() {
    setFrom(
      PositionFunctions.positionWithFraction(tileMainLine.close, tileMainLine.far, depthFraction) +
          (offset ?? Positionable(0, 0, 0)),
    );
  }
}
