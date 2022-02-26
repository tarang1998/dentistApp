import 'package:dentist_app/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentist_app/app/patientManagement/presentation/patientInformation/patientInformationPresenter.dart';
import 'package:dentist_app/app/patientManagement/presentation/patientInformation/patientInformationStateMachine.dart';
import 'package:dentist_app/core/injectionContainer.dart';
import 'package:dentist_app/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientInformationController extends Controller {
  final PatientInformationPresenter _presenter;

  final PatientInformationStateMachine _stateMachine =
      PatientInformationStateMachine();

  PatientInformationController()
      : _presenter = serviceLocator<PatientInformationPresenter>(),
        super();

  @override
  void initListeners() {}

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
}
