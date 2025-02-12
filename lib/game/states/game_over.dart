part of 'package:chromatic_chasm/game/states/game_state.dart';

class GameOverState extends GameState {
  GameOverState(super.gameStateProvider, super.camera, super.runState);
  @override
  void draw(Canvas canvas) {
    final textSpan = TextSpan(
      text: "${runState.score}/nНажмите 'Огонь' для перезапуска",
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textScaler: const TextScaler.linear(5),
    );
    textPainter.layout(maxWidth: Drawable.canvasSize / 2);
    final xCenter = (Drawable.canvasSize - textPainter.width) / 2;
    final yCenter = (Drawable.canvasSize - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  @override
  void handleKeyboardMovement() {}

  @override
  void init() {}

  @override
  void onAngleChanged(double angle) {}

  @override
  void onFireButtonPressed() {
    gameStateProvider.currentState =
        LevelAppearState.newCycle(gameStateProvider, Level.getRandomLevel())
          ..init();
  }

  @override
  KeyEventResult onKeyboardEvent(KeyEvent event) {
    return KeyEventResult.handled;
  }
}
