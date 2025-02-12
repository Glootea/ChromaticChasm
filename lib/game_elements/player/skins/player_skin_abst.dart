library;

export 'package:chromatic_chasm/game_elements/player/skins/player_skin_abst.dart';

import 'package:chromatic_chasm/game_elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game_elements/base_classes/positionable.dart';

abstract interface class PlayerSkin {
  List<Drawable> getDrawables(TilePositionable startPivot);
}
