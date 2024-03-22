part of game_state;

abstract class LevelTransitionState extends GameState {
  final Level _level;
  final Player _player;

  LevelTransitionState(super.gameStateProvider, super.camera, this._level, this._player, {super.direction});

  static const Duration animationDuration = Duration(seconds: 3);
  final DateTime _startTime = DateTime.now();

  late final Positionable startPivot;

  late final Positionable targetPivot;

  @override
  void onAngleChanged(double angle) {
    _player.setTargetTile = _calculateActiveTile(angle);
  }

  int _calculateActiveTile(double angle) {
    final tiles = _level.tiles;
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

  @override
  void onFireButtonPressed() {}

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
}
