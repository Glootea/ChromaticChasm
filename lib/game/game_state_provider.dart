import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:chromatic_chasm/game/level_provider.dart';
import 'package:chromatic_chasm/game/states/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class GameStateProvider extends ChangeNotifier {
  late GameState currentState;
  late final Ticker _ticker;
  late final LevelProvider? _levelProvider;
  late final Level? _forcedLevel;

  GameStateProvider.create({
    Level? forcedLevel,
    GameState Function(GameStateProvider gameStateProvider, Level level)?
    forcedState,
    LevelProvider? levelProvider,
  }) {
    assert(
      levelProvider != null || forcedLevel != null,
      "Level provider or forced level must be set",
    );
    _levelProvider = levelProvider;
    _forcedLevel = forcedLevel;

    final level = forcedLevel ?? getNextLevel();
    final state =
        forcedState?.call(this, level) ?? LevelAppearState.newCycle(this);
    state.init();
    currentState = state;
    _ticker = Ticker((_) {
      // schedule new frame after each frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_ticker.isActive) return;
        notifyListeners();
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.stop();
    _ticker.dispose();
    super.dispose();
  }

  Level getNextLevel() => _forcedLevel ?? _levelProvider!.getRandomLevel();
}
