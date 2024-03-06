import 'dart:math';
import 'dart:ui';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:vector_math/vector_math.dart';

sealed class Drawable {
  /// [_faces] is [List] of indexes of vertexes in [vertexes]
  ///
  /// [width] is used to scale objects. [width] = max width coordinate of object, located in [Positionable.zero()]
  ///
  /// In constructor all verteces are scaled with k = _width / _vertexes.maxWidth
  Drawable(this.pivot, List<Positionable> vertexes, this._faces, {double? width})
      : _vertexes = width != null ? _scale(vertexes, width) : vertexes;
  final Positionable pivot;
  List<Positionable> _vertexes;
  final List<List<int>> _faces;
  void show(Canvas canvas, Paint paint);
  late final int _length = _faces.length;
  List<Offset> _project2D(List<Positionable> list) {
    return list.map((point) => _convert3DToOffset(point)).toList();
  }

  List<Positionable> get getGlobalVertexes => _vertexes.map((point) => point + pivot).toList();
  Offset _convert3DToOffset(Positionable point) {
    point.z = point.z <= 0 ? 0.5 : point.z; //prevent imaginary draw behing camera

    final x = ((distanceToCamera * point.x / (point.z + distanceToCamera)) / (distanceToCamera * 4) + 0.5) * canvasSize;
    final y =
        (((distanceToCamera * point.y / (point.z + distanceToCamera)) / (distanceToCamera * 4)) + 0.5) * canvasSize;
    return Offset(x, y);
  }

  static const syncTime = 32;
  static const distanceToCamera = 0.0000000001;
  static late double canvasSize;
  static void setCanvasSize(Size size) {
    canvasSize = size.width;
  }

  static const double strokeWidth = 1;

  static List<Positionable> _scale(List<Positionable> vertexes, double width) {
    final maxWidth = vertexes.reduce((value, element) => value.y.abs() > element.y.abs() ? value : element).y.abs();
    final k = width / maxWidth;
    return vertexes.map((e) => e * k).toList();
  }

  ///Rotates all points around pivot by angle. If points are in local coordinates, [pivot] = Positionable.zero()
  List<Positionable> rotateX(Positionable pivot, List<Positionable> points, double angle) => points
      .map((point) => point.moveRotationPointToOrigin(pivot).rotateXAroundOrigin(angle).moveRotationPointBack(pivot))
      .toList();

  ///Rotates all points around pivot by angle. If points are in local coordinates, [pivot] = Positionable.zero()
  List<Positionable> rotateY(Positionable pivot, List<Positionable> points, double angle) => points
      .map((point) => point.moveRotationPointToOrigin(pivot).rotateYAroundOrigin(angle).moveRotationPointBack(pivot))
      .toList();

  ///Rotates all points around pivot by angle. If points are in local coordinates, [pivot] = Positionable.zero()
  void rotateZ(double angle) =>
      _vertexes = _vertexes.map((point) => point.rotateZAroundOrigin(angle - pi / 2)).toList();
}

class Drawable3D extends Drawable {
  final List<Vector3> _normals;
  Drawable3D(super.pivot, super._vertexes, super._faces, this._normals, {super.width});

  bool _visible(int i) => _vertexes[_faces[i].first].dot(_normals[i]) > 0;

  @override
  void show(Canvas canvas, Paint paint) {
    for (int i = 0; i < _length; i++) {
      if (_visible(i)) {
        final globalVertexes = getGlobalVertexes;
        final projected = _project2D(List.generate(_faces[i].length, (index) => globalVertexes[_faces[i][index]]));
        canvas.drawPoints(PointMode.polygon, projected, paint);
        canvas.drawPoints(PointMode.lines, [projected.first, projected.last], paint);
      }
    }
  }
}

class Drawable2D extends Drawable {
  Drawable2D(super.pivot, super._vertexes, super._faces, {super.width});

  @override
  void show(Canvas canvas, Paint paint) {
    for (int i = 0; i < _length; i++) {
      final globalVertexes = getGlobalVertexes;
      final projected = _project2D(List.generate(_faces[i].length, (index) => globalVertexes[_faces[i][index]]));
      canvas.drawPoints(PointMode.polygon, projected, paint);
      canvas.drawPoints(PointMode.lines, [projected.first, projected.last], paint);
    }
  }
}
