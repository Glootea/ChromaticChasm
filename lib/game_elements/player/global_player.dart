import 'dart:math';
import 'dart:ui';
import 'package:tempest/game_elements/base_classes/game_object.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/player/player.dart';

class GlobalPlayer extends StatelessGlobalGameObject {
  GlobalPlayer._(super.pivot, super.drawable, this.paint, this.lastAngle);
  GlobalPlayer.fromPlayer(Player player)
      : this._(player.pivot, player.drawables[player.state], player.paint,
            player.level.tiles[player.level.activeTile].angle);

  Positionable currentPivot(double timeFraction) =>
      _startPivot.scaled(pow((1 - timeFraction), 2).toDouble()) +
      _anchorPivot.scaled(2 * timeFraction * (1 - timeFraction)) +
      _targetPivot.scaled(timeFraction * timeFraction);

  late final double _targetY = Random().nextInt(200) - 100;
  late final _startPivot = pivot.clone();
  late final Positionable _anchorPivot = Positionable(0, -_targetY, pivot.z + 100);
  late final Positionable _targetPivot = Positionable(_targetY > 10 ? -600 : 600, -_targetY, pivot.z + 200);

  final Paint paint;
  double lastAngle;

  late final Positionable prevPivot = Positionable.copy(pivot) - Positionable(0.0, 0.0, 1);
  updatePosition(double timeFraction) {
    pivot.setFrom(currentPivot(timeFraction));
  }

  double get getAngle => atan2((pivot - prevPivot).x, (pivot - prevPivot).y) + pi;
  @override
  void onFrame(Canvas canvas, Positionable camera, DateTime frameTimestamp) {
    final delta = getAngle - lastAngle;
    lastAngle = lastAngle + (delta >= pi ? -(2 * pi - delta) : delta) * 0.05;
    (drawable..applyTransformation(scaleToWidth: Player.playerSize, angleZ: lastAngle)).show(canvas, camera, paint);
    prevPivot.setFrom(pivot);
  }
}
