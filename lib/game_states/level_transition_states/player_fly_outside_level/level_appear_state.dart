part of game_state;

class LevelAppearState extends PlayerFlyOutsideLevel {
  final _startCameraPivot = Positionable(0, 0, -5000);
  late final Positionable targetCameraPivot = Positionable.all(0);
  late final _stars = List.generate(5, (index) => Star.createStationary(_level));
  LevelAppearState(super.gameStateProvider, super.camera, super._level, super._player);
  LevelAppearState.newCycle(GameStateProvider gameStateProvider, Level level)
      : this(gameStateProvider, null, level, Player(level));

  @override
  void init() {
    _player.lifecycleState = PlayerFlyToLevel(_level);
    camera.lifecycleState =
        ObjectMoving(_startCameraPivot, targetCameraPivot, easingFunctions: EasingFunctions.easeOutCubic);
  }

  @override
  void draw(Canvas canvas) {
    final frameTimestamp = DateTime.now();
    double timeFraction = _getTimeFraction(frameTimestamp, _startTime);
    handleNextState(timeFraction >= 1,
        PlayingState.create(gameStateProvider, camera, _level, Player(_level), _stars, direction: _direction));
    camera.onFrame(canvas, camera, frameTimestamp);
    for (var star in _stars) {
      star.onFrame(canvas, camera, frameTimestamp);
    }
    _level.onFrame(canvas, camera, frameTimestamp);
    _player.onFrame(canvas, camera, frameTimestamp);
  }
}
