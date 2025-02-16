part of 'package:chromatic_chasm/game/states/game_state.dart';

class LevelPreviewPlayingState extends PlayingState {
  LevelPreviewPlayingState(Level level)
    : super(
        GameStateProvider.create(forcedLevel: level),
        Camera(Positionable(0, 0, 0)),
        RunState(),
        level,
        Player(level),
        [],
        [],
        List.generate(5, (index) => Star.createStationary(level)),
      );

  /// Same as [PlayingState]'s, but prevents state switching
  @override
  void draw(Canvas canvas) {
    _spawnEnemy();
    final frameTimestamp = DateTime.now();
    handleKeyboardMovement();
    level.onFrame(canvas, camera, frameTimestamp);
    starsOnNewFrame(canvas, frameTimestamp);
    enemiesOnNewFrame(canvas, frameTimestamp);
    shotsOnNewFrame(canvas, frameTimestamp);
    player.onFrame(canvas, camera, frameTimestamp);
  }

  /// Same as [PlayingState]'s, but infinite enemies

  @override
  void _spawnEnemy() {
    // TODO: break connection between frame count and enemy spawn, here and in [PlayingState]
    if (_random.nextInt(90) == 0) {
      enemies.add(Spider(level, _random.nextInt(level.tiles.length)));
    }
  }

  /// Same as [PlayingState]'s, but creates level preview state after death and does not update [runState]
  @override
  void enemiesOnNewFrame(Canvas canvas, DateTime frameTimestamp) {
    for (int enemyNum = 0; enemyNum < enemies.length; enemyNum++) {
      final enemy = enemies[enemyNum];
      final shotHitNum = enemy.shotHitNumber(shots);
      if (shotHitNum != null) {
        enemies.removeAt(enemyNum);
        shots.removeAt(shotHitNum);
        continue;
      }
      if (enemy.checkPlayerTookHit(player)) {
        enemies.removeAt(enemyNum);
        gameStateProvider.currentState = LevelPreviewPlayingState(level)
          ..init();
      }
      if (enemy.disappear) {
        enemies.removeAt(enemyNum);
        continue;
      }
      enemy.onFrame(canvas, camera, frameTimestamp);
    }
  }
}
