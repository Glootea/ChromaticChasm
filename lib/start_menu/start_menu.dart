import 'package:chromatic_chasm/database/database.dart';
import 'package:chromatic_chasm/navigation/router_delegate.dart';
import 'package:chromatic_chasm/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartMenu extends StatelessWidget {
  final ChromaticChasmDatabase database;
  const StartMenu({required this.database, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(flex: 6, child: SizedBox()),
            Text(
              context.localization.appTitle,
              style: Theme.of(context).textTheme.headlineLarge,
              maxLines: 2,
            ),
            const Expanded(flex: 2, child: SizedBox()),
            FilledButton(
              onPressed: () {
                context.read<ChromaticChasmRouterDelegate>().goToGameRoute();
              },
              child: Text(context.localization.play),
            ),
            const Expanded(child: SizedBox()),
            FilledButton(
              onPressed: () {},
              child: Text(context.localization.tutorial),
            ),
            const Expanded(child: SizedBox()),
            FilledButton(
              onPressed:
                  () =>
                      context
                          .read<ChromaticChasmRouterDelegate>()
                          .goToLevelSelectorRoute(),

              child: Text(context.localization.levelBuilder),
            ),
            const Expanded(flex: 6, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
