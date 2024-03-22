library player_skin;

export 'package:chromatic_chasm/game_elements/player/skins/player_skin_abst.dart';

import 'package:chromatic_chasm/game_elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game_elements/base_classes/positionable.dart';

import 'skin1/drawables/player_skin_1_left.dart';
import 'skin1/drawables/player_skin_1_center.dart';
import 'skin1/drawables/player_skin_1_right.dart';
part 'package:chromatic_chasm/game_elements/player/skins/skin1/player_skin_1.dart';

abstract interface class PlayerSkin {
  List<Drawable> getDrawables(TilePositionable startPivot);
}
