import 'package:dentalApp/app/home/presentation/homeView.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/addEditPatientView.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientAdditionalImages/patientImagesView.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientInformationView.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/addEditProcedure/addEditProcedureView.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/patientProcedureView.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/viewProcedure/viewProcedureView.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientManagementView.dart';
import 'package:flutter/material.dart';

class AppNavigationService extends NavigationService {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationService.homepage:
        return MaterialPageRoute(builder: (_) => HomePage());

      case NavigationService.patientsManagementPage:
        return MaterialPageRoute(builder: (_) => PatientManagementPage());

      case NavigationService.addEditPatientPage:
        return MaterialPageRoute(
            builder: (_) => AddEditPatientPage(
                settings.arguments as AddEditPatientPageParams));

      case NavigationService.patientInformationPage:
        return MaterialPageRoute(
            builder: (_) => PatientInformationPage(
                settings.arguments as PatientInformationPageParams));

      case NavigationService.patientProcedurePage:
        return MaterialPageRoute(
            builder: (_) =>
                PatientProcedurePage(patientId: settings.arguments as String));

      case NavigationService.addEditPatientProcedure:
        return MaterialPageRoute(
            builder: (_) => AddEditProcedurePage(
                params: settings.arguments as AddEditProcedurePageParams));

      case NavigationService.viewPatientProcedureInformation:
        return MaterialPageRoute(
            builder: (_) => ViewProcedurePage(
                settings.arguments as ViewProcedurePageParams));

      case NavigationService.viewAdditionalImages:
        return MaterialPageRoute(
            builder: (_) =>
                PatientImagePage(settings.arguments as PatientImagePageParams));

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
  Future<void> navigateBackUntilAndPush(String newRoute, String untilRoute,
      {Object? argument}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        newRoute, (route) => route.settings.name == untilRoute,
        arguments: argument);
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
  static const String addEditPatientPage = '/addEditPatientPage';

  static const String patientInformationPage = '/patientInformationPage';

  static const String patientProcedurePage = '/patientProcedures';

  static const String addEditPatientProcedure = '/addEditatientProcedure';

  static const String viewPatientProcedureInformation =
      '/patientProcedureInformationPage';

  static const String viewAdditionalImages = '/viewAdditionalImages';

  Future<void> navigateTo(String routeName,
      {bool shouldReplace = false, Object? arguments});

  Future<void> navigateBackUntil(String untilRoute, {Object? arguments});

  Future<void> navigateBackUntilAndPush(String newRoute, String untilRoute,
      {Object? argument});

  void popUntil(String popUntilRoute);

  void navigateBack();
}
