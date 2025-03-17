import 'package:chromatic_chasm/navigation/page_names.dart';
import 'package:chromatic_chasm/navigation/route.dart';
import 'package:flutter/widgets.dart';

class ChromaticChasmRouteInformationParser
    extends RouteInformationParser<ChromaticChasmRoute> {
  @override
  Future<ChromaticChasmRoute> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    final uri = routeInformation.uri;
    print('parseRouteInformation: $uri');
    return Future.value(PageName.fromString(uri).getRoute(uri));
  }

  @override
  RouteInformation? restoreRouteInformation(
    ChromaticChasmRoute configuration,
  ) => RouteInformation(uri: Uri.parse("/${configuration.path}"));
}
