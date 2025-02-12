part of 'package:chromatic_chasm/game/states/game_state.dart';

class LevelDisappearState extends LevelTransitionState {
  LevelDisappearState(
    super.gameStateProvider,
    super.camera,
    super.runState,
    super.level,
    super.player, {
    super.direction,
  });
  @override
  void init() {
    _player.lifecycleState = PlayerFlyThroughLevel();
    camera.lifecycleState = ObjectMoving(startPivot, targetPivot);
  }

  @override
  Positionable get targetPivot => Positionable(0, 0, _level.depth * 1.05);
  @override
  Positionable get startPivot => Positionable.all(0);

  @override
  void draw(Canvas canvas) {
    final frameTimestamp = DateTime.now();
    double timeFraction = _getTimeFraction(frameTimestamp, _startTime);
    handleNextState(
      timeFraction >= 1,
      PlayerFlyAwayState(
        gameStateProvider,
        camera,
        runState,
        _level,
        _player,
      ),
    );
    handleDepth(timeFraction);
    handleKeyboardMovement();
    _level.onFrame(canvas, camera, frameTimestamp);
    _player.onFrame(canvas, camera, frameTimestamp);
    camera.onFrame(canvas, camera, frameTimestamp);
  }

  void handleDepth(double timeFraction) {
    _player.pivot.updatePosition(depthFraction: timeFraction);
  }

  @override
  void handleKeyboardMovement() {
    if (_direction != null) {
      _playerMovementThrottler
          .throttle(() => _player.moveTargetTile(_direction!));
    }
  }
}
