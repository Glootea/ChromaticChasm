import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:chromatic_chasm/level_builder/level_editor/level_editor_state.dart';
import 'package:chromatic_chasm/level_builder/level_editor/level_preview_screen.dart';
import 'package:chromatic_chasm/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LevelEditorScreen extends StatefulWidget {
  final int levelId;

  const LevelEditorScreen({super.key, required this.levelId});

  @override
  State<LevelEditorScreen> createState() => _LevelEditorScreenState();
}

class _LevelEditorScreenState extends State<LevelEditorScreen> {
  final _edgeInset = 32.0;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LevelEditorState>();
    final screenSize = MediaQuery.sizeOf(context);
    final verticalInsets = MediaQuery.viewPaddingOf(context).top;
    final availableHeight =
        screenSize.height - verticalInsets - kToolbarHeight - _edgeInset;

    final leftUpperPoint = Offset(_edgeInset, verticalInsets + _edgeInset);
    final rightLowerPoint = Offset(
      screenSize.width - _edgeInset,
      availableHeight,
    );
    state.onScreenSizeChange(leftUpperPoint, rightLowerPoint);

    final key = GlobalKey();
    return state.loading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
          key: key,
          endDrawer: const LevelEditorDrawer(),

          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () => state.addPoint(),
                icon: const Icon(Icons.add_outlined),
              ),
              IconButton(
                onPressed: () => _onPlayButtonPressed(context, state),
                icon: const Icon(Icons.play_arrow_outlined),
              ),
              IconButton(
                onPressed: () => state.save(),
                icon:
                    state.saving
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.save_outlined),
              ),
              IconButton(
                onPressed:
                    () => (key.currentState as ScaffoldState).openEndDrawer(),
                icon: const Icon(Icons.more_horiz_outlined),
              ),
            ],
            leading: IconButton(
              onPressed: () {
                void exitScreen() {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }

                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text(context.localization.saveQuestion),
                        actions: [
                          TextButton(
                            onPressed: exitScreen,
                            child: Text(context.localization.removeChanges),
                          ),
                          FilledButton(
                            onPressed: () async {
                              await state.save();
                              exitScreen();
                            },
                            child: Text(context.localization.save),
                          ),
                        ],
                      ),
                );
              },
              icon: const Icon(Icons.arrow_back_outlined),
            ),
          ),
          body: Stack(
            fit: StackFit.expand,
            children:
                <Widget>[
                  IgnorePointer(
                    child: CustomPaint(
                      painter: ConnectionsPainter(
                        points: state.points,
                        circular: state.circular,
                      ),
                    ),
                  ),
                ] +
                state.points
                    .map<Widget>(
                      (e) => LevelPoint(
                        point: e,
                        onUpdatePosition: state.updatePoint,
                        onDepthChange: state.updateDepth,
                        onDelete: () => state.deletePoint(e),
                      ),
                    )
                    .toList(),
          ),
        );
  }

  void _onPlayButtonPressed(BuildContext context, LevelEditorState state) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewLevelScreen(level: state.levelForTesting),
        ),
      );
}

class LevelPoint extends StatefulWidget {
  final LevelEditorPoint point;
  final Function(LevelEditorPoint) onUpdatePosition;
  final Function(double) onDepthChange;
  final VoidCallback onDelete;

  const LevelPoint({
    required this.point,
    required this.onUpdatePosition,
    required this.onDepthChange,
    required this.onDelete,
    super.key,
  });

  @override
  State<LevelPoint> createState() => _LevelPointState();
}

class _LevelPointState extends State<LevelPoint> {
  final touchSize = 32.0;
  final visialSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.point.offset.dx,
      top: widget.point.offset.dy,
      child: Transform.translate(
        offset: -Offset(touchSize, touchSize) / 2,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: touchSize,
                width: touchSize,
                child: GestureDetector(
                  onLongPress:
                      () => setState(() {
                        widget.point.selected = !widget.point.selected;
                      }),
                  onPanUpdate:
                      (details) => setState(() {
                        widget.point.offset += details.delta;
                        widget.onUpdatePosition(widget.point);
                      }),
                  child: Center(
                    child: SizedBox(
                      height: visialSize,
                      width: visialSize,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.point.selected)
                Slider(
                  value: widget.point.depth,
                  min: Level.minDepth,
                  max: Level.maxDepth,
                  onChanged:
                      (value) => setState(() {
                        if (value > Level.maxDepth || value < Level.minDepth) {
                          return;
                        }
                        widget.point.depth = value;
                        widget.onDepthChange(value);
                      }),
                  label: widget.point.depth.toStringAsFixed(1),
                ),
              if (widget.point.selected)
                SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.localization.depth),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: widget.onDelete,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConnectionsPainter extends CustomPainter {
  final List<LevelEditorPoint> points;
  final bool circular;
  const ConnectionsPainter({required this.points, required this.circular});
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 2;

    void showDepth(LevelEditorPoint point) {
      final fraction =
          (point.depth - Level.minDepth) / (Level.maxDepth - Level.minDepth);
      final radius = fraction * 50;
      canvas.drawCircle(
        Offset(point.offset.dx, point.offset.dy),
        radius,
        paint,
      );
      canvas.drawCircle(
        Offset(point.offset.dx, point.offset.dy),
        radius - 2,
        paint..blendMode = BlendMode.difference,
      );
    }

    for (int i = 1; i < points.length; i++) {
      final point = points[i];
      final lastPoint = points[i - 1];
      showDepth(point);
      canvas.drawLine(
        Offset(lastPoint.offset.dx, lastPoint.offset.dy),
        Offset(point.offset.dx, point.offset.dy),
        paint,
      );
    }

    if (circular) {
      final firstPoint = points.first;
      final point = points[points.length - 1];
      showDepth(firstPoint);
      canvas.drawLine(
        Offset(firstPoint.offset.dx, firstPoint.offset.dy),
        Offset(point.offset.dx, point.offset.dy),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ConnectionsPainter oldDelegate) =>
      oldDelegate.points != points;
}

class LevelEditorDrawer extends StatefulWidget {
  const LevelEditorDrawer({super.key});

  @override
  State<LevelEditorDrawer> createState() => _LevelEditorDrawerState();
}

class _LevelEditorDrawerState extends State<LevelEditorDrawer> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<LevelEditorState>();
    return Drawer(
      child: Column(
        children: [
          Row(
            children: [
              Text(context.localization.levelIsLooped),
              Checkbox(
                value: state.circular,
                onChanged:
                    (value) => setState(() => state.updateCircular(value!)),
              ),
            ],
          ),
          Row(
            children: [
              Text(context.localization.levelDepth),
              Slider(
                value: state.depth,
                min: Level.minDepth,
                max: Level.maxDepth,
                onChanged: (value) => setState(() => state.updateDepth(value)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
