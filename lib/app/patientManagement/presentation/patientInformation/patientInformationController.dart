import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/addEditPatientView.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientInformationPresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientInformationStateMachine.dart';
import 'package:dentalApp/core/injectionContainer.dart';
import 'package:dentalApp/core/navigationService.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientInformationController extends Controller {
  final PatientInformationPresenter _presenter;
  final NavigationService _navigationService;

  final PatientInformationStateMachine _stateMachine =
      PatientInformationStateMachine();

  PatientInformationController()
      : _presenter = serviceLocator<PatientInformationPresenter>(),
        _navigationService = serviceLocator<NavigationService>(),
        super();

  @override
  void initListeners() {}

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  PatientInformationState? getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  void fetchPatientData(String patientId) {
    _presenter.getPatientData(
        UseCaseObserver(() {}, (error) {
          _stateMachine.onEvent(PatientInformationErrorEvent());
          refreshUI();
        }, onNextFunc: (PatientInformation patientInformation) {
          _stateMachine
              .onEvent(PatientInformationInitializedEvent(patientInformation));
          refreshUI();
        }),
        patientId);
  }

  void navigateBack() {
    _navigationService.navigateBack();
  }

  void navigateToPatientProcedurePage({required String patientId}) {
    _navigationService.navigateTo(NavigationService.patientProcedurePage,
        arguments: patientId);
  }

  void navigateToEditPatientPage(
      Function reloadPatientMetaPageOnPatientInformationEdition,
      String patientId) {
    _navigationService.navigateTo(NavigationService.addEditPatientPage,
        shouldReplace: false,
        arguments: AddEditPatientPageParams(
            reloadPatientsMetaPageOnSuccessFullPatientAdditionOrEdition:
                reloadPatientMetaPageOnPatientInformationEdition,
            inEditMode: true,
            patientId: patientId));
  }
}
