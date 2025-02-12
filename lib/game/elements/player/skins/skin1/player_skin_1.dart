import 'package:chromatic_chasm/game/elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game/elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game/elements/player/skins/player_skin_abst.dart';
import 'package:chromatic_chasm/game/elements/player/skins/skin1/drawables/player_skin_1_center.dart';
import 'package:chromatic_chasm/game/elements/player/skins/skin1/drawables/player_skin_1_left.dart';
import 'package:chromatic_chasm/game/elements/player/skins/skin1/drawables/player_skin_1_right.dart';

class PlayerSkin1 implements PlayerSkin {
  @override
  List<Drawable2D> getDrawables(TilePositionable startPivot) => [
        PlayerSkin1Left(startPivot),
        PlayerSkin1Center(startPivot),
        PlayerSkin1Right(startPivot),
      ];
}
