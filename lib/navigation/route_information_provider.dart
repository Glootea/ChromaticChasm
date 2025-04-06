import 'package:flutter/widgets.dart';

class ChromaticChasmRouteInformationProvider
    extends PlatformRouteInformationProvider {
  @override
  RouteInformation value = RouteInformation(uri: Uri.parse('/'));

  ChromaticChasmRouteInformationProvider({
    required super.initialRouteInformation,
  });

  @override
  void routerReportsNewRouteInformation(
    RouteInformation routeInformation, {
    RouteInformationReportingType type = RouteInformationReportingType.none,
  }) {
    if (value == routeInformation) return;
    value = routeInformation;
    debugPrint('routerReportsNewRouteInformation: ${routeInformation.uri}');
    super.routerReportsNewRouteInformation(routeInformation);
  }
}
