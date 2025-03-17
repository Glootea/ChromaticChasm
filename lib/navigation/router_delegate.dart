import 'package:chromatic_chasm/navigation/route.dart';
import 'package:flutter/material.dart';

class ChromaticChasmRouterDelegate extends RouterDelegate<ChromaticChasmRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ChromaticChasmRoute> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
  @override
  ChromaticChasmRoute currentConfiguration = StartRoute();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        ...StartRoute().getPages(context),
        ...currentConfiguration.getPages(context),
      ],
      onDidRemovePage: (page) {},
    );
  }

  @override
  Future<void> setNewRoutePath(ChromaticChasmRoute configuration) async {
    print('New configuration: $configuration');
    currentConfiguration = configuration;
    notifyListeners();
  }

  void goToStartMenuRoute() => setNewRoutePath(StartRoute());
  void goToLevelSelectorRoute() => setNewRoutePath(LevelSelectorRoute());
  void goToLevelEditorRoute(int levelId) => setNewRoutePath(
    LevelEditorRoute(
      Uri.parse('/levelEditor?${LevelEditorRoute.levelIdParamName}=$levelId'),
    ),
  );
  void goToGameRoute() => setNewRoutePath(GameRoute());
}
