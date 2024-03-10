import 'dart:math';
import 'dart:ui';

import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/level/level.dart';
import 'package:tempest/helpers/easing.dart';
import 'package:tempest/helpers/transition_functions.dart';

sealed class GameObjectLifecycle {
  final DateTime startTime;
  GameObjectLifecycle() : startTime = DateTime.now();
}

mixin class TimefulLifecycle implements GameObjectLifecycle {
  Duration duration = const Duration(seconds: 1);
  set _setDuration(Duration d) => duration = d;
  double get timeFraction => DateTime.now().difference(startTime).inMilliseconds / duration.inMilliseconds;

  @override
  final DateTime startTime = DateTime.now();
}

mixin class TransitionLifeCycle implements TimefulLifecycle {
  @override
  final DateTime startTime = DateTime.now();
  @override
  Duration duration = const Duration(seconds: 3);
  @override
  set _setDuration(Duration d) => duration = d;

  Positionable _startOffsetPivot = Positionable.zero();
  late Positionable _anchorOffsetPivot = PositionFunctions.median(_startOffsetPivot, _endOffsetPivot);
  Positionable _endOffsetPivot = Positionable.zero();
  EasingFunction _easingFunction = EasingFunctions.linear;
  TransitionFunction _transitionFunction = TransitionFunctions.bezierCurve;

  void configureTransition(Positionable startOffsetPivot, Positionable endOffsetPivot,
      {Duration? duration,
      TransitionFunction? transitionFunction,
      EasingFunction? easingFunction,
      Positionable? anchorOffsetPivot}) {
    _startOffsetPivot = startOffsetPivot;
    _endOffsetPivot = endOffsetPivot;
    _anchorOffsetPivot = anchorOffsetPivot ?? _anchorOffsetPivot;
    this.duration = duration ?? this.duration;
    _transitionFunction = transitionFunction ?? _transitionFunction;
    _easingFunction = easingFunction ?? _easingFunction;
  }

  Positionable get currentPosition {
    assert(_startOffsetPivot != Positionable.zero() || _endOffsetPivot != Positionable.zero(),
        "Animation has not been configured");
    _pivot = _transitionFunction(_easingFunction(timeFraction), _startOffsetPivot, _endOffsetPivot,
        anchorPivot: _anchorOffsetPivot);
    return _pivot;
  }

  Positionable _pivot = Positionable.zero();
  @override
  double get timeFraction => DateTime.now().difference(startTime).inMilliseconds / duration.inMilliseconds;
}

interface class PlayerLifecycle extends GameObjectLifecycle {}

final class LiveLifecycle extends GameObjectLifecycle {}

sealed class PlayerFlyOutsideLevel extends PlayerLifecycle with TransitionLifeCycle {
  PlayerFlyOutsideLevel() {
    _setDuration = const Duration(seconds: 3);
  }
  late final double startAngle;
  late final double targetAngle;
  // double angleZ = 0;
  double lastAngle = 0;
  // late final Positionable prevPivot = _anchorOffsetPivot - _startOffsetPivot;
  // double get _getCurrentAngle => atan2((_pivot - prevPivot).x, (_pivot - prevPivot).y) + pi;

  double get getAngle {
    // TODO: rework
    // final delta = _getCurrentAngle - lastAngle;
    // final desired = max(1 - 2 * timeFraction, 0) * startAngle +
    //     (timeFraction <= 0.5 ? 2 * timeFraction : 1 - 2 * timeFraction) * _getCurrentAngle +
    //     max(2 * timeFraction - 1, 0) * (targetAngle - pi / 4);

    // lastAngle = (1 - timeFraction) * (startAngle) +
    //     (timeFraction * (targetAngle) +
    //         (lastAngle + min((1 - timeFraction), timeFraction) * (delta >= pi ? -(2 * pi - delta) : delta)) * 0.05);
    // lastAngle = lastAngle + ((1 - timeFraction) * delta * .05) + timeFraction * (targetAngle - lastAngle);
    // final delta = (desired % (2 * pi) - lastAngle % (2 * pi));
    // print(delta);
    // lastAngle += (delta > pi ? 2 * pi - delta : delta) * 0.05;
    return timeFraction <= 0.5
        ? lerpDouble(startAngle, 0, EasingFunctions.easeInOutCubic(timeFraction) * 2)!
        : lerpDouble(0, targetAngle, EasingFunctions.easeInOutCubic(timeFraction) * 2 - 1)!;
    // prevPivot.setFrom(_pivot);
  }
}

final class PlayerLive extends PlayerLifecycle {}

final class PlayerFlyThroughLevel extends PlayerLifecycle with TimefulLifecycle {
  PlayerFlyThroughLevel() {
    _setDuration = const Duration(seconds: 3);
  }
}

final class PlayerFlyToLevel extends PlayerFlyOutsideLevel {
  PlayerFlyToLevel(Level level) {
    final double x = Random().nextBool() ? -1000 : 1000;
    final double y = Random().nextInt(2000) - 1000;
    const double z = -4500;
    startAngle = x.sign > 0 ? pi / 2 : -pi / 2;
    targetAngle = level.tiles[level.activeTile].angle;
    configureTransition(
      Positionable(x, y, z),
      Positionable.zero(),
      easingFunction: EasingFunctions.easeOutCubic,
      anchorOffsetPivot: Positionable(0, 0, z / 2),
    );
  }
}

final class PlayerFlyFromLevel extends PlayerFlyOutsideLevel {
  PlayerFlyFromLevel(double angle) {
    final double x = Random().nextBool() ? -100 : 100;
    final double y = Random().nextInt(100) - 100;
    const double z = 200;
    startAngle = angle;
    targetAngle = x.sign > 0 ? -pi / 2 : pi / 2;
    configureTransition(Positionable.zero(), Positionable(x, y, z),
        easingFunction: EasingFunctions.easeInCubic, anchorOffsetPivot: Positionable(0, 0, z)
        // anchorOffsetPivot: Positionable(_startOffsetPivot.x, _startOffsetPivot.y, _endOffsetPivot.z),
        );
  }
}

sealed class CameraLifeCycle extends GameObjectLifecycle {}

final class CameraStationary extends CameraLifeCycle {}

final class CameraMoving extends CameraLifeCycle with TransitionLifeCycle {}
