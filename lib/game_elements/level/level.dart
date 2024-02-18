import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/level/tile/level_tile.dart';
import 'package:tempest/game_elements/base_classes/movable.dart';

sealed class Level extends ChangeNotifier with Drawable {
  ///Default [pivot] is [Movable(0, 0, 50)]
  Movable pivot;

  ///Whether player can move from last tile to first or vice versa
  bool circlular;
  List<LevelTile> tiles;

  Level(this.pivot, this.tiles, this.circlular);

  /// Tile where pleyer is. It has different color
  late int activeTile = tiles.length ~/ 2;
  set setActiveTile(int value) {
    activeTile = value % tiles.length;
    notifyListeners();
  }

  //TODO: implement incremental movement to target tile
  late int targetTile = tiles.length ~/ 2;

  /// [points] must be in range -100 to 100 in both x and y. [depth] prefered to be around 1000
  Level.fromPoints(Movable pivot, List<Positionable> points, double depth, bool circlular)
      : this(pivot, _pointsToTiles(pivot, points, depth, circlular), circlular);

  @override
  void show(Canvas canvas) {
    for (int i = 0; i < tiles.length; i++) {
      if (i != activeTile) {
        tiles[i].show(canvas);
      }
      tiles[activeTile].showActive(canvas);
    }
  }

  ///Creates tiles iteratively by connecting [i] and [i+1] points. If circlular first and last points are connected
  static List<LevelTile> _pointsToTiles(Positionable pivot, List<Positionable> points, double depth, bool circlular) {
    final output = <LevelTile>[];
    for (int i = 0; i < points.length - 1; i++) {
      output.add(LevelTile.from(pivot, points[i], points[i + 1], depth));
    }
    if (circlular) {
      output.add(LevelTile.from(pivot, points.last, points.first, depth));
    }
    return output;
  }
}

class Level1 extends Level {
  static final Movable _level1Pivot = Movable(0, 0, 50);
  static final List<Positionable> _level1Points = [
    Positionable(-140, -50, 0),
    Positionable(-125, -25, 0),
    Positionable(-100, 0, 0),
    Positionable(-75, 25, 0),
    Positionable(-50, 50, 0),
    Positionable(-25, 75, 0),
    Positionable(0, 100, 0),
    Positionable(25, 75, 0),
    Positionable(50, 50, 0),
    Positionable(75, 25, 0),
    Positionable(100, 0, 0),
    Positionable(125, -25, 0),
    Positionable(140, -50, 0),
  ];
  Level1() : super.fromPoints(_level1Pivot, _level1Points, 1000, false);
}
