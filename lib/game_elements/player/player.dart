import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/base_classes/transfromable.dart';

class Player extends TilePositionable with Transformable {
  Player(super.tileMainLine, super.depthFraction, {super.offset});
}
