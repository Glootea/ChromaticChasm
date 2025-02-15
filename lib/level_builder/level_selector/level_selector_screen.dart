import 'package:chromatic_chasm/database/database.dart';
import 'package:chromatic_chasm/level_builder/level_editor/level_editor_screen.dart';
import 'package:chromatic_chasm/level_builder/level_editor/level_editor_state.dart';
import 'package:chromatic_chasm/level_builder/level_selector/level_selector_state.dart';
import 'package:chromatic_chasm/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: выяснить, куда проподают уровни
class LevelSelectorScreen extends StatelessWidget {
  const LevelSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataBase = context.read<ChromaticChasmDatabase>();
    final LevelSelectorNotifier levelSelectorNotifier = LevelSelectorNotifier(
      database: dataBase,
    )..getLevels();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.localization.levelSelection,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ListenableBuilder(
            listenable: levelSelectorNotifier,
            builder: (context, _) {
              return Expanded(
                child: ListView.builder(
                  itemCount: levelSelectorNotifier.levels.length,
                  itemBuilder:
                      (_, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: LevelTile(
                          key: UniqueKey(),
                          item: levelSelectorNotifier.levels[index],
                          onEdit: () {
                            final levelId =
                                levelSelectorNotifier.levels[index].id;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ListenableProvider(
                                      create:
                                          (_) => LevelEditorState(
                                            database: dataBase,
                                            levelId: levelId,
                                            screenSize: MediaQuery.sizeOf(
                                              context,
                                            ),
                                          )..loadExistingPoints(),
                                      child: LevelEditorScreen(
                                        levelId: levelId,
                                      ),
                                    ),
                              ),
                            );
                          },
                          onRename:
                              (name) => levelSelectorNotifier.renameLevel(
                                index,
                                name,
                              ),
                          onToggleActive:
                              () => levelSelectorNotifier.toggleLevel(index),
                          onDelete:
                              () => levelSelectorNotifier.deleteLevel(index),
                        ),
                      ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => levelSelectorNotifier.addLevel(context.localization.newLevel),
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}

class LevelTile extends StatefulWidget {
  final LevelSelectionItem item;
  final void Function() onEdit;
  final void Function(String) onRename;
  final void Function() onToggleActive;
  final void Function() onDelete;
  const LevelTile({
    required this.item,
    required this.onEdit,
    required this.onRename,
    required this.onToggleActive,
    required this.onDelete,
    super.key,
  });

  @override
  State<LevelTile> createState() => _LevelTileState();
}

class _LevelTileState extends State<LevelTile> {
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.item.name);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                maxLines: 1,
                decoration: const InputDecoration(border: InputBorder.none),
                controller: controller,
                onChanged: (value) {
                  // controller.text = value;
                  widget.onRename(value);
                },
              ),
            ),
            IconButton(
              onPressed: widget.onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            Checkbox(
              value: widget.item.activated,
              onChanged: (_) {
                widget.onToggleActive();
              },
            ),
            IconButton(
              onPressed:
                  () => showDialog(
                    context: context,
                    builder:
                        (context) =>
                            DeleteDialog(onDelete: () => widget.onDelete()),
                  ),
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  final VoidCallback onDelete;
  const DeleteDialog({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(context.localization.deleteLevel)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.localization.cancel),
        ),
        OutlinedButton(
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.error,
            ),
            foregroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.onError,
            ),
          ),
          child: Text(context.localization.deleteLevel),
        ),
      ],
    );
  }
}
