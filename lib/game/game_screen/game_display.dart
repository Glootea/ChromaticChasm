import 'package:chromatic_chasm/game/game_state_provider.dart';
import 'package:chromatic_chasm/game/states/game_state.dart';
import 'package:chromatic_chasm/game/widgets/game_painter.dart';
import 'package:chromatic_chasm/game/widgets/game_painter_clipper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Used in main gameplay
class GameDisplayWithInfo extends StatelessWidget {
  const GameDisplayWithInfo({
    super.key,
    required this.gamePainterSize,
    required this.gameState,
  });

  final Size gamePainterSize;
  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          child: ClipRect(
            clipper: GamePainterClipper(gamePainterSize),
            child: CustomPaint(
              size: gamePainterSize,
              painter: GamePainter(
                gameState,
                repaint: context.watch<GameStateProvider>(),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: gamePainterSize.width,
            child: const RunDataRow(),
          ),
        ),
      ],
    );
  }
}

class PreviewGameDisplay extends StatelessWidget {
  const PreviewGameDisplay({
    super.key,
    required this.gamePainterSize,
    required this.gameState,
  });

  final Size gamePainterSize;
  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipper: GamePainterClipper(gamePainterSize),
      child: CustomPaint(
        size: gamePainterSize,
        painter: GamePainter(
          gameState,
          repaint: context.watch<GameStateProvider>(),
        ),
      ),
    );
  }
}

class RunDataRow extends StatelessWidget {
  const RunDataRow({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameStateProvider>().currentState.runState;
    if (state.lives == 0) {
      return Center(
        child: Text(
          "Ваш счет: ${state.score} \nНажмите 'Огонь' для перезапуска",
        ),
      );
    }
    return Row(
      children:
          <Widget>[Text(state.score.toString()), const Spacer()] +
          List.filled(state.lives, const Icon(Icons.favorite_outline)),
    );
  }
}
