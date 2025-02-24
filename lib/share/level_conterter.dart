import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:flutter/rendering.dart';

class LevelConverter {
  /// Format:
  /// depth; circular; pivot xyz; points xyz (all numbers)
  /// xyz -> x, y, z doubles of vector3
  const LevelConverter();

  static const _baseUrl =
      'https://chromaticchasm.web.app/addLevel?$_queryParameterName=';
  static const _queryParameterName = 'info';

  static String toLink(Level level) {
    final info =
        '${level.depth}+${level.circlular ? '1' : '0'}+${level.pivot.format()}+${level.pointsToString()}';
    return _baseUrl + info;
  }

  static Level? fromLink(Uri url) {
    try {
      final levelInfo = url.queryParameters[_queryParameterName]!;
      final [depth, circular, pivotString, pointsString] = levelInfo.split('+');
      final pivot = Level.stringToPoints(pivotString)[0];
      final points = Level.stringToPoints(pointsString);

      return Level.fromPoints(
        id: -1,
        depth: depth as double,
        circlular: circular == '1',
        pivot: pivot,
        points: points,
      );
    } catch (e) {
      debugPrint('Failed to parse level: $e');
      return null;
    }
  }
}
