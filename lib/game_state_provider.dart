import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tempest/game_state.dart';

class GameStateProvider extends ChangeNotifier {
  GameState currentState;
  late final Ticker ticker;

  GameStateProvider(this.currentState) {
    ticker = Ticker((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    });
    ticker.start();
  }
  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }
}
