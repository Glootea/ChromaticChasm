import 'package:chromatic_chasm/database/database.dart';
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
  bool isLoading = true;
  @override
  void initState() {
    loadLevels();
    super.initState();
  }

  Future<void> loadLevels() async {
    final database = context.read<ChromaticChasmDatabase>();
    await widget.levelProvider.init(database);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    final size = MediaQuery.sizeOf(context);
    final isWideLayout = size.height - kToolbarHeight - 150 < size.width;

    double gameScreenSize = isWideLayout ? size.width * 0.5 : size.width;
    Size gamePainterSize = Size(gameScreenSize, gameScreenSize);

    return SafeArea(
      child: Builder(
        builder: (context) {
          Drawable.setCanvasSize(gamePainterSize);
          final gameState = context.watch<GameStateProvider>().currentState;

          final children = [
            GameDisplayWithInfo(
              gamePainterSize: gamePainterSize,
              gameState: gameState,
            ),
            ControlPanel(gameState: gameState),
          ];

          return Focus(
            autofocus: true,
            onKeyEvent: (node, event) => gameState.onKeyboardEvent(event),
            child: Scaffold(
              appBar: AppBar(
                leading: BackButton(onPressed: () => Navigator.pop(context)),
              ),
              body:
                  isWideLayout
                      ? Row(children: children)
                      : Column(children: children),
            ),
          );
        },
      ),
    );
  }
}
