import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chromatic_chasm/game_elements/base_classes/drawable.dart';
import 'package:chromatic_chasm/game_elements/level/level.dart';
import 'package:chromatic_chasm/game_state_provider.dart';
import 'package:chromatic_chasm/widgets/game_painter.dart';
import 'package:chromatic_chasm/widgets/game_painter_clipper.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
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

class _MyAppState extends State<MyApp> {
  final level = Level1();
  double get size => min(MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height - 270);
  Size get gamePainterSize => Size(size, size);

  @override
  Widget build(BuildContext context) {
    Drawable.setCanvasSize(gamePainterSize);
    final gameState = context.read<GameStateProvider>().currentState;
    return SafeArea(
        child: Focus(
      autofocus: true,
      onKeyEvent: (node, event) => gameState.onKeyboardEvent(event),
      child: Scaffold(
          body: Stack(children: [
        // SizedBox(
        //   width: MediaQuery.of(context).size.width,
        //   height: MediaQuery.of(context).size.height,
        //   child: Image.asset(
        //     "assets/background.jpeg",
        //     repeat: ImageRepeat.repeat,
        //   ),
        // ),
        Column(children: [
          Stack(children: [
            Align(
              child: ClipRect(
                  clipper: GamePainterClipper(gamePainterSize),
                  child: CustomPaint(
                    size: gamePainterSize,
                    painter: GamePainter(gameState,
                        repaint: context.watch<GameStateProvider>()),
                  )),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: gamePainterSize.width,
                  child: const RunDataRow(),
                ))
          ]),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Expanded(
            child: Stack(children: [
              const RiveAnimation.asset(
                'assets/arcade_controls.riv',
                stateMachines: ['State Machine 1'],
              ),
              Center(
                  child: Padding(
                      padding: EdgeInsets.only(right: 150, bottom: 30),
                      child: SizedBox(
                          width: 120,
                          height: 120,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              if ((details.localPosition.dx).abs() <= 0.3 &&
                                  (details.localPosition.dy).abs() <= 0.3) {
                                return;
                              }
                              final angle = (atan2(
                                  details.localPosition.dx - 60,
                                  details.localPosition.dy - 60));
                              gameState.onAngleChanged(angle);
                            },
                          )))),
              Center(
                  child: Padding(
                      padding: EdgeInsets.only(left: 170, top: 55),
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: GestureDetector(
                              onTap: gameState.onFireButtonPressed))))
            ]),
          ),
        ]),
      ])),
    ));
  }
}

class RunDataRow extends StatelessWidget {
  const RunDataRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameStateProvider>().currentState.runState;
    if (state.lives == 0) {
      return Center(
          child: Text(
              "Ваш счет: ${state.score} \nНажмите 'Огонь' для перезапуска"));
    }
    return Row(
      children: <Widget>[
            Text(state.score.toString()),
            const Spacer(),
          ] +
          List.filled(
            state.lives,
            const Icon(Icons.favorite_outline),
          ),
    );
  }
}
