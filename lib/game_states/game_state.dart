library game_state;

import 'dart:developer' as dev;
import 'dart:math';
import 'package:chromatic_chasm/game_elements/star.dart';
import 'package:chromatic_chasm/game_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chromatic_chasm/game_elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game_elements/base_classes/game_object_lifecycle.dart';
import 'package:chromatic_chasm/game_elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game_elements/camera.dart';
import 'package:chromatic_chasm/game_elements/enemies/enemy.dart';
import 'package:chromatic_chasm/game_elements/level/level.dart';
import 'package:chromatic_chasm/game_elements/player/player.dart';
import 'package:chromatic_chasm/game_elements/shot.dart';
import 'package:chromatic_chasm/helpers/easing.dart';
import 'package:chromatic_chasm/helpers/throttler.dart';
import 'package:chromatic_chasm/helpers/tile_helper.dart';

import '../model_loader.dart';
part 'level_transition_states/player_fly_outside_level/player_fly_outside_level_abst.dart';
part 'level_transition_states/level_transition_state_abst.dart';
part 'level_transition_states/player_fly_outside_level/level_appear_state.dart';
part 'level_transition_states/player_fly_outside_level/level_disappear_state.dart';
part 'playing_state/playing_state.dart';
part 'level_transition_states/player_fly_outside_level/player_fly_away_state.dart';

sealed class GameState {
  void init();
  KeyEventResult onKeyboardEvent(KeyEvent event);
  void onFireButtonPressed();
  void onAngleChanged(double angle);
  void draw(Canvas canvas);
  void handleKeyboardMovement();

  ///Applies state if check is true
  void handleNextState(bool check, GameState nextState) {
    if (check) {
      gameStateProvider.currentState = (nextState..init());
    }
  }

  final GameStateProvider gameStateProvider;
  int? _direction;
  Camera camera;

  GameState(this.gameStateProvider, Camera? camera, {int? direction})
      : _direction = direction,
        camera = camera ?? Camera(Positionable(0, 0, 0));

  ///Prevents player from moving too fast/instantly
  final _playerMovementThrottler = Throttler(Duration(milliseconds: (Drawable.syncTime * 1.5).toInt()));

  double _getTimeFraction(DateTime now, DateTime last) =>
      (now.difference(last).inMilliseconds / LevelTransitionState.animationDuration.inMilliseconds);
}
