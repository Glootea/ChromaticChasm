import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/positioned.dart';
import 'package:tempest/game_elements/level/tile/tile_main_line.dart';

class LevelTile with Drawable {
  Positionable pivot;
  List<Positionable> points;

  ///The line where most enemies are move/exist
  TileMainLine get mainLine => _mainLine ?? _getMainLine();
  TileMainLine? _mainLine;

  TileMainLine _getMainLine() {
    _mainLine = TileMainLine(
      PositionFunctions.median(pivot + points[0], pivot + points[3]),
      PositionFunctions.median(pivot + points[1], points[2]),
    );
    return _mainLine!;
  }

  LevelTile(this.pivot, this.points) {
    assert(points.length == 4);
  }
  LevelTile.from(Positionable pivot, Positionable left, Positionable rigth, double depth)
      : this(pivot, [left, left + Positionable(0, 0, depth), rigth + Positionable(0, 0, depth), rigth]);

  final defaultPaint = Paint()
    ..color = Colors.blue
    ..strokeWidth = Drawable.strokeWidth;

  final activePaint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = Drawable.strokeWidth;

  List<Positionable> get preparePoints => points.map((point) => point + pivot).toList();
  @override
  void show(Canvas canvas) {
    drawLooped(canvas, preparePoints, defaultPaint);
  }

  void showActive(Canvas canvas) {
    drawLooped(canvas, preparePoints, activePaint);
  }
}
