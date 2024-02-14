import 'package:tempest/game_elements/base_classes/positioned.dart';
import 'package:tempest/game_elements/level/tile/tile_main_line.dart';

class LevelTile {
  List<LevelPositioned> points;
  TileMainLine get mainLine => _mainLine ?? _getMainLine();
  TileMainLine? _mainLine;
  TileMainLine _getMainLine() {
    _mainLine = TileMainLine(
      Positioned.median(points[0], points[3]),
      Positioned.median(points[1], points[2]),
    );
    return _mainLine!;
  }

  LevelTile(this.points) {
    assert(points.length > 3);
  }
}
