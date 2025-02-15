import 'dart:math';
import 'package:chromatic_chasm/game/elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:chromatic_chasm/game/game_state_provider.dart';
import 'package:chromatic_chasm/game/states/game_state.dart';
import 'package:chromatic_chasm/game/widgets/game_painter.dart';
import 'package:chromatic_chasm/game/widgets/game_painter_clipper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final level = Level1();
  double get size => min(
    MediaQuery.of(context).size.width,
    MediaQuery.of(context).size.height - 270,
  );
  Size get gamePainterSize => Size(size, size);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameStateProvider.create(),
      child: SafeArea(
        child: Builder(
          builder: (context) {
            Drawable.setCanvasSize(gamePainterSize);
            final gameState = context.watch<GameStateProvider>().currentState;
            return Focus(
              autofocus: true,
              onKeyEvent: (node, event) => gameState.onKeyboardEvent(event),
              child: Scaffold(
                body: Stack(
                  children: [
                    Column(
                      children: [
                        GameScreenWithInfo(
                          gamePainterSize: gamePainterSize,
                          gameState: gameState,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        ControlPanel(gameState: gameState),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key, required this.gameState});

  final GameState gameState;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          const RiveAnimation.asset(
            'assets/arcade_controls.riv',
            stateMachines: ['State Machine 1'],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 150, bottom: 30),
              child: SizedBox(
                width: 120,
                height: 120,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    if ((details.localPosition.dx).abs() <= 0.3 &&
                        (details.localPosition.dy).abs() <= 0.3) {
                      return;
                    }
                    final angle = (atan2(
                      details.localPosition.dx - 60,
                      details.localPosition.dy - 60,
                    ));
                    gameState.onAngleChanged(angle);
                  },
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 170, top: 55),
              child: SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(onTap: gameState.onFireButtonPressed),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GameScreenWithInfo extends StatelessWidget {
  const GameScreenWithInfo({
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
