import 'package:dentist_app/app/home/presentation/homeView.dart';
import 'package:dentist_app/app/patientManagement/presentation/patientManagementView.dart';
import 'package:flutter/material.dart';

class AppNavigationService extends NavigationService {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationService.homepage:
        return MaterialPageRoute(builder: (_) => HomePage());

      case NavigationService.patientsManagementPage:
        return MaterialPageRoute(builder: (_) => PatientManagementPage());

      case '/':
        // don't generate route on start-up
        return null;
    }
  }

  @override
  Future<void> navigateTo(String routeName,
      {bool shouldReplace = false, Object? arguments}) {
    if (shouldReplace) {
      return navigatorKey.currentState!
          .pushReplacementNamed(routeName, arguments: arguments);
    }
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  @override
  Future<void> navigateBackUntil(String untilRoute, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        untilRoute, (Route<dynamic> route) => false,
        arguments: arguments);
  }

  @override
  void navigateBack() {
    return navigatorKey.currentState!.pop();
  }

  @override
  void popUntil(String popUntilRoute) {
    return navigatorKey.currentState!
        .popUntil(ModalRoute.withName(popUntilRoute));
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => super.navigatorKey;
}

abstract class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String homepage = '/home';
  static const String patientsManagementPage = '/patientManagementPage';

  Future<void> navigateTo(String routeName,
      {bool shouldReplace = false, Object? arguments});

  Future<void> navigateBackUntil(String untilRoute, {Object? arguments});

  void popUntil(String popUntilRoute);

  void navigateBack();
}