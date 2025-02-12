library;

import 'package:chromatic_chasm/game/elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game/elements/base_classes/positionable.dart';

export 'package:chromatic_chasm/game/elements/player/skins/player_skin_abst.dart';

abstract interface class PlayerSkin {
  List<Drawable> getDrawables(TilePositionable startPivot);
}
