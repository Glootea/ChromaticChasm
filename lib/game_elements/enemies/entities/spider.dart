part of 'package:tempest/game_elements/enemies/enemy.dart';

class Spider extends Enemy {
  Spider._(TilePositionable pivot)
      : super._(
            pivot,
            Drawable2D(pivot, _verteces, _faces)
              ..applyTransformation(
                angleZ: LevelTileHelper.getAngle(pivot),
                scaleToWidth: LevelTileHelper.getTileWidth(pivot),
              ));
  Spider(Level level, int tileNumber) : this._(TilePositionable(level, tileNumber, depthFraction: 1));

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

  @override
  void onFrame(Canvas canvas, Camera camera, DateTime frameTimestamp) {
    updatePosition(frameTimestamp);
    drawable.show(canvas, camera, _paint);
  }

  /// Depth fraction of how much is traveled on one [Drawable.syncTime]
  @override
  double speed = 0.005;

  @override
  void updatePosition(DateTime frameTimestamp) {
    final depthFraction = pivot.depthFraction -
        speed * (frameTimestamp.difference(lastFrameTimestamp).inMilliseconds / Drawable.syncTime);
    pivot.updatePosition(depthFraction: depthFraction);
    lastFrameTimestamp = frameTimestamp;
  }

  @override
  bool get disappear => pivot.depthFraction < 0;
}
