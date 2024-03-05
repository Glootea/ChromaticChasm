part of 'package:tempest/game_elements/enemies/enemy.dart';

class Spider extends Enemy {
  Spider(super.level, super.tileNumber);

  LevelTile get tile => level.tiles[tileNumber];

  Positionable get _leftPointGlobal =>
      PositionFunctions.positionWithFraction(tile.leftNearPointGlobal, tile.leftFarPointGlobal, depthFraction);
  Positionable get _rightPointGlobal =>
      PositionFunctions.positionWithFraction(tile.rightNearPointGlobal, tile.rightFarPointGlobal, depthFraction);
  Positionable get _middlePointGlobal => PositionFunctions.median(_leftPointGlobal, _rightPointGlobal);

  ///Points depend on global [tile] points coordinates, so no more rotation is needed, unless rotation around [tile]
  List<List<Positionable>> get _tileOrientedPoints => [
        [
          _leftPointGlobal,
          PositionFunctions.median(_leftPointGlobal, _middlePointGlobal),
          _middlePointGlobal,
          PositionFunctions.median(_rightPointGlobal, _middlePointGlobal),
          _rightPointGlobal
        ],
        [
          _leftPointGlobal,
          PositionFunctions.median(_leftPointGlobal, _middlePointGlobal),
          _middlePointGlobal,
          PositionFunctions.median(_rightPointGlobal, _middlePointGlobal),
          _rightPointGlobal
        ],
        [
          _leftPointGlobal,
          PositionFunctions.median(_leftPointGlobal, _middlePointGlobal),
          _middlePointGlobal,
          PositionFunctions.median(_rightPointGlobal, _middlePointGlobal),
          _rightPointGlobal
        ],
      ];
  final List<List<Positionable>> _localLines = [
    [
      Positionable(0, 0, -5),
      Positionable(0, -5, -2.5),
      Positionable.zero(),
      Positionable(0, -5, -2.5),
      Positionable(0, 0, -5)
    ],
    [
      Positionable.zero(),
      Positionable(0, -5, 0),
      Positionable.zero(),
      Positionable(0, -5, 0),
      Positionable.zero(),
    ],
    [
      Positionable(0, 0, 5),
      Positionable(0, -5, 2.5),
      Positionable.zero(),
      Positionable(0, -5, 2.5),
      Positionable(0, 0, 5)
    ],
  ];
  static final Paint _paint = Paint()
    ..color = Colors.red
    ..strokeWidth = Drawable.strokeWidth;

  List<List<Positionable>> get _spiderLines {
    List<List<Positionable>> output = List.generate(
        _localLines.length, (index) => List.generate(_localLines.first.length, (index) => Positionable.zero()));
    for (int i = 0; i < _localLines.length; i++) {
      final rotatedLine = rotateZ(Positionable.zero(), _localLines[i], tile.angle);
      for (int j = 0; j < rotatedLine.length; j++) {
        final line = rotatedLine[j] + _tileOrientedPoints[i][j];
        output[i][j] = (line);
      }
    }
    return output;
  }

  @override
  void updateAndShow(Canvas canvas, DateTime frameTimestamp) {
    updatePosition(frameTimestamp);
    for (final line in _spiderLines) {
      drawLines(canvas, line, _paint);
    }
  }

  static const _speed = 0.005;

  @override
  void updatePosition(DateTime frameTimestamp) {
    depthFraction -= _speed * (frameTimestamp.difference(lastFrameTimestamp).inMilliseconds / Drawable.syncTime);
    lastFrameTimestamp = frameTimestamp;
  }

  @override
  bool get disappear => depthFraction < 0;
}
