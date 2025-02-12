import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:chromatic_chasm/game_elements/level/level.dart';

import 'game_states/game_state.dart';

class GameStateProvider extends ChangeNotifier {
  late GameState currentState;
  late final Ticker _ticker;

  GameStateProvider.create() {
    final level = Level.getRandomLevel();
    final state = LevelAppearState.newCycle(this, level);
    state.init();
    currentState = state;
    _ticker = Ticker((_) {
      // schedule new frame after each frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
