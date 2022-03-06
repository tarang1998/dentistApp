import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/teethChart.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/addProcedure/addProcedurePresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/addProcedure/addProcedureStateMachine.dart';
import 'package:dentalApp/core/injectionContainer.dart';
import 'package:dentalApp/core/navigationService.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddProcedureController extends Controller {
  final AddProcedurePresenter _presenter;
  final NavigationService _navigationService;

  final AddProcedureStateMachine _stateMachine = AddProcedureStateMachine();

  final TextEditingController estimatedAmountTextEditingController =
      TextEditingController();
  final TextEditingController paidAmountTextEditingController =
      TextEditingController();
  final TextEditingController additionalRemarksTextEditingController =
      TextEditingController();

  AddProcedureController()
      : _presenter = serviceLocator<AddProcedurePresenter>(),
        _navigationService = serviceLocator<NavigationService>(),
        super();

  @override
  void initListeners() {}

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  AddProcedureState? getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  void initializePage({required String patientId}) {
    _presenter.getPatientInformation(
        UseCaseObserver(() {}, (error) {
          _stateMachine.onEvent(AddProcedureErrorEvent());
          refreshUI();
        }, onNextFunc: (PatientInformation patientInformation) {
          _stateMachine.onEvent(AddProcedureInitializedEvent(
              patientInformation: patientInformation));
          refreshUI();
        }),
        patientId: patientId);
  }

  void navigateBack() {
    _navigationService.navigateBack();
  }

  void handleProcedurePerformedAtInput(
      {required DateTime procedurePerformedAt}) {
    _stateMachine.onEvent(AddProcedureProcedurePerformedAtInputEvent(
        procedurePerformedAt: procedurePerformedAt));
    refreshUI();
  }

  void handleNextVisitInput({required DateTime nextVisitAt}) {
    _stateMachine
        .onEvent(AddProcedureNextVisitInputEvent(nextVisitAt: nextVisitAt));
    refreshUI();
  }

  void handleProcedurePerformedInputEvent(Procedure? procedurePerformed) {
    if (procedurePerformed != null) {
      _stateMachine.onEvent(
          ProcedurePerformedInputEvent(procedurePerformed: procedurePerformed));
      refreshUI();
    }
  }

  void handleTeethChartTypeInputEvent(TeethChartType? teethChartType) {
    if (teethChartType != null) {
      _stateMachine.onEvent(
          AddProcedureTeethChartTypeInputEvent(teethChartType: teethChartType));
      refreshUI();
    }
  }

  void handleAdultToothSelectionInputEvent(AdultTeethType adultToothType) {
    _stateMachine.onEvent(
        AddProcedureAdultToothSelectionInputEvent(adultTooth: adultToothType));
    refreshUI();
  }

  void handleChildToothSelectionInputEvent(ChildTeethType childToothType) {
    _stateMachine.onEvent(
        AddProcedureChildToothSelectionInputEvent(childTooth: childToothType));
    refreshUI();
  }

  void addProcedure(
      {required String patientId,
      required Procedure? procedurePerformed,
      required TeethChartType teethChartType,
      required List<AdultTeethType> selectedAdultTeeth,
      required List<ChildTeethType> selectedChildTeeth,
      required DateTime procedurePerformedAt,
      required DateTime nextVisitAt,
      required Function
          reloadPatientProceduresPageOnSuccessfullProcedureAddition}) async {
    _stateMachine.onEvent(AddProcedureLoadingEvent());
    refreshUI();

    if (procedurePerformed == null) {
      Fluttertoast.showToast(msg: 'Please select a procedure');
      return;
    }
    if (estimatedAmountTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter an estimated amount ');
      return;
    }
    if (paidAmountTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter the paid amount');
      return;
    }

    if (teethChartType == TeethChartType.ADULT) {
      if (selectedAdultTeeth.isEmpty) {
        Fluttertoast.showToast(
            msg: 'Please select values from the teeth chart');
        return;
      }
    }

    if (teethChartType == TeethChartType.CHILD) {
      if (selectedChildTeeth.isEmpty) {
        //TODO : Add validation for selected child teeth values

      }
    }

    _presenter.addPatientProcedure(
        UseCaseObserver(() {
          reloadPatientProceduresPageOnSuccessfullProcedureAddition(patientId);
          _navigationService.navigateBack();
        }, (error) {
          _stateMachine.onEvent(AddProcedureErrorEvent());
          refreshUI();
        }),
        patientId: patientId,
        patientProcedureEntity: PatientProcedureEnity(
            procedureId: '',
            procedurePerformed: procedurePerformed,
            estimatedCost: int.parse(estimatedAmountTextEditingController.text),
            amountPaid: int.parse(paidAmountTextEditingController.text),
            performedAt: procedurePerformedAt,
            nextVisit: nextVisitAt,
            additionalRemarks: additionalRemarksTextEditingController.text,
            selectedTeethChart: (teethChartType == TeethChartType.ADULT)
                ? AdultTeethChart(selectedValues: selectedAdultTeeth)
                : ChildTeethChart(selectedValues: selectedChildTeeth)));
  }
}
