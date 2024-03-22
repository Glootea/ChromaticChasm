part of game_state;

class PlayerFlyAwayState extends PlayerFlyOutsideLevel {
  PlayerFlyAwayState(super.gameStateProvider, super.camera, super._level, super.player);
  @override
  void init() {
    _startCameraPivot = camera.pivot.clone();
    _player.lifecycleState = PlayerFlyFromLevel(LevelTileHelper.getAngle(_player.pivot));
    camera.lifecycleState = ObjectMoving(_startCameraPivot, _startCameraPivot);
  }

  late final Positionable _startCameraPivot;
  @override
  void draw(Canvas canvas) {
    final frameTimestamp = DateTime.now();
    double timeFraction = _getTimeFraction(frameTimestamp, _startTime);
    handleNextState(timeFraction >= 1, LevelAppearState.newCycle(gameStateProvider, Level.getRandomLevel()));
    _player.onFrame(canvas, camera, frameTimestamp);
  }

  @override
  void handleKeyboardMovement() {}

  @override
  void onAngleChanged(double angle) {}

  @override
  void onFireButtonPressed() {}

  @override
  KeyEventResult onKeyboardEvent(KeyEvent event) {
    return KeyEventResult.handled;
  }
}
