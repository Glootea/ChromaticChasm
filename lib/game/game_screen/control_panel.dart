import 'dart:math';

import 'package:chromatic_chasm/game/states/game_state.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

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
                    final movement = details.localPosition;
                    if (notEnoughMovement(movement)) return;

                    final angle = getAngle(movement);
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

  bool notEnoughMovement(Offset movement) =>
      ((movement.dx).abs() <= 0.3 && (movement.dy).abs() <= 0.3);

  double getAngle(Offset movement) => atan2(movement.dx - 60, movement.dy - 60);
}
