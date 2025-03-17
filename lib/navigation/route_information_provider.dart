import 'package:chromatic_chasm/navigation/router_delegate.dart';
import 'package:flutter/widgets.dart';

class ChromaticChasmRouteInformationProvider extends RouteInformationProvider
    with ChangeNotifier {
  final ChromaticChasmRouterDelegate routerDelegate;

  ChromaticChasmRouteInformationProvider(this.routerDelegate);

  @override
  RouteInformation get value => _value;
  late RouteInformation _value = RouteInformation(
    uri: Uri.parse(routerDelegate.currentConfiguration.path),
  );

  @override
  void routerReportsNewRouteInformation(
    RouteInformation routeInformation, {
    RouteInformationReportingType type = RouteInformationReportingType.none,
  }) {
    _value = routeInformation;
    notifyListeners();
    super.routerReportsNewRouteInformation(routeInformation, type: type);
  }
}
