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
  Drawable(this.pivot, this._vertexes, this._faces);

  final Positionable pivot;
  final List<Positionable> _vertexes;
  final List<List<int>> _faces;

  void show(Canvas canvas, Paint paint);

  List<Offset> _project2D(List<Positionable> list) {
    return list.map((point) => _convert3DToOffset(point)).toList();
  }

  ///Use in constructor for permanent effect or in show() for onFrame effect
  void applyTransformation({double? angleX, double? angleY, double? angleZ, double? scaleToWidth}) {
    _transformedVertexes = [..._vertexes];
    angleX != null ? _rotateX(angleX) : null;
    angleY != null ? _rotateY(angleY) : null;
    angleZ != null ? _rotateZ(angleZ) : null;
    scaleToWidth != null ? _scale(scaleToWidth) : null;
  }

  late List<Positionable> _transformedVertexes = _vertexes.toList();
  List<Positionable> get getGlobalVertexes => _transformedVertexes.map((point) => point + pivot).toList();
  Offset _convert3DToOffset(Positionable point) {
    point.z = point.z <= 0 ? 0.5 : point.z; //prevent imaginary draw behing camera

    final x = ((distanceToCamera * point.x / (point.z + distanceToCamera)) / (distanceToCamera * 4) + 0.5) * canvasSize;
    final y =
        (((distanceToCamera * point.y / (point.z + distanceToCamera)) / (distanceToCamera * 4)) + 0.5) * canvasSize;
    return Offset(x, y);
  }

  static const syncTime = 48;
  static const distanceToCamera = 0.0000000001;
  static late double canvasSize;
  static void setCanvasSize(Size size) {
    canvasSize = size.width;
  }

  static const double strokeWidth = 1;

  void _scale(double width) {
    final maxWidth =
        _transformedVertexes.reduce((value, element) => value.y.abs() > element.y.abs() ? value : element).y.abs();
    final k = width / maxWidth;
    _transformedVertexes = _transformedVertexes.map((e) => e * k).toList();
  }

  ///Rotates all points around pivot by angle. If points are in local coordinates, [pivot] = Positionable.zero()
  List<Positionable> _rotateX(double angle) =>
      _transformedVertexes = _transformedVertexes.map((point) => point.rotateX(angle - pi / 2)).toList();

  ///Rotates all points around pivot by angle. If points are in local coordinates, [pivot] = Positionable.zero()
  List<Positionable> _rotateY(double angle) =>
      _transformedVertexes = _transformedVertexes.map((point) => point.rotateY(angle - pi / 2)).toList();

  ///Rotates all points around pivot by angle. If points are in local coordinates, [pivot] = Positionable.zero()
  void _rotateZ(double angle) =>
      _transformedVertexes = _transformedVertexes.map((point) => point.rotateZ(angle - pi / 2)).toList();
}

class Drawable3D extends Drawable {
  final List<Vector3> _normals;
  Drawable3D(super.pivot, super._vertexes, super._faces, this._normals);

  bool _visible(int i) => _vertexes[_faces[i].first].dot(_normals[i]) > 0;

  @override
  void show(Canvas canvas, Paint paint) {
    for (final (i, face) in _faces.indexed) {
      if (_visible(i)) {
        final projected = _project2D(List.generate(face.length, (index) => getGlobalVertexes[face[index]]));
        canvas.drawPoints(PointMode.polygon, projected, paint);
        canvas.drawPoints(PointMode.lines, [projected.first, projected.last], paint);
      }
    }
  }
}

class Drawable2D extends Drawable {
  Drawable2D(super.pivot, super._vertexes, super._faces);

  @override
  void show(Canvas canvas, Paint paint) {
    for (final face in _faces) {
      final projected = _project2D(List.generate(face.length, (index) => getGlobalVertexes[face[index]]));
      canvas.drawPoints(PointMode.polygon, projected, paint);
      canvas.drawPoints(PointMode.lines, [projected.first, projected.last], paint);
    }
  }
}
