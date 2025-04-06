import 'package:chromatic_chasm/database/database.dart';
import 'package:chromatic_chasm/game/game_screen/game_screen.dart';
import 'package:chromatic_chasm/game/game_state_provider.dart';
import 'package:chromatic_chasm/game/level_provider.dart';
import 'package:chromatic_chasm/level_builder/level_editor/level_editor_screen.dart';
import 'package:chromatic_chasm/level_builder/level_editor/level_editor_state.dart';
import 'package:chromatic_chasm/level_builder/level_selector/level_selector_screen.dart';
import 'package:chromatic_chasm/navigation/page_names.dart';
import 'package:chromatic_chasm/navigation/page_not_found.dart';
import 'package:chromatic_chasm/start_menu/start_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

sealed class ChromaticChasmRoute {
  final String path;
  ChromaticChasmRoute(this.path);

  List<Page> getPages(BuildContext context);

  static isKnownPath(String path) => PageName.values.any((e) => e.path == path);

  @override
  bool operator ==(covariant ChromaticChasmRoute other) => other.path == path;

  @override
  int get hashCode => path.hashCode;
}

class StartRoute extends ChromaticChasmRoute {
  StartRoute() : super(PageName.start.path);

  @override
  List<Page> getPages(BuildContext context) {
    final database = context.read<ChromaticChasmDatabase>();
    return [MaterialPage(child: StartMenu(database: database))];
  }
}

class LevelSelectorRoute extends ChromaticChasmRoute {
  final String? levelInfo;
  static const levelInfoParamName = 'info';

  LevelSelectorRoute([Uri? uri])
    : levelInfo = uri?.queryParameters[levelInfoParamName],
      super(PageName.levelSelector.path);

  @override
  List<Page> getPages(BuildContext context) => const [
    MaterialPage(child: LevelSelectorScreen()),
  ];
}

class LevelEditorRoute extends ChromaticChasmRoute {
  final int levelId;

  static const String levelIdParamName = 'levelId';

  LevelEditorRoute(Uri uri)
    : levelId = int.parse(uri.queryParameters[levelIdParamName]!),
      super(PageName.levelEditor.path);

  @override
  List<Page> getPages(BuildContext context) {
    final database = context.read<ChromaticChasmDatabase>();
    return [
      // const MaterialPage(child: LevelSelectorScreen()),
      MaterialPage(
        child: ChangeNotifierProvider(
          create: (_) => LevelEditorState(database: database, levelId: levelId),
          child: const LevelEditorScreen(),
        ),
      ),
    ];
  }
}

class GameRoute extends ChromaticChasmRoute {
  GameRoute() : super(PageName.game.path);

  @override
  List<Page> getPages(BuildContext context) {
    final levelProvider = LevelProvider();
    return [
      MaterialPage(
        child: FutureBuilder(
          future: levelProvider.init(context.read<ChromaticChasmDatabase>()),
          builder:
              (context, snapshot) =>
                  (snapshot.connectionState != ConnectionState.done)
                      ? const Center(child: CircularProgressIndicator())
                      : ChangeNotifierProvider(
                        create:
                            (_) => GameStateProvider.create(
                              levelProvider: levelProvider,
                            ),
                        child: GameScreen(levelProvider: levelProvider),
                      ),
        ),
      ),
    ];
  }
}

class PageNotFoundRoute extends ChromaticChasmRoute {
  final String initialPath;
  PageNotFoundRoute({required this.initialPath}) : super(PageName.unknown.path);

  @override
  List<Page> getPages(BuildContext context) => [
    MaterialPage(child: PageNotFound(path: initialPath)),
  ];
}
