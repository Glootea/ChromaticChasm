// import 'dart:math';
// import 'dart:ui';
// import 'package:chromatic_chasm/game_elements/base_classes/game_object.dart';
// import 'package:chromatic_chasm/game_elements/base_classes/positionable.dart';
// import 'package:chromatic_chasm/game_elements/player/player.dart';
// import '../level/level.dart';

// // Positionable(0, -_targetY, pivot.z + 100);
// // Positionable(_targetY > 10 ? -600 : 600, -_targetY, pivot.z + 200)
// // late final double _targetY = Random().nextInt(200) - 100;
// class GlobalPlayer extends StatelessGlobalGameObject {
//   GlobalPlayer._(this.player, this.paint, this.lastAngle, this._startPivot, this._anchorPivot, this._targetPivot)
//       : super(_startPivot, player.drawables[player.state]);
//   GlobalPlayer.flyAway(Player player) : this._flyAway(player, Random().nextInt(200) - 100);
//   GlobalPlayer._flyAway(Player player, double targetY)
//       : this._(
//             player,
//             player.paint,
//             player.level.tiles[player.level.activeTile].angle,
//             player.pivot,
//             Positionable(0, -targetY, player.pivot.z + 100),
//             Positionable(targetY > 100 ? -600 : 600, -targetY, player.pivot.z + 200));
//   GlobalPlayer.flyToLevel(Level level, Player player)
//       : this._flyToLevel(
//             level,
//             player,
//             Positionable(Random().nextInt(200) - 100 > 100 ? -600 : 600, -(Random().nextInt(200) - 100).toDouble(),
//                 player.pivot.z + 200));
//   GlobalPlayer._flyToLevel(Level level, Player player, Positionable startPivot)
//       : this._(
//             player,
//             player.paint,
//             atan2(startPivot.x - player.level.pivot.x, startPivot.y - player.level.pivot.y),
//             startPivot.clone(),
//             Positionable(200, 200, 500), //TODO: define
//             Positionable(120, 100, 0)); //TODO: define

//   Positionable currentPivot(double timeFraction) =>
//       _startPivot.scaled(pow((1 - timeFraction), 2).toDouble()) +
//       _anchorPivot.scaled(2 * timeFraction * (1 - timeFraction)) +
//       _targetPivot.scaled(timeFraction * timeFraction);

//   final Positionable _startPivot;
//   final Positionable _anchorPivot;
//   final Positionable _targetPivot;
//   final Player player;
//   final Paint paint;
//   double lastAngle;

//   late final Positionable prevPivot = Positionable.copy(pivot) - Positionable(0.0, 0.0, 1);
//   void updatePosition(double timeFraction) {
//     print("GP: " + currentPivot(timeFraction).toString());
//     pivot.setFrom(currentPivot(timeFraction));
//     player.pivot.setFrom(
//         pivot); // TODO: rewrite: find way to unite pivot of drawable and player when creating player. Maybe write super class for levelPlayer and globalPlayer
//   }

//   double get getAngle => atan2((pivot - prevPivot).x, (pivot - prevPivot).y) + pi;
//   @override
//   void onFrame(Canvas canvas, Positionable camera, DateTime frameTimestamp) {
//     final delta = getAngle - lastAngle;
//     lastAngle = lastAngle + (delta >= pi ? -(2 * pi - delta) : delta) * 0.05;
//     (drawable..applyTransformation(scaleToWidth: Player.playerSize, angleZ: lastAngle)).show(canvas, camera, paint);
//     prevPivot.setFrom(pivot);
//   }
// }
