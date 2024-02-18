import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:provider/provider.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/level/level.dart';
import 'package:tempest/game_elements/level/tile/level_tile.dart';
import 'package:tempest/game_elements/player/player.dart';
import 'package:tempest/game_state_provider.dart';
import 'package:tempest/widgets/game_painter.dart';
import 'package:tempest/widgets/game_painter_clipper.dart';
import 'dart:developer' as dev;

void main() {
  runApp(MaterialApp(
      theme: ThemeData.dark(),
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
  final level = Level1();
  late final player = Player(level);
  double get size => min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height - 270);
  Size get gamePainterSize => Size(size, size);
  @override
  void initState() {
    player.addListener(() {
      notifyListeners();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Drawable.setCanvasSize(gamePainterSize);
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          ClipRect(
            clipper: GamePainterClipper(gamePainterSize),
            child: CustomPaint(
              size: gamePainterSize,
              painter: GamePainter(level, player, repaint: this),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Joystick(
                period: const Duration(milliseconds: 16),
                listener: (details) {
                  int calculateActiveTile(double angle, List<LevelTile> tiles) {
                    for (final tile in tiles) {
                      if ((angle <= tile.angleRange.last && angle >= tile.angleRange.first) ||
                          (angle <= tile.angleRange.first && angle >= tile.angleRange.last)) {
                        return tiles.indexOf(tile);
                      }
                    }
                    if (angle < tiles.first.angleRange.first) return 0;
                    if (angle >= tiles.last.angleRange.last) return tiles.length - 1;
                    dev.log(angle.toString());
                    dev.log("Tile no found");
                    throw Exception("Tile no found");
                  }

                  // ignore small movements in the middle / dead zone
                  if ((details.x).abs() <= 0.3 && (details.y).abs() <= 0.3) return;
                  final angle = (atan2(details.x, details.y));
                  player.setTargetTile = calculateActiveTile(angle, level.tiles);
                }),
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
