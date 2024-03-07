part of 'package:tempest/game_elements/enemies/enemy.dart';

class Spider extends Enemy {
  Spider._(TilePositionable pivot)
      : super._(
            pivot,
            Drawable2D(pivot, _verteces, _faces, width: LevelTileHelper.getTileWidth(pivot))
              ..applyTransformation(angleZ: LevelTileHelper.getAngle(pivot)));
  Spider.create(Level level, int tileNumber) : this._(TilePositionable(level, tileNumber, depthFraction: 1));
  LevelTile get tile => pivot.level.children[pivot.tileNumber];

  static final List<Positionable> _verteces = [
    Positionable(-0.04947704076766968, -1.0, 0.0),
    Positionable(-0.04947704076766968, 0.0, -7.010334002188756e-08),
    Positionable(-0.04947704076766968, 1.0, 0.0),
    Positionable(-0.5494770407676697, -0.5, 0.0),
    Positionable(-0.5494770407676697, 0.5, 0.0),
    Positionable(-0.04947700351476669, -0.8660253882408142, 0.5),
    Positionable(-0.04947708547115326, 0.8660253882408142, -0.5),
    Positionable(-0.5494770407676697, -0.4330126941204071, 0.25),
    Positionable(-0.5494770407676697, 0.4330126941204071, -0.25),
    Positionable(-0.04947708547115326, -0.8660253882408142, -0.5),
    Positionable(-0.04947700351476669, 0.8660253882408142, 0.5),
    Positionable(-0.5494770407676697, -0.4330126941204071, -0.25),
    Positionable(-0.5494770407676697, 0.4330126941204071, 0.25)
  ];

  static final List<List<int>> _faces = [
    [3, 0],
    [4, 2],
    [1, 3],
    [1, 4],
    [5, 7],
    [8, 6],
    [9, 11],
    [12, 10],
    [7, 1],
    [1, 8],
    [11, 1],
    [1, 12]
  ];

  static final Paint _paint = Paint()
    ..color = Colors.red
    ..strokeWidth = Drawable.strokeWidth;

  // List<List<Positionable>> get _spiderLines {
  //   List<List<Positionable>> output = List.generate(
  //       _localLines.length, (index) => List.generate(_localLines.first.length, (index) => Positionable.zero()));
  //   for (int i = 0; i < _localLines.length; i++) {
  //     final rotatedLine = rotateZ(Positionable.zero(), _localLines[i], tile.angle);
  //     for (int j = 0; j < rotatedLine.length; j++) {
  //       final line = rotatedLine[j] + _tileOrientedPoints[i][j];
  //       output[i][j] = (line);
  //     }
  //   }
  //   return output;
  // }

  @override
  void onFrame(Canvas canvas, DateTime frameTimestamp) {
    updatePosition(frameTimestamp);
    drawable.show(canvas, _paint);
  }

  static const _speed = 0.005;

  @override
  void updatePosition(DateTime frameTimestamp) {
    final dF = pivot.depthFraction -
        _speed * (frameTimestamp.difference(lastFrameTimestamp).inMilliseconds / Drawable.syncTime);
    pivot.updatePosition(dF);
    lastFrameTimestamp = frameTimestamp;
  }

  @override
  bool get disappear => pivot.depthFraction < 0;
}
