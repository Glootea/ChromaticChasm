part of 'package:chromatic_chasm/game/states/game_state.dart';

abstract class PlayerFlyOutsideLevel extends LevelTransitionState {
  PlayerFlyOutsideLevel(
    super.gameStateProvider,
    super.camera,
    super.runState,
    super._level,
    super._player, {
    super.direction,
  });
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
