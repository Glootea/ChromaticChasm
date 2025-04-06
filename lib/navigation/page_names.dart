import 'package:chromatic_chasm/navigation/route.dart';

const _start = '/';
const _levelSelector = '/level_selector';
const _levelEditor = '/level_selector/level_editor';
const _game = '/game';
const _unknown = '/404';

enum PageName {
  start(_start),
  levelSelector(_levelSelector),
  levelEditor(_levelEditor),
  game(_game),
  unknown(_unknown);

  final String path;

  const PageName(this.path);
  static PageName fromUri(Uri uri) {
    return PageName.values.firstWhere(
      (e) => e.path == uri.path,
      orElse: () => unknown,
    );
  }

  ChromaticChasmRoute getRoute(Uri uri) => switch (PageName.fromUri(uri)) {
    PageName.start => StartRoute(),
    PageName.levelSelector => LevelSelectorRoute(uri),
    PageName.levelEditor => LevelEditorRoute(uri),
    PageName.game => GameRoute(),
    PageName.unknown => PageNotFoundRoute(initialPath: uri.path),
  };
}
