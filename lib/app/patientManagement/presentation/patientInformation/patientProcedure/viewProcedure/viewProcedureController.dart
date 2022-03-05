import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/viewProcedure/viewProcedurePresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/viewProcedure/viewProcedureStateMachine.dart';
import 'package:dentalApp/core/injectionContainer.dart';
import 'package:dentalApp/core/navigationService.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ViewProcedureController extends Controller {
  final ViewProcedurePresenter _presenter;
  final NavigationService _navigationService;

  final ViewProcedureStateMachine _stateMachine = ViewProcedureStateMachine();

  ViewProcedureController()
      : _presenter = serviceLocator<ViewProcedurePresenter>(),
        _navigationService = serviceLocator<NavigationService>(),
        super();

  @override
  void initListeners() {}

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  ViewProcedureState? getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  void getPatientProcedureInformation(
      {required String patientId, required String procedureId}) {
    _presenter.getPatientProcedureInformation(
        UseCaseObserver(() {}, (error) {
          _stateMachine.onEvent(ViewProcedureErrorEvent());
          refreshUI();
        }, onNextFunc: (PatientProcedureEnity patientProcedureEnity) {
          _stateMachine.onEvent(
              ViewProcedureInitializedEvent(patientId, patientProcedureEnity));
          refreshUI();
        }),
        patientId: patientId,
        patientProcedureId: procedureId);
  }
}
