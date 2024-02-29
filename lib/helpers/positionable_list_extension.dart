import 'package:tempest/game_elements/base_classes/positionable.dart';

extension PositionableListExtension on List<Positionable> {
  List<Positionable> toGlobal(Positionable pivot) => map((e) => e + pivot).toList();
}
