import 'package:chromatic_chasm/database/database.dart';
import 'package:chromatic_chasm/navigation/route_information_parser.dart';
import 'package:chromatic_chasm/navigation/route_information_provider.dart';
import 'package:chromatic_chasm/navigation/router_delegate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  runApp(
    Provider(
      create: (_) => ChromaticChasmDatabase(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          sliderTheme: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          ),
          brightness: Brightness.dark,
        ),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('en'), const Locale('ru')],
        locale: const Locale('ru'),
        routerConfig: RouterConfig(
          routerDelegate: ChromaticChasmRouterDelegate(),
          routeInformationParser: ChromaticChasmRouteInformationParser(),
          routeInformationProvider: ChromaticChasmRouteInformationProvider(
            initialRouteInformation: RouteInformation(uri: Uri.parse('/')),
          ),
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    ),
  );
}
