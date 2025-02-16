import 'dart:math';
import 'package:chromatic_chasm/game/elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:chromatic_chasm/game/game_screen/control_panel.dart';
import 'package:chromatic_chasm/game/game_screen/game_display.dart';
import 'package:chromatic_chasm/game/game_state_provider.dart';
import 'package:chromatic_chasm/game/level_provider.dart';
import 'package:chromatic_chasm/game/states/game_state.dart';
import 'package:chromatic_chasm/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewLevelScreen extends StatefulWidget {
  final Level level;
  const PreviewLevelScreen({required this.level, super.key});

  @override
  State<PreviewLevelScreen> createState() => _PreviewLevelScreenState();
}

class _PreviewLevelScreenState extends State<PreviewLevelScreen> {
  double get size => min(
    MediaQuery.of(context).size.width,
    MediaQuery.of(context).size.height - 270 - AppBar().preferredSize.height,
  );
  Size get gamePainterSize => Size(size, size);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) => GameStateProvider.create(
            forcedLevel: widget.level,
            forcedState: (_, level) => LevelPreviewPlayingState(level),
            levelProvider: LevelProvider(levels: [widget.level]),
          ),
      child: SafeArea(
        child: Builder(
          builder: (context) {
            Drawable.setCanvasSize(gamePainterSize);
            final gameState = context.watch<GameStateProvider>().currentState;
            return Focus(
              autofocus: true,
              onKeyEvent: (node, event) => gameState.onKeyboardEvent(event),
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(context.localization.createdLevelPreview),
                ),
                body: Stack(
                  children: [
                    Column(
                      children: [
                        PreviewGameDisplay(
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
