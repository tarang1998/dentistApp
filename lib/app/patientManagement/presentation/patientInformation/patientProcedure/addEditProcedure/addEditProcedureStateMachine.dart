import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/teethChart.dart';
import 'package:dentalApp/core/presentation/stateMachine.dart';
import 'package:flutter/material.dart';

class AddEditProcedureStateMachine
    extends StateMachine<AddEditProcedureState?, AddEditProcedureEvent> {
  AddEditProcedureStateMachine() : super(AddEditProcedureInitializationState());

  @override
  AddEditProcedureState? getStateOnEvent(AddEditProcedureEvent event) {
    final eventType = event.runtimeType;
    AddEditProcedureState? newState = getCurrentState();
    switch (eventType) {
      case AddEditProcedureInitializedEvent:
        AddEditProcedureInitializedEvent initializedEvent =
            event as AddEditProcedureInitializedEvent;

        newState = AddEditProcedureInitializedState(
            patientId: initializedEvent.patientId,
            diagnosis: initializedEvent.diagnosis,
            procedurePerformed: initializedEvent.procedurePerformed,
            teethChartType: initializedEvent.teethChartType,
            selectedAdultTeeth: initializedEvent.selectedAdultTeeth,
            selectedChildTeeth: initializedEvent.selectedChildTeeth,
            procedurePerformedAt: initializedEvent.procedurePerformedAt,
            procedurePerformedAtTime: initializedEvent.procedurePerformedAtTime,
            nextVisitAt: initializedEvent.nextVisitAt,
            nextVisitAtTime: initializedEvent.nextVisitAtTime);
        break;

      case ProcedurePerformedInputEvent:
        ProcedurePerformedInputEvent inputEvent =
            event as ProcedurePerformedInputEvent;
        newState = AddEditProcedureInitializedState.clone(
            newState as AddEditProcedureInitializedState,
            procedurePerformed: inputEvent.procedurePerformed);
        break;

      case DiagnosisInputEvent:
        DiagnosisInputEvent inputEvent = event as DiagnosisInputEvent;
        newState = AddEditProcedureInitializedState.clone(
            newState as AddEditProcedureInitializedState,
            diagnosis: inputEvent.diagnosis);
        break;

      case AddEditProcedureTeethChartTypeInputEvent:
        AddEditProcedureTeethChartTypeInputEvent inputEvent =
            event as AddEditProcedureTeethChartTypeInputEvent;
        newState = AddEditProcedureInitializedState.clone(
            newState as AddEditProcedureInitializedState,
            teethChartType: inputEvent.teethChartType);
        break;

      case AddEditProcedureAdultToothSelectionInputEvent:
        AddEditProcedureAdultToothSelectionInputEvent
            adultToothSelectionInputEvent =
            event as AddEditProcedureAdultToothSelectionInputEvent;
        AddEditProcedureInitializedState initializedState =
            newState as AddEditProcedureInitializedState;
        List<AdultTeethType> selectedAdultTeeth = newState.selectedAdultTeeth;

        if (selectedAdultTeeth
            .contains(adultToothSelectionInputEvent.adultTooth)) {
          selectedAdultTeeth.remove(adultToothSelectionInputEvent.adultTooth);
        } else {
          selectedAdultTeeth.add(adultToothSelectionInputEvent.adultTooth);
        }

        newState = AddEditProcedureInitializedState.clone(initializedState,
            selectedAdultTeeth: selectedAdultTeeth);
        break;

      case AddEditProcedureChildToothSelectionInputEvent:
        AddEditProcedureChildToothSelectionInputEvent
            childToothSelectionInputEvent =
            event as AddEditProcedureChildToothSelectionInputEvent;
        AddEditProcedureInitializedState initializedState =
            newState as AddEditProcedureInitializedState;
        List<ChildTeethType> selectedChildTeeth = newState.selectedChildTeeth;

        if (selectedChildTeeth
            .contains(childToothSelectionInputEvent.childTooth)) {
          selectedChildTeeth.remove(childToothSelectionInputEvent.childTooth);
        } else {
          selectedChildTeeth.add(childToothSelectionInputEvent.childTooth);
        }
        newState = AddEditProcedureInitializedState.clone(initializedState,
            selectedChildTeeth: selectedChildTeeth);
        break;

      case AddEditProcedureProcedurePerformedAtInputEvent:
        AddEditProcedureProcedurePerformedAtInputEvent inputEvent =
            event as AddEditProcedureProcedurePerformedAtInputEvent;
        newState = AddEditProcedureInitializedState.clone(
            newState as AddEditProcedureInitializedState,
            procedurePerformedAt: inputEvent.procedurePerformedAt);
        break;

      case AddEditProcedurePerformedAtTimeInputEvent:
        AddEditProcedurePerformedAtTimeInputEvent
            addEditProcedurePerformedAtTimeInputEvent =
            event as AddEditProcedurePerformedAtTimeInputEvent;
        newState = AddEditProcedureInitializedState.clone(
            newState as AddEditProcedureInitializedState,
            procedurePerformedAtTime: addEditProcedurePerformedAtTimeInputEvent
                .procedurePerformedAtTime);
        break;

      case AddEditProcedureNextVisitInputEvent:
        AddEditProcedureNextVisitInputEvent inputEvent =
            event as AddEditProcedureNextVisitInputEvent;
        newState = AddEditProcedureInitializedState.clone(
            newState as AddEditProcedureInitializedState,
            nextVisitAt: inputEvent.nextVisitAt);
        break;

      case AddEditProcedureNextVisitAtTimeInputEvent:
        AddEditProcedureNextVisitAtTimeInputEvent inputEvent =
            event as AddEditProcedureNextVisitAtTimeInputEvent;
        newState = AddEditProcedureInitializedState.clone(
            newState as AddEditProcedureInitializedState,
            nextVisitAtTime: inputEvent.nextVisitAtTime);
        break;

      case AddEditProcedureErrorEvent:
        newState = AddEditProcedureErrorState();
        break;
    }
    return newState;
  }
}

abstract class AddEditProcedureEvent {}

class AddEditProcedureErrorEvent extends AddEditProcedureEvent {
  AddEditProcedureErrorEvent();
}

class AddEditProcedureInitializedEvent extends AddEditProcedureEvent {
  final String patientId;
  final Diagnosis? diagnosis;
  final Procedure? procedurePerformed;
  final TeethChartType teethChartType;
  final List<AdultTeethType> selectedAdultTeeth;
  final List<ChildTeethType> selectedChildTeeth;
  final DateTime procedurePerformedAt;
  final TimeOfDay procedurePerformedAtTime;
  final DateTime nextVisitAt;
  final TimeOfDay nextVisitAtTime;

  AddEditProcedureInitializedEvent(
      {required this.patientId,
      required this.diagnosis,
      required this.procedurePerformed,
      required this.teethChartType,
      required this.selectedAdultTeeth,
      required this.selectedChildTeeth,
      required this.procedurePerformedAt,
      required this.procedurePerformedAtTime,
      required this.nextVisitAt,
      required this.nextVisitAtTime});
}

class AddEditProcedureLoadingEvent extends AddEditProcedureEvent {}

class DiagnosisInputEvent extends AddEditProcedureEvent {
  final Diagnosis diagnosis;
  DiagnosisInputEvent({required this.diagnosis});
}

class ProcedurePerformedInputEvent extends AddEditProcedureEvent {
  final Procedure procedurePerformed;
  ProcedurePerformedInputEvent({required this.procedurePerformed});
}

class AddEditProcedureTeethChartTypeInputEvent extends AddEditProcedureEvent {
  final TeethChartType teethChartType;
  AddEditProcedureTeethChartTypeInputEvent({required this.teethChartType});
}

class AddEditProcedureAdultToothSelectionInputEvent
    extends AddEditProcedureEvent {
  final AdultTeethType adultTooth;
  AddEditProcedureAdultToothSelectionInputEvent({required this.adultTooth});
}

class AddEditProcedureChildToothSelectionInputEvent
    extends AddEditProcedureEvent {
  final ChildTeethType childTooth;
  AddEditProcedureChildToothSelectionInputEvent({required this.childTooth});
}

class AddEditProcedureProcedurePerformedAtInputEvent
    extends AddEditProcedureEvent {
  final DateTime procedurePerformedAt;
  AddEditProcedureProcedurePerformedAtInputEvent(
      {required this.procedurePerformedAt});
}

class AddEditProcedurePerformedAtTimeInputEvent extends AddEditProcedureEvent {
  final TimeOfDay procedurePerformedAtTime;
  AddEditProcedurePerformedAtTimeInputEvent(
      {required this.procedurePerformedAtTime});
}

class AddEditProcedureNextVisitInputEvent extends AddEditProcedureEvent {
  final DateTime nextVisitAt;
  AddEditProcedureNextVisitInputEvent({required this.nextVisitAt});
}

class AddEditProcedureNextVisitAtTimeInputEvent extends AddEditProcedureEvent {
  final TimeOfDay nextVisitAtTime;
  AddEditProcedureNextVisitAtTimeInputEvent({required this.nextVisitAtTime});
}

abstract class AddEditProcedureState {}

class AddEditProcedureLoadingState implements AddEditProcedureState {}

class AddEditProcedureInitializationState implements AddEditProcedureState {}

class AddEditProcedureInitializedState implements AddEditProcedureState {
  final String patientId;
  final Diagnosis? diagnosis;
  final Procedure? procedurePerformed;
  final TeethChartType teethChartType;
  final List<AdultTeethType> selectedAdultTeeth;
  final List<ChildTeethType> selectedChildTeeth;
  final DateTime procedurePerformedAt;
  final TimeOfDay procedurePerformedAtTime;
  final DateTime nextVisitAt;
  final TimeOfDay nextVisitAtTime;

  AddEditProcedureInitializedState(
      {required this.patientId,
      required this.diagnosis,
      required this.procedurePerformed,
      required this.teethChartType,
      required this.selectedAdultTeeth,
      required this.selectedChildTeeth,
      required this.procedurePerformedAt,
      required this.procedurePerformedAtTime,
      required this.nextVisitAt,
      required this.nextVisitAtTime});

  AddEditProcedureInitializedState.clone(
      AddEditProcedureInitializedState prevState,
      {Diagnosis? diagnosis,
      Procedure? procedurePerformed,
      TeethChartType? teethChartType,
      List<AdultTeethType>? selectedAdultTeeth,
      List<ChildTeethType>? selectedChildTeeth,
      DateTime? procedurePerformedAt,
      TimeOfDay? procedurePerformedAtTime,
      DateTime? nextVisitAt,
      TimeOfDay? nextVisitAtTime})
      : this(
            patientId: prevState.patientId,
            diagnosis: diagnosis ?? prevState.diagnosis,
            procedurePerformed:
                procedurePerformed ?? prevState.procedurePerformed,
            teethChartType: teethChartType ?? prevState.teethChartType,
            selectedAdultTeeth:
                selectedAdultTeeth ?? prevState.selectedAdultTeeth,
            selectedChildTeeth:
                selectedChildTeeth ?? prevState.selectedChildTeeth,
            procedurePerformedAt:
                procedurePerformedAt ?? prevState.procedurePerformedAt,
            procedurePerformedAtTime:
                procedurePerformedAtTime ?? prevState.procedurePerformedAtTime,
            nextVisitAt: nextVisitAt ?? prevState.nextVisitAt,
            nextVisitAtTime: nextVisitAtTime ?? prevState.nextVisitAtTime);
}

class AddEditProcedureErrorState implements AddEditProcedureState {}
