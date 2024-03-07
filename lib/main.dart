import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:provider/provider.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/level/level.dart';
import 'package:tempest/game_state_provider.dart';
import 'package:tempest/widgets/game_painter.dart';
import 'package:tempest/widgets/game_painter_clipper.dart';

//TODO: player flies forward like rocker on level disappear (second half)
void main() {
  runApp(MaterialApp(
      theme: ThemeData.dark(),
      home: ChangeNotifierProvider(
        create: (context) => GameStateProvider.create(),
        child: const MyApp(),
      )));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with ChangeNotifier {
  final level = Level1();
  double get size => min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height - 270);
  Size get gamePainterSize => Size(size, size);

  @override
  Widget build(BuildContext context) {
    Drawable.setCanvasSize(gamePainterSize);
    // DrawableOld.setCanvasSize(gamePainterSize);
    final gameState = context.read<GameStateProvider>().currentState;
    return SafeArea(
      child: Focus(
        autofocus: true,
        onKeyEvent: (node, event) => gameState.onKeyboardEvent(event),
        child: Scaffold(
            body: Column(
          children: [
            ClipRect(
              clipper: GamePainterClipper(gamePainterSize),
              child: CustomPaint(
                size: gamePainterSize,
                painter: GamePainter(gameState, repaint: context.watch<GameStateProvider>()),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Joystick(
                  period: const Duration(milliseconds: 16),
                  listener: (details) {
                    // ignore small movements in the middle / dead zone
                    if ((details.x).abs() <= 0.3 && (details.y).abs() <= 0.3) return;
                    final angle = (atan2(details.x, details.y));
                    gameState.onAngleChanged(angle);
                  }),
              Column(children: [
                OutlinedButton(
                  onPressed: gameState.onFireButtonPressed,
                  child: const Icon(Icons.local_fire_department_outlined),
                ),
                Switch(value: false, onChanged: ((value) {})),
                const Text("Auto fire")
              ])
            ]),
          ],
        )),
      ),
    );
  }
}
