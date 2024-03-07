import 'package:tempest/game_elements/base_classes/positionable.dart';

class LevelTileHelper {
  static double getTileWidth(TilePositionable pivot) => pivot.level.tiles[pivot.tileNumber].width / 2;
  static double getAngle(TilePositionable pivot) => pivot.level.tiles[pivot.tileNumber].angle;
}
