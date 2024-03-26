part of 'package:chromatic_chasm/game_elements/enemies/enemy.dart';

class Spider extends Enemy {
  Spider._(TilePositionable pivot)
      : super._(
            pivot,
            SpiderDefaultDrawable(pivot)
              ..applyTransformation(
                  angleZ: LevelTileHelper.getAngle(pivot), widthToScale: LevelTileHelper.getTileWidth(pivot)));

  Spider(Level level, int tileNumber) : this._(TilePositionable(level, tileNumber, depthFraction: 1));

  @override
  void onFrame(Canvas canvas, Camera camera, DateTime frameTimestamp) {
    updatePosition(frameTimestamp);
    drawable.show(canvas, camera, _paint);
  }

  static final Paint _paint = Paint()
    ..color = Colors.red
    ..strokeWidth = Drawable.strokeWidth;

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
