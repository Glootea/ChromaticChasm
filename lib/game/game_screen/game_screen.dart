import 'dart:math';
import 'package:chromatic_chasm/game/elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game/game_screen/control_panel.dart';
import 'package:chromatic_chasm/game/game_screen/game_display.dart';
import 'package:chromatic_chasm/game/game_state_provider.dart';
import 'package:chromatic_chasm/game/level_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  final LevelProvider levelProvider;
  const GameScreen({super.key, required this.levelProvider});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double get size => min(
    MediaQuery.of(context).size.width,
    MediaQuery.of(context).size.height - 270 - AppBar().preferredSize.height,
  );
  Size get gamePainterSize => Size(size, size);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) =>
              GameStateProvider.create(levelProvider: widget.levelProvider),
      child: SafeArea(
        child: Builder(
          builder: (context) {
            Drawable.setCanvasSize(gamePainterSize);
            final gameState = context.watch<GameStateProvider>().currentState;
            return Focus(
              autofocus: true,
              onKeyEvent: (node, event) => gameState.onKeyboardEvent(event),
              child: Scaffold(
                appBar: AppBar(),
                body: Stack(
                  children: [
                    Column(
                      children: [
                        GameDisplayWithInfo(
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
