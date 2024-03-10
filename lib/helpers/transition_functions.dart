import 'dart:math';
import 'package:tempest/game_elements/base_classes/positionable.dart';

typedef TransitionFunction = Positionable
    Function(double timeFraction, Positionable startPivot, Positionable targetPivot, {Positionable? anchorPivot});

class TransitionFunctions {
  static Positionable getDefaultAnchorPoint(Positionable startPivot, Positionable targetPivot) =>
      PositionFunctions.median(startPivot, targetPivot);

  static Positionable bezierCurve(double timeFraction, Positionable startPivot, Positionable targetPivot,
          {Positionable? anchorPivot}) =>
      startPivot.scaled(pow((1 - timeFraction), 2).toDouble()) +
      (anchorPivot ?? getDefaultAnchorPoint(startPivot, targetPivot)).scaled(2 * timeFraction * (1 - timeFraction)) +
      targetPivot.scaled(timeFraction * timeFraction);
}
