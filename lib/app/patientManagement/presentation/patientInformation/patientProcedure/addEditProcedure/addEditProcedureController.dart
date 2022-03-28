import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/teethChart.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/addEditProcedure/addEditProcedurePresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/addEditProcedure/addEditProcedureStateMachine.dart';
import 'package:dentalApp/core/injectionContainer.dart';
import 'package:dentalApp/core/navigationService.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddEditProcedureController extends Controller {
  final AddEditProcedurePresenter _presenter;
  final NavigationService _navigationService;

  final AddEditProcedureStateMachine _stateMachine =
      AddEditProcedureStateMachine();

  final TextEditingController estimatedAmountTextEditingController =
      TextEditingController();
  final TextEditingController paidAmountTextEditingController =
      TextEditingController();
  final TextEditingController additionalRemarksTextEditingController =
      TextEditingController();

  AddEditProcedureController()
      : _presenter = serviceLocator<AddEditProcedurePresenter>(),
        _navigationService = serviceLocator<NavigationService>(),
        super();

  @override
  void initListeners() {}

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  AddEditProcedureState? getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  void initializePage(
      {required bool isInEditMode,
      required String patientId,
      String? procedureId}) {
    if (isInEditMode) {
      _presenter.getPatientProcedureInformationUsecase(
          UseCaseObserver(() {}, (error) {
            _stateMachine.onEvent(AddEditProcedureErrorEvent());
            refreshUI();
          }, onNextFunc: (PatientProcedureEnity patientProcedureEnity) {
            estimatedAmountTextEditingController.text =
                patientProcedureEnity.estimatedCost.toString();
            paidAmountTextEditingController.text =
                patientProcedureEnity.amountPaid.toString();
            additionalRemarksTextEditingController.text =
                patientProcedureEnity.additionalRemarks.toString();

            _stateMachine.onEvent(AddEditProcedureInitializedEvent(
                patientId: patientId,
                diagnosis: patientProcedureEnity.diagnosis,
                procedurePerformed: patientProcedureEnity.procedurePerformed,
                teethChartType:
                    patientProcedureEnity.selectedTeethChart is AdultTeethChart
                        ? TeethChartType.ADULT
                        : TeethChartType.CHILD,
                selectedAdultTeeth:
                    patientProcedureEnity.selectedTeethChart is AdultTeethChart
                        ? (patientProcedureEnity.selectedTeethChart
                                as AdultTeethChart)
                            .selectedValues
                        : [],
                selectedChildTeeth:
                    patientProcedureEnity.selectedTeethChart is ChildTeethChart
                        ? (patientProcedureEnity.selectedTeethChart
                                as ChildTeethChart)
                            .selectedValues
                        : [],
                procedurePerformedAt: patientProcedureEnity.performedAt,
                procedurePerformedAtTime:
                    TimeOfDay.fromDateTime(patientProcedureEnity.performedAt),
                nextVisitAt: patientProcedureEnity.nextVisit,
                nextVisitAtTime:
                    TimeOfDay.fromDateTime(patientProcedureEnity.nextVisit)));
            refreshUI();
          }),
          patientId: patientId,
          procedureId: procedureId!);
    } else {
      _presenter.getPatientInformation(
          UseCaseObserver(() {}, (error) {
            _stateMachine.onEvent(AddEditProcedureErrorEvent());
            refreshUI();
          }, onNextFunc: (PatientInformation patientInformation) {
            DateTime dob = patientInformation
                .patientPersonalInformation.patientMetaInformation.dob;
            int age = DateTime.now().year - dob.year;
            TeethChartType teethChartType =
                (age >= 18) ? TeethChartType.ADULT : TeethChartType.CHILD;

            _stateMachine.onEvent(AddEditProcedureInitializedEvent(
                patientId: patientId,
                diagnosis: null,
                procedurePerformed: null,
                teethChartType: teethChartType,
                selectedAdultTeeth: [],
                selectedChildTeeth: [],
                procedurePerformedAt: DateTime.now(),
                procedurePerformedAtTime: TimeOfDay.now(),
                nextVisitAt: DateTime.now(),
                nextVisitAtTime: TimeOfDay.now()));
            refreshUI();
          }),
          patientId: patientId);
    }
  }

  void navigateBack() {
    _navigationService.navigateBack();
  }

  void handleProcedurePerformedAtInput(
      {required DateTime procedurePerformedAt}) {
    _stateMachine.onEvent(AddEditProcedureProcedurePerformedAtInputEvent(
        procedurePerformedAt: procedurePerformedAt));
    refreshUI();
  }

  void handleProcedurePerformedAtTimeInputEvent(
      {required TimeOfDay procedurePerformedAtTime}) {
    _stateMachine.onEvent(AddEditProcedurePerformedAtTimeInputEvent(
        procedurePerformedAtTime: procedurePerformedAtTime));
    refreshUI();
  }

  void handleNextVisitInput({required DateTime nextVisitAt}) {
    _stateMachine
        .onEvent(AddEditProcedureNextVisitInputEvent(nextVisitAt: nextVisitAt));
    refreshUI();
  }

  void handleNextVisitAtTimeInputEvent({required TimeOfDay nextVisitAtTime}) {
    _stateMachine.onEvent(AddEditProcedureNextVisitAtTimeInputEvent(
        nextVisitAtTime: nextVisitAtTime));
    refreshUI();
  }

  void handleDiagnosisInputEvent(Diagnosis diagnosis) {
    _stateMachine.onEvent(DiagnosisInputEvent(diagnosis: diagnosis));
    refreshUI();
  }

  void handleProcedurePerformedInputEvent(Procedure procedurePerformed) {
    _stateMachine.onEvent(
        ProcedurePerformedInputEvent(procedurePerformed: procedurePerformed));
    refreshUI();
  }

  void handleTeethChartTypeInputEvent(TeethChartType teethChartType) {
    _stateMachine.onEvent(AddEditProcedureTeethChartTypeInputEvent(
        teethChartType: teethChartType));
    refreshUI();
  }

  void handleAdultToothSelectionInputEvent(AdultTeethType adultToothType) {
    _stateMachine.onEvent(AddEditProcedureAdultToothSelectionInputEvent(
        adultTooth: adultToothType));
    refreshUI();
  }

  void handleChildToothSelectionInputEvent(ChildTeethType childToothType) {
    _stateMachine.onEvent(AddEditProcedureChildToothSelectionInputEvent(
        childTooth: childToothType));
    refreshUI();
  }

  void addEditProcedure({
    required bool isInEditMode,
    required String patientId,
    required String? procedureId,
    required Diagnosis? diagnosis,
    required Procedure? procedurePerformed,
    required TeethChartType teethChartType,
    required List<AdultTeethType> selectedAdultTeeth,
    required List<ChildTeethType> selectedChildTeeth,
    required DateTime procedurePerformedAt,
    required TimeOfDay procedurePerformedAtTime,
    required DateTime nextVisitAt,
    required TimeOfDay nextVisitAtTime,
  }) async {
    _stateMachine.onEvent(AddEditProcedureLoadingEvent());
    refreshUI();

    if (procedurePerformed == null) {
      Fluttertoast.showToast(msg: 'Please select the procedure performed');
      return;
    }

    if (diagnosis == null) {
      Fluttertoast.showToast(msg: 'Please select the diagnosis done');
      return;
    }

    if (teethChartType == TeethChartType.ADULT) {
      if (selectedAdultTeeth.isEmpty) {
        Fluttertoast.showToast(
            msg: 'Please select options from the teeth chart');
        return;
      }
    }

    if (teethChartType == TeethChartType.CHILD) {
      if (selectedChildTeeth.isEmpty) {
        Fluttertoast.showToast(
            msg: 'Please select options from the teeth chart');
        return;
      }
    }

    if (isInEditMode) {
      _presenter.editPatientProcedure(
          UseCaseObserver(() async {
            await _navigationService.navigateBackUntilAndPush(
                NavigationService.patientProcedurePage,
                NavigationService.patientInformationPage,
                argument: patientId);
          }, (error) {
            _stateMachine.onEvent(AddEditProcedureErrorEvent());
            refreshUI();
          }),
          patientId: patientId,
          procedureId: procedureId!,
          patientProcedureEntity: PatientProcedureEnity(
              procedureId: procedureId,
              diagnosis: diagnosis,
              procedurePerformed: procedurePerformed,
              estimatedCost:
                  int.parse(estimatedAmountTextEditingController.text),
              amountPaid: int.parse(paidAmountTextEditingController.text),
              performedAt: DateTime(
                procedurePerformedAt.year,
                procedurePerformedAt.month,
                procedurePerformedAt.day,
                procedurePerformedAtTime.hour,
                procedurePerformedAtTime.minute,
              ),
              nextVisit: DateTime(
                nextVisitAt.year,
                nextVisitAt.month,
                nextVisitAt.day,
                nextVisitAtTime.hour,
                nextVisitAtTime.minute,
              ),
              additionalRemarks: additionalRemarksTextEditingController.text,
              selectedTeethChart: (teethChartType == TeethChartType.ADULT)
                  ? AdultTeethChart(selectedValues: selectedAdultTeeth)
                  : ChildTeethChart(selectedValues: selectedChildTeeth)));
    } else {
      _presenter.addPatientProcedure(
          UseCaseObserver(() async {
            await _navigationService.navigateBackUntilAndPush(
                NavigationService.patientProcedurePage,
                NavigationService.patientInformationPage,
                argument: patientId);
          }, (error) {
            _stateMachine.onEvent(AddEditProcedureErrorEvent());
            refreshUI();
          }),
          patientId: patientId,
          patientProcedureEntity: PatientProcedureEnity(
              procedureId: '',
              diagnosis: diagnosis,
              procedurePerformed: procedurePerformed,
              estimatedCost:
                  int.parse(estimatedAmountTextEditingController.text),
              amountPaid: int.parse(paidAmountTextEditingController.text),
              performedAt: DateTime(
                procedurePerformedAt.year,
                procedurePerformedAt.month,
                procedurePerformedAt.day,
                procedurePerformedAtTime.hour,
                procedurePerformedAtTime.minute,
              ),
              nextVisit: DateTime(
                nextVisitAt.year,
                nextVisitAt.month,
                nextVisitAt.day,
                nextVisitAtTime.hour,
                nextVisitAtTime.minute,
              ),
              additionalRemarks: additionalRemarksTextEditingController.text,
              selectedTeethChart: (teethChartType == TeethChartType.ADULT)
                  ? AdultTeethChart(selectedValues: selectedAdultTeeth)
                  : ChildTeethChart(selectedValues: selectedChildTeeth)));
    }
  }
}
