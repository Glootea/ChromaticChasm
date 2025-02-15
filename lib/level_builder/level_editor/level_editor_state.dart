import 'package:chromatic_chasm/database/database.dart';
import 'package:chromatic_chasm/game/elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:chromatic_chasm/game/elements/level/tile/level_tile.dart';
import 'package:flutter/material.dart';

class LevelEditorState extends ChangeNotifier {
  final ChromaticChasmDatabase _database;

  final int _levelId;

  late Level _level;

  List<LevelEditorPoint> _points = [];
  List<LevelEditorPoint> get points => _points;
  double _levelDepth = 200;
  double get depth => _levelDepth;
  bool _circular = false;
  bool get circular => _circular;
  bool _saving = false;
  bool get saving => _saving;
  bool _loading = false;
  bool get loading => _loading;
  Size _screenSize;

  LevelEditorState({
    required ChromaticChasmDatabase database,
    required int levelId,
    required Size screenSize,
  }) : _levelId = levelId,
       _database = database,
       _screenSize = screenSize;

  Future<void> loadExistingPoints() async {
    _loading = true;
    notifyListeners();
    _level = await _database.getLevel(_levelId);
    _circular = _level.circlular;
    // _points = _level.tiles.indexed.map(_mapTile).toList();
    _loading = false;
    _scalePointsToDisplay();
    notifyListeners();
  }

  LevelEditorPoint _mapTile((int, LevelTile) tile) {
    final point = tile.$2.leftNearPointGlobal;

    return mapPoint((tile.$1, point));
  }

  void addPoint() {
    final first = points[0];
    final last = points[points.length - 1];
    final point = LevelEditorPoint(
      id: points.length,
      offset: Offset(
        (first.offset.dx + last.offset.dx) / 2,
        (first.offset.dy + last.offset.dy) / 2,
      ),
      depth: (first.depth + last.depth) / 2,
    );
    _points.add(point);
    notifyListeners();
    _rebuildLevel();
  }

  @Deprecated('Use delete point instead')
  void removeLastPoint() {
    if (points.length <= 3) return;
    _points.removeLast();
    notifyListeners();
    _rebuildLevel();
  }

  void deletePoint(LevelEditorPoint point) {
    if (points.length <= 3) return;
    _points.remove(point);
    notifyListeners();
  }

  void updatePoint(LevelEditorPoint point) {
    _points[point.id] = point;
    _rebuildLevel();
  }

  void updateDepth(double depth) {
    _levelDepth = depth;
    _rebuildLevel();
  }

  void updateCircular(bool circular) {
    _circular = circular;
    _rebuildLevel();
  }

  Future<void> save() async {
    _saving = true;
    notifyListeners();
    final points = _getScaledBackPoints().map((e) => e.toPositional).toList();
    final updatedLevel = Level.fromPoints(
      id: _levelId,
      points: points,
      depth: depth,
      circlular: circular,
      pivot: Positionable.zero(),
    );
    await _database.updateLevelContent(updatedLevel);
    _saving = false;
    notifyListeners();
  }

  /// Should be called after all modifications
  void _rebuildLevel() {
    _level = Level.fromPoints(
      id: _levelId,
      points: _points.map((p) => p.toPositional).toList(),
      depth: _levelDepth,
      circlular: _circular,
    );
    print(_level.tiles.first.pivot);
  }

  static const double _ocupiedArea = 0.6;

  void _scalePointsToDisplay() {
    if (loading) return;
    final initialPoints =
        _level.tiles.indexed.map(_mapTile).map((p) => p.toPositional).toList();
    double maxX = 0, maxY = 0;
    double minX = double.maxFinite, minY = double.maxFinite;
    for (final point in initialPoints) {
      maxX = maxX > point.x ? maxX : point.x;
      minX = minX < point.x ? minX : point.x;
      maxY = maxY > point.y ? maxY : point.y;
      minY = minY < point.y ? minY : point.y;
    }
    final scaleX = _screenSize.width / (maxX - minX);
    final scaleY = _screenSize.height / (maxY - minY);
    print('Scaling');
    _points = List.generate(initialPoints.length, (i) {
      final point = initialPoints[i];
      return LevelEditorPoint(
        id: i,
        offset: Offset(
          (point.x - minX) * scaleX * _ocupiedArea +
              _screenSize.width * (1 - _ocupiedArea) * 0.5,
          (point.y - minY) * scaleY * _ocupiedArea +
              _screenSize.height * (1 - _ocupiedArea) * 0.5,
        ),
        depth: point.z,
      );
    });
  }

  void onScreenSizeChange(Size size) {
    if (size == _screenSize) return;
    _screenSize = size;
    _scalePointsToDisplay();
  }

  List<LevelEditorPoint> _getScaledBackPoints() {
    final initialPoints = points.map((p) => p.toPositional).toList();
    double maxX = 0, maxY = 0;
    double minX = double.maxFinite, minY = double.maxFinite;
    for (final point in initialPoints) {
      maxX = maxX > point.x ? maxX : point.x;
      minX = minX < point.x ? minX : point.x;
      maxY = maxY > point.y ? maxY : point.y;
      minY = minY < point.y ? minY : point.y;
    }
    final scaleX = _screenSize.width / (maxX - minX);
    final scaleY = _screenSize.height / (maxY - minY);

    final levelPoints = List.generate(initialPoints.length, (i) {
      final point = initialPoints[i];
      return LevelEditorPoint(
        id: i,
        offset: Offset(
          (point.x - (_screenSize.width * (1 - _ocupiedArea) * 0.5)) /
                  (scaleX * _ocupiedArea) +
              minX,
          (point.y - (_screenSize.height * (1 - _ocupiedArea) * 0.5)) /
                  (scaleY * _ocupiedArea) +
              minY,
        ),
        depth:
            point.z -
            50, // prevents adding level pivot depth to point on every save // TODO: separate local and global points coordinates better
      );
    });

    return levelPoints;
  }
}

// record can't be used as only argument of function
typedef MapPointArgs = (int id, Positionable point);
LevelEditorPoint mapPoint(MapPointArgs args) {
  final id = args.$1;
  final point = args.$2;

  return LevelEditorPoint(
    id: id,
    offset: Offset(point.x, point.y),
    depth: point.z,
  );
}

class LevelEditorPoint {
  final int id;
  Offset offset;
  bool selected = false;
  double depth;

  LevelEditorPoint({
    required this.id,
    required this.offset,
    required this.depth,
  });

  Positionable get toPositional => Positionable(offset.dx, offset.dy, depth);

  @override
  bool operator ==(covariant LevelEditorPoint other) => id == other.id;

  @override
  int get hashCode => id;

  int operator <(covariant LevelEditorPoint other) => id.compareTo(other.id);
}
