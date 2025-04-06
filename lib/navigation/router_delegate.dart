import 'package:chromatic_chasm/navigation/route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChromaticChasmRouterDelegate extends RouterDelegate<ChromaticChasmRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ChromaticChasmRoute> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
  @override
  ChromaticChasmRoute currentConfiguration = StartRoute();

  late final List<ChromaticChasmRoute> _routeStack = [currentConfiguration];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this,
      child: Navigator(
        pages:
            _routeStack
                .map((e) => e.getPages(context))
                .expand((e) => e)
                .toList(),
        onDidRemovePage: (_) {
          _routeStack.removeLast();
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(ChromaticChasmRoute configuration) async {
    if (currentConfiguration == configuration) return;
    debugPrint('setNewRoutePath: $configuration');
    currentConfiguration = configuration;
    _routeStack.add(currentConfiguration);
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
