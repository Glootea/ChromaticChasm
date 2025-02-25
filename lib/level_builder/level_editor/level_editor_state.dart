import 'package:chromatic_chasm/database/database.dart';
import 'package:chromatic_chasm/game/elements/base_classes/positionable.dart';
import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:chromatic_chasm/game/elements/level/tile/level_tile.dart';
import 'package:flutter/material.dart';

class LevelEditorState extends ChangeNotifier {
  final ChromaticChasmDatabase _database;

  final int _levelId;

  late Level _level;
  Level get level => _level;
  Level get levelForTesting {
    _rebuildLevel();
    return _level;
  }

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
  Offset _leftUpperPoint;
  Offset _rightLowerPoint;

  LevelEditorState({
    required ChromaticChasmDatabase database,
    required int levelId,
  }) : _levelId = levelId,
       _database = database,
       _leftUpperPoint = const Offset(0, 0),
       _rightLowerPoint = const Offset(0, 0);

  Future<void> loadExistingPoints() async {
    _loading = true;
    notifyListeners();
    _level = await _database.getLevel(_levelId);
    _circular = _level.circlular;
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
    final points = _getScaledBackPoints();
    final updatedLevel = Level.fromPoints(
      id: _levelId,
      points: points,
      depth: depth,
      circlular: circular,
    );
    await _database.updateLevelContent(updatedLevel);
    _saving = false;
    notifyListeners();
  }

  /// Should be called after all modifications
  void _rebuildLevel() {
    _level = Level.fromPoints(
      id: _levelId,
      points: _getScaledBackPoints(),
      depth: _levelDepth,
      circlular: _circular,
    );
  }

  void _scalePointsToDisplay() {
    double edgeOffset = _leftUpperPoint.dx;
    double scaleSingle({
      required double value,
      required double minValue,
      required double scale,
      double startOffset = 0,
    }) => (value - minValue) * scale + edgeOffset;

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
    final scaleX = ((_rightLowerPoint.dx - _leftUpperPoint.dx)) / (maxX - minX);
    final scaleY = ((_rightLowerPoint.dy - _leftUpperPoint.dy)) / (maxY - minY);
    _points = List.generate(initialPoints.length, (i) {
      final point = initialPoints[i];
      return LevelEditorPoint(
        id: i,
        offset: Offset(
          scaleSingle(value: point.x, minValue: minX, scale: scaleX),
          scaleSingle(value: point.y, minValue: minY, scale: scaleY),
        ),
        depth: point.z,
      );
    });
  }

  /// leftUpperPoint.dx defines edge offset for all edges
  void onScreenSizeChange(Offset leftUpperPoint, Offset rightLowePoint) {
    if (leftUpperPoint == _leftUpperPoint &&
        rightLowePoint == _rightLowerPoint) {
      return;
    }
    _leftUpperPoint = leftUpperPoint;
    _rightLowerPoint = rightLowePoint;
    _scalePointsToDisplay();
  }

  List<Positionable> _getScaledBackPoints() {
    final initialPoints = points.map((p) => p.toPositional).toList();
    double maxX = 0, maxY = 0;
    double minX = double.maxFinite, minY = double.maxFinite;
    for (final point in initialPoints) {
      maxX = maxX > point.x ? maxX : point.x;
      minX = minX < point.x ? minX : point.x;
      maxY = maxY > point.y ? maxY : point.y;
      minY = minY < point.y ? minY : point.y;
    }
    final diffX = maxX - minX;
    final diffY = maxY - minY;

    final levelPoints = List.generate(initialPoints.length, (i) {
      final point = initialPoints[i];
      return Positionable(
        (((point.x - minX) / diffX) - 0.5) * Level.levelRadius * 1.8,
        (((point.y - minY) / diffY) - 0.5) * Level.levelRadius * 1.8,
        point.z - 100,
        // prevents adding level pivot depth to point on every save
        // TODO: separate local and global points coordinates better
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
