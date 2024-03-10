import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:tempest/game_elements/level/level.dart';
import 'package:tempest/game_state.dart';

class GameStateProvider extends ChangeNotifier {
  GameState get currentState => _currentState;
  late GameState _currentState;
  late final Ticker ticker;
  final StreamController<GameState> _setStateStreamController = StreamController<GameState>();
  late StreamSubscription _sub;

  GameStateProvider.create() {
    final level = Level.getRandomLevel();
    _currentState = LevelAppearState.newCycle(_setStateStreamController, level);
    _sub = _setStateStreamController.stream.listen((event) {
      _currentState = event;
    });
    ticker = Ticker((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    });
    ticker.start();
  }
  set nextState(GameState state) {
    _currentState = state;
  }

  @override
  void dispose() {
    _sub.cancel();
    _setStateStreamController.close();
    ticker.dispose();
    super.dispose();
  }
}
