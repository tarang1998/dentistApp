import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/addEditProcedure/addEditProcedureView.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/patientProcedurePresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/patientProcedureStateMachine.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/viewProcedure/viewProcedureView.dart';
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

  //called on pull to refresh

  //called whenever the user enters the page
  void initializePage({required String patientId}) {
    _presenter.fetchAllProceduresForPatients(
        UseCaseObserver(() {}, (error) {
          _stateMachine.onEvent(PatientProcedureErrorEvent());
          refreshUI();
        }, onNextFunc: (List<PatientProcedureEnity> patientProcedures) {
          num totalEstimatedCost = 0;
          num totalAmountPaid = 0;

          patientProcedures.forEach((element) {
            totalEstimatedCost += element.estimatedCost;
            totalAmountPaid += element.amountPaid;
          });

          _stateMachine.onEvent(PatientProcedureInitializedEvent(patientId,
              patientProcedures, totalEstimatedCost, totalAmountPaid));
          refreshUI();
        }),
        patientId: patientId);
  }

  void navigateToAddProcedurePage({required String patientId}) {
    _navigationService.navigateTo(NavigationService.addEditPatientProcedure,
        arguments: AddEditProcedurePageParams(
          patientId: patientId,
          isInEditMode: false,
        ));
  }

  void navigateToViewPatientProcedureInformationPage(
      {required String patientId, required String patientProcedureId}) {
    _navigationService.navigateTo(
        NavigationService.viewPatientProcedureInformation,
        arguments: ViewProcedurePageParams(patientId, patientProcedureId));
  }

  void navigateBack() {
    _navigationService.navigateBack();
  }
}
