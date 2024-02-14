import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:provider/provider.dart';
import 'package:tempest/game_state_provider.dart';
import 'package:tempest/widgets/game_painter.dart';
import 'package:tempest/widgets/game_painter_clipper.dart';

void main() {
  runApp(MaterialApp(
      home: Provider(
    create: (context) => GameStateProvider(),
    child: const MyApp(),
  )));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with ChangeNotifier {
  Size get gamePainterSize => Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.width,
      );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          ClipRect(
            clipper: GamePainterClipper(gamePainterSize),
            child: CustomPaint(
              size: gamePainterSize,
              painter: GamePainter(repaint: this),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Joystick(listener: (details) {}),
            Column(children: [
              OutlinedButton(
                onPressed: () {},
                child: const Icon(Icons.local_fire_department_outlined),
              ),
              Switch(value: false, onChanged: ((value) {})),
              const Text("Auto fire")
            ])
          ]),
        ],
      )),
    );
  }
}
