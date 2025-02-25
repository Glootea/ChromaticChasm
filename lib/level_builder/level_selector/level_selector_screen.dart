import 'package:chromatic_chasm/database/database.dart';
import 'package:chromatic_chasm/game/elements/level/level.dart';
import 'package:chromatic_chasm/level_builder/level_editor/level_editor_screen.dart';
import 'package:chromatic_chasm/level_builder/level_editor/level_editor_state.dart';
import 'package:chromatic_chasm/level_builder/level_selector/level_selector_state.dart';
import 'package:chromatic_chasm/share/share_provider.dart';
import 'package:chromatic_chasm/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: выяснить, куда проподают уровни
class LevelSelectorScreen extends StatefulWidget {
  const LevelSelectorScreen({super.key});

  @override
  State<LevelSelectorScreen> createState() => _LevelSelectorScreenState();
}

class _LevelSelectorScreenState extends State<LevelSelectorScreen> {
  late final ChromaticChasmDatabase dataBase;
  late final LevelSelectorNotifier levelSelectorNotifier;

  @override
  void initState() {
    dataBase = context.read<ChromaticChasmDatabase>();
    levelSelectorNotifier = LevelSelectorNotifier(database: dataBase)
      ..getLevels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          onShare: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ShareDialog(
                                  levelId:
                                      levelSelectorNotifier.levels[index].id,
                                  database: dataBase,
                                );
                              },
                            );
                          },
                          onEdit: () => _onEdit(context: context, index: index),
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

  void _onEdit({required BuildContext context, required int index}) {
    final levelId = levelSelectorNotifier.levels[index].id;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ListenableProvider(
              create:
                  (_) =>
                      LevelEditorState(database: dataBase, levelId: levelId)
                        ..loadExistingPoints(),
              child: LevelEditorScreen(levelId: levelId),
            ),
      ),
    );
  }
}

class LevelTile extends StatefulWidget {
  final LevelSelectionItem item;
  final VoidCallback onShare;
  final void Function() onEdit;
  final void Function(String) onRename;
  final void Function() onToggleActive;
  final void Function() onDelete;
  const LevelTile({
    required this.onShare,
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
    final size = MediaQuery.sizeOf(context);
    final children = [
      [
        Expanded(
          child: TextField(
            maxLines: 1,
            decoration: const InputDecoration(border: InputBorder.none),
            controller: controller,
            onChanged: (value) {
              widget.onRename(value);
            },
          ),
        ),
      ],
      [
        IconButton(
          onPressed: widget.onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          onPressed: widget.onShare,
          icon: const Icon(Icons.share_outlined),
        ),
        Checkbox(
          value: widget.item.activated,
          onChanged: (_) => widget.onToggleActive(),
        ),
        IconButton(
          onPressed:
              () => showDialog(
                context: context,
                builder: (_) => DeleteDialog(onDelete: widget.onDelete),
              ),
          icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
        ),
      ],
    ];

    List<Widget> getSingleRow() => children.expand((e) => e).toList();
    List<Row> getColumnRows() =>
        children.map((rowChildren) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: rowChildren,
          );
        }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child:
            size.width > size.height
                ? Row(children: getSingleRow())
                : Column(children: getColumnRows()),
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

class ShareDialog extends StatefulWidget {
  const ShareDialog({required this.database, required this.levelId, super.key});

  final ChromaticChasmDatabase database;
  final int levelId;

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  bool loading = true;
  Level? level;
  bool shorten = false;
  @override
  Widget build(BuildContext context) {
    if (loading) {
      loadLevel();
      return const Center(child: CircularProgressIndicator());
    }
    return AlertDialog(
      title: Text(context.localization.shareLevel),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${context.localization.shortenUrl}: '),
          Switch(
            value: shorten,
            onChanged: (newValue) => setState(() => shorten = newValue),
          ),
        ],
      ),
      actions: [
        FilledButton(
          child: Text(context.localization.copyToClipboard),
          onPressed: () async {
            final localization = context.localization;
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final hasError = await ShareProvider().onCopyToClipboard(
              level: level!,
              shorten: shorten,
            );
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(
                  '${localization.copiedToClipboard}${hasError ? '. ${localization.shortenError}' : ''}',
                ),
              ),
            );
          },
        ),
        FilledButton(
          child: Text(context.localization.share),
          onPressed:
              () async => ShareProvider().onSystemShare(
                level: level!,
                shorten: shorten,
              ),
        ),
        TextButton(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.error,
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(context.localization.cancel),
        ),
      ],
    );
  }

  Future<void> loadLevel() async {
    level = await widget.database.getLevel(widget.levelId);
    loading = false;
    setState(() {});
  }
}
