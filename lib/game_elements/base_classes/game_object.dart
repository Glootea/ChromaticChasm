import 'package:flutter/material.dart';
import 'package:tempest/game_elements/base_classes/drawable.dart';
import 'package:tempest/game_elements/base_classes/game_object_lifecycle.dart';
import 'package:tempest/game_elements/base_classes/positionable.dart';
import 'package:tempest/game_elements/camera.dart';

abstract class _GameObject {
  final Positionable pivot;
  GameObjectLifecycle lifecycleState;
  DateTime lastFrameTimestamp = DateTime.now();
  _GameObject(this.pivot, {GameObjectLifecycle? lifecycle}) : lifecycleState = lifecycle ?? LiveLifecycle();

  void onFrame(Canvas canvas, Camera camera, DateTime frameTimestamp);
}

abstract class _TileGameObject extends _GameObject {
  @override
  // ignore: overridden_fields
  final TilePositionable pivot;
  _TileGameObject(this.pivot, {GameObjectLifecycle? lifecycle}) : super(pivot, lifecycle: lifecycle);
}

abstract class StatefulTileGameObject extends _TileGameObject {
  int state;
  final List<Drawable> drawables;
  StatefulTileGameObject(super.pivot, this.drawables, this.state, {super.lifecycle});
}

abstract class StatelessTileGameObject extends _TileGameObject {
  final Drawable drawable;
  StatelessTileGameObject(TilePositionable pivot, this.drawable, {super.lifecycle}) : super(pivot);
}

abstract class _GlobalGameObject extends _GameObject {
  @override
  // ignore: overridden_fields
  final Positionable pivot;
  _GlobalGameObject(this.pivot, {GameObjectLifecycle? lifecycle}) : super(pivot, lifecycle: lifecycle);
}

abstract class StatelessGlobalGameObject extends _GlobalGameObject {
  final Drawable drawable;
  StatelessGlobalGameObject(super.pivot, this.drawable, {super.lifecycle});
}

abstract class StatefulGlobalGameObject extends _GlobalGameObject {
  int state;
  final List<Drawable> drawables;
  StatefulGlobalGameObject(super.pivot, this.drawables, this.state, {super.lifecycle});
}

abstract class ComplexGlobalGameObject extends _GameObject {
  ComplexGlobalGameObject(super.pivot, this.children, {super.lifecycle});
  List<dynamic> children;
}
