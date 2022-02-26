import 'package:dentist_app/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentist_app/app/patientManagement/presentation/patientInformation/patientInformationView.dart';
import 'package:dentist_app/app/patientManagement/presentation/patientManagementPresenter.dart';
import 'package:dentist_app/app/patientManagement/presentation/patientManagementStateMachine.dart';
import 'package:dentist_app/core/injectionContainer.dart';
import 'package:dentist_app/core/navigationService.dart';
import 'package:dentist_app/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientManagementController extends Controller {
  final PatientManagementPresenter _presenter;
  final NavigationService _navigationService;

  final PatientManagementStateMachine _stateMachine =
      PatientManagementStateMachine();

  PatientManagementController()
      : _presenter = serviceLocator<PatientManagementPresenter>(),
        _navigationService = serviceLocator<NavigationService>(),
        super();

  @override
  void initListeners() {}

  PatientManagementState? getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  void fetchPatientsMeta() {
    _presenter.getPatientsMetaInformation(UseCaseObserver(() {}, (error) {
      _stateMachine.onEvent(PatientManagementErrorEvent());
      refreshUI();
    }, onNextFunc: (List<PatientMetaInformation> patientMetaInformation) {
      _stateMachine
          .onEvent(PatientManagementInitializedEvent(patientMetaInformation));
      refreshUI();
    }));
  }

  void navigateToPatientInformationPage({required String patientId}) {
    _navigationService.navigateTo(NavigationService.patientInformationPage,
        shouldReplace: false,
        arguments: PatientInformationPageParams(patientId));
  }
}
