library;

import 'dart:developer' as dev;
import 'dart:math';

import 'package:chromatic_chasm/game/elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game/elements/base_classes/game_object_lifecycle.dart';
import 'package:chromatic_chasm/game/elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game/elements/camera.dart';
import 'package:chromatic_chasm/game/elements/enemies/enemy.dart';
import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:chromatic_chasm/game/elements/player/player.dart';
import 'package:chromatic_chasm/game/elements/shot.dart';
import 'package:chromatic_chasm/game/elements/star.dart';
import 'package:chromatic_chasm/game/game_state_provider.dart';
import 'package:chromatic_chasm/game/helpers/easing.dart';
import 'package:chromatic_chasm/game/helpers/throttler.dart';
import 'package:chromatic_chasm/game/helpers/tile_helper.dart';
import 'package:chromatic_chasm/game/run_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'game_over.dart';
part 'level_transition_states/level_transition_state_abst.dart';
part 'level_transition_states/player_fly_outside_level/level_appear_state.dart';
part 'level_transition_states/player_fly_outside_level/level_disappear_state.dart';
part 'level_transition_states/player_fly_outside_level/player_fly_away_state.dart';
part 'level_transition_states/player_fly_outside_level/player_fly_outside_level_abst.dart';
part 'playing_state/playing_state.dart';
part 'level_preview/level_preview_playing_state.dart';

sealed class GameState {
  void init();
  KeyEventResult onKeyboardEvent(KeyEvent event);
  void onFireButtonPressed();
  void onAngleChanged(double angle);
  void draw(Canvas canvas);
  void handleKeyboardMovement();
  void playerDead() {}
  void playerHit(double scoreForKill) {}
  RunState runState;

  ///Applies state if check is true
  void handleNextState(bool check, GameState nextState) {
    if (check) {
      gameStateProvider.currentState = (nextState..init());
    }
  }

  final GameStateProvider gameStateProvider;
  int? _direction;
  Camera camera;

  GameState(
    this.gameStateProvider,
    Camera? camera,
    this.runState, {
    int? direction,
  }) : _direction = direction,
       camera = camera ?? Camera(Positionable(0, 0, 0));

  ///Prevents player from moving too fast/instantly
  final _playerMovementThrottler = Throttler(
    Duration(milliseconds: (Drawable.syncTime * 1.5).toInt()),
  );

  double _getTimeFraction(DateTime now, DateTime last) =>
      (now.difference(last).inMilliseconds /
          LevelTransitionState.animationDuration.inMilliseconds);
}
