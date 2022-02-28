import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/patientProcedurePresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/patientProcedureStateMachine.dart';
import 'package:dentalApp/core/injectionContainer.dart';
import 'package:dentalApp/core/navigationService.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientProcedureController extends Controller {
  final PatientProcedurePresenter _presenter;
  final NavigationService _navigationService;

  final PatientProcedureStateMachine _stateMachine =
      PatientProcedureStateMachine();

  PatientProcedureController()
      : _presenter = serviceLocator<PatientProcedurePresenter>(),
        _navigationService = serviceLocator<NavigationService>(),
        super();

  @override
  void initListeners() {}

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  PatientProcedureState? getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  void initializePage({required String patientId}) {
    _presenter.fetchAllProceduresForPatients(
        UseCaseObserver(() {}, (error) {
          _stateMachine.onEvent(PatientProcedureErrorEvent());
          refreshUI();
        }, onNextFunc: (List<PatientProcedureEnity> patientProcedures) {
          _stateMachine
              .onEvent(PatientProcedureInitializedEvent(patientProcedures));
          refreshUI();
        }),
        patientId: patientId);
  }
}
