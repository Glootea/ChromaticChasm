import 'dart:math';
import 'package:chromatic_chasm/game/elements/base_classes/game_object.dart';
import 'package:chromatic_chasm/game/elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game/elements/camera.dart';
import 'package:chromatic_chasm/game/elements/level/tile/level_tile.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

part 'package:chromatic_chasm/game/elements/level/level_entities.dart';

class Level extends ComplexGlobalGameObject {
  final List<LevelTile> tiles;

  ///Whether player can move from last tile to first or vice versa
  final bool circlular;

  final double depth;

  /// Should be in non clock wise order, starting from 12 o'clock. First [tile.x] must be < 0
  Level._(this.id, Positionable pivot, this.tiles, this.depth, this.circlular)
    : super(pivot, tiles);

  /// Tile where player is. It has different color
  late int activeTile = tiles.length ~/ 2;

  final int id;

  /// [points] must be in range -100 to 100 in both x and y. [depth] prefered to be around 200
  ///
  /// Do not set [x] coordinate to 0 to prevent angle calculation issues. Use +-0.01 instead
  Level.fromPoints({
    required int id,
    required List<Positionable> points,
    required double depth,
    required bool circlular,
    Positionable? pivot,
  }) : this._(
         id,
         pivot ?? Positionable(0, 0, 50),
         _pointsToTiles(points, depth, circlular, pivot),
         depth,
         circlular,
       );

  /// Used to insert just created level into database
  /// [id] must be unique, for example levels.length
  static Level create(int id) => Level.fromPoints(
    id: id,
    points: [
      Positionable(50, 30, 0),
      Positionable(20, 60, 0),
      Positionable(80, 60, 0),
    ],
    depth: (maxDepth + minDepth) / 2,
    circlular: true,
  );

  String pointsToString() {
    final points =
        tiles
            .map((tile) => tile.leftNearPointGlobal)
            .map((point) => '${point.x};${point.y};${point.z}')
            .toList();
    return points.map((e) => e.toString()).join(';');
  }

  static List<Positionable> stringToPoints(String points) {
    final numbers = points.split(';').map((e) => double.parse(e)).toList();

    final output = List.generate(
      numbers.length ~/ 3,
      (i) =>
          Positionable(numbers[i * 3], numbers[i * 3 + 1], numbers[i * 3 + 2]),
      growable: false,
    );
    return output;
  }

  @override
  void onFrame(Canvas canvas, Camera camera, DateTime frameTimestamp) {
    lastFrameTimestamp = frameTimestamp;
    for (final (i, tile) in tiles.indexed) {
      if (i != activeTile) {
        tile.onFrame(canvas, camera, frameTimestamp);
      }
      tiles[activeTile].onFrameActive(canvas, camera);
    }
  }

  ///Creates tiles iteratively by connecting [i] and [i+1] points. If circlular first and last points are connected
  static List<LevelTile> _pointsToTiles(
    List<Positionable> points,
    double depth,
    bool circlular, [
    Positionable? pivot,
  ]) {
    pivot ??= Positionable(0, 0, 50);
    final output = <LevelTile>[];
    for (int i = 0; i < points.length - 1; i++) {
      output.add(LevelTile.from(pivot, points[i], points[i + 1], depth));
    }
    if (circlular) {
      output.add(LevelTile.from(pivot, points.last, points.first, depth));
    }
    return output;
  }

  static Level createLevel(int number) {
    switch (number) {
      case 0:
        return Level1();
      case 1:
        return Level2();
      default:
        return Level2();
    }
  }

  static Level getRandomLevel() => createLevel(Random().nextInt(2));

  Vector2 get levelAmplitude => _levelAmplitude ?? _setAndReturnLevelAmplitude;
  Vector2? _levelAmplitude;
  Vector2 get _setAndReturnLevelAmplitude {
    double maxX = 0, maxY = 0;
    for (final tile in tiles) {
      for (final point in [
        tile.leftNearPointGlobal,
        tile.rightNearPointGlobal,
      ]) {
        if (point.x > maxX) maxX = point.x;
        if (point.y > maxY) maxY = point.y;
      }
    }
    _levelAmplitude = Vector2(maxX, maxY);
    return _levelAmplitude!;
  }

  static double minDepth = 100;
  static double maxDepth = 300;
  static double defaultDepth = (minDepth + maxDepth) / 2;
}
