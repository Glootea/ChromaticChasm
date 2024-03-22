part of game_state;

class PlayingState extends GameState {
  final Level level;
  final Player player;
  final List<Enemy> enemies;
  final List<Shot> shots;
  final List<Star> stars;
  int _enemiesToSpawnCount = 5;

  PlayingState(super.gameStateProvider, super.camera, this.level, this.player, this.enemies, this.shots, this.stars,
      {super.direction});
  PlayingState.create(super.gameStateProvider, super.camera, this.level, this.player, this.stars, {super.direction})
      : enemies = [],
        shots = [];
  @override
  void init() {
    player.lifecycleState = PlayerLive();
    camera.lifecycleState = ObjectStationary();
  }

  @override
  void onFireButtonPressed() => shots.add(Shot(level, level.activeTile));

  @override
  void draw(Canvas canvas) {
    handleNextState(_enemiesToSpawnCount <= 0 && enemies.isEmpty,
        LevelDisappearState(gameStateProvider, camera, level, player, direction: _direction));
    _spawnEnemy();
    final frameTimestamp = DateTime.now();
    handleKeyboardMovement();
    for (var star in stars) {
      star.onFrame(canvas, camera, frameTimestamp);
    }
    level.onFrame(canvas, camera, frameTimestamp);
    enemyOnNewFrame(canvas, frameTimestamp);
    shotOnNewFrame(canvas, frameTimestamp);
    player.onFrame(canvas, camera, frameTimestamp);
  }

  @override
  void handleKeyboardMovement() {
    if (_direction != null) _playerMovementThrottler.throttle(() => player.moveTargetTile(_direction!));
  }

  ///All operation on shot, that need to be done during every frame
  ///
  ///Contains: disposeCheck, show
  void shotOnNewFrame(Canvas canvas, DateTime frameTimestamp) {
    for (int i = 0; i < shots.length; i++) {
      final shot = shots[i];
      if (shot.disappear) {
        shots.removeAt(i);
        continue;
      }
      shot.onFrame(canvas, camera, frameTimestamp);
    }
  }

  ///All operation on enemy, that need to be done during every frame
  ///
  ///Contains: [shotHitCheck], [disposeCheck], [show]
  void enemyOnNewFrame(Canvas canvas, DateTime frameTimestamp) {
    for (int enemyNum = 0; enemyNum < enemies.length; enemyNum++) {
      final enemy = enemies[enemyNum];
      final shotHitNum = enemy.shotHitNumber(shots);
      if (shotHitNum != null) {
        enemies.removeAt(enemyNum);
        shots.removeAt(shotHitNum);
        continue;
      }
      if (enemy.disappear) {
        enemies.removeAt(enemyNum);
        continue;
      }
      enemy.onFrame(canvas, camera, frameTimestamp);
    }
  }

  @override
  void onAngleChanged(double angle) {
    player.setTargetTile = _calculateActiveTile(angle);
  }

  int _calculateActiveTile(double angle) {
    final tiles = level.tiles;
    for (final (i, tile) in tiles.indexed) {
      if ((angle <= tile.angleRange.last && angle >= tile.angleRange.first) ||
          (angle <= tile.angleRange.first && angle >= tile.angleRange.last)) {
        return i;
      }
    }
    if (angle < tiles.first.angleRange.first) return 0;
    if (angle >= tiles.last.angleRange.last) return tiles.length - 1;
    dev.log(angle.toString());
    dev.log("Tile no found");
    throw Exception("Tile no found");
  }

  final Random _random = Random();

  @override
  KeyEventResult onKeyboardEvent(KeyEvent event) {
    if (event is KeyRepeatEvent) return KeyEventResult.ignored;
    if (event is KeyDownEvent) {
      switch (event.logicalKey.keyLabel) {
        case "A":
          _direction = -1;
          break;
        case "D":
          _direction = 1;
          break;
      }
    }
    if (event is KeyUpEvent) _direction = null;
    return KeyEventResult.handled;
  }

  void _spawnEnemy() {
    if (_enemiesToSpawnCount > 0 && _random.nextInt(90) == 0) {
      enemies.add(Spider(level, _random.nextInt(level.tiles.length)));
      _enemiesToSpawnCount--;
    }
  }
}
