import 'package:chromatic_chasm/game_elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game_elements/base_classes/positionable.dart';

class PlayerSkin1Left extends Drawable2D {
  PlayerSkin1Left(TilePositionable startPivot) : super(startPivot, _vertexes, _edges);
  static final _vertexes = [
    Positionable(0.0, 1.0, 0.0),
    Positionable(0.53, 0.0, 0.0),
    Positionable(-0.43, 1.3, 0.0),
    Positionable(0.0, 0.56, 0.0),
    Positionable(0.0, -1.0, 0.0),
    Positionable(-0.43, -0.1, 0.0),
    Positionable(0.0, -0.56, 0.0),
    Positionable(0.2, 0.0, 0.0)
  ];
  static final _edges = [
    [2, 0],
    [3, 2],
    [0, 1],
    [5, 4],
    [6, 5],
    [4, 1],
    [7, 6],
    [3, 7]
  ];
}
