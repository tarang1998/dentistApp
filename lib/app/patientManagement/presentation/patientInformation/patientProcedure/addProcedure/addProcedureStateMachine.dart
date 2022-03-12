import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/teethChart.dart';
import 'package:dentalApp/core/presentation/stateMachine.dart';

class AddProcedureStateMachine
    extends StateMachine<AddProcedureState?, AddProcedureEvent> {
  AddProcedureStateMachine() : super(AddProcedureInitializationState());

  @override
  AddProcedureState? getStateOnEvent(AddProcedureEvent event) {
    final eventType = event.runtimeType;
    AddProcedureState? newState = getCurrentState();
    switch (eventType) {
      case AddProcedureInitializedEvent:
        AddProcedureInitializedEvent initializedEvent =
            event as AddProcedureInitializedEvent;
        DateTime dob = initializedEvent.patientInformation
            .patientPersonalInformation.patientMetaInformation.dob;
        int age = DateTime.now().year - dob.year;
        TeethChartType teethChartType =
            (age >= 18) ? TeethChartType.ADULT : TeethChartType.CHILD;

        newState = AddProcedureInitializedState(
            patientId: initializedEvent.patientInformation
                .patientPersonalInformation.patientMetaInformation.patientId,
            procedurePerformed: null,
            teethChartType: teethChartType,
            selectedAdultTeeth: [],
            selectedChildTeeth: [],
            procedurePerformedAt: DateTime.now(),
            nextVisitAt: DateTime.now());
        break;

      case ProcedurePerformedInputEvent:
        ProcedurePerformedInputEvent inputEvent =
            event as ProcedurePerformedInputEvent;
        newState = AddProcedureInitializedState.clone(
            newState as AddProcedureInitializedState,
            procedurePerformed: inputEvent.procedurePerformed);
        break;

      case AddProcedureTeethChartTypeInputEvent:
        AddProcedureTeethChartTypeInputEvent inputEvent =
            event as AddProcedureTeethChartTypeInputEvent;
        newState = AddProcedureInitializedState.clone(
            newState as AddProcedureInitializedState,
            teethChartType: inputEvent.teethChartType);
        break;

      case AddProcedureAdultToothSelectionInputEvent:
        AddProcedureAdultToothSelectionInputEvent
            adultToothSelectionInputEvent =
            event as AddProcedureAdultToothSelectionInputEvent;
        AddProcedureInitializedState initializedState =
            newState as AddProcedureInitializedState;
        List<AdultTeethType> selectedAdultTeeth = newState.selectedAdultTeeth;

        if (selectedAdultTeeth
            .contains(adultToothSelectionInputEvent.adultTooth)) {
          selectedAdultTeeth.remove(adultToothSelectionInputEvent.adultTooth);
        } else {
          selectedAdultTeeth.add(adultToothSelectionInputEvent.adultTooth);
        }

        newState = AddProcedureInitializedState.clone(initializedState,
            selectedAdultTeeth: selectedAdultTeeth);
        break;

      case AddProcedureChildToothSelectionInputEvent:
        AddProcedureChildToothSelectionInputEvent
            childToothSelectionInputEvent =
            event as AddProcedureChildToothSelectionInputEvent;
        AddProcedureInitializedState initializedState =
            newState as AddProcedureInitializedState;
        List<ChildTeethType> selectedChildTeeth = newState.selectedChildTeeth;

        if (selectedChildTeeth
            .contains(childToothSelectionInputEvent.childTooth)) {
          selectedChildTeeth.remove(childToothSelectionInputEvent.childTooth);
        } else {
          selectedChildTeeth.add(childToothSelectionInputEvent.childTooth);
        }
        newState = AddProcedureInitializedState.clone(initializedState,
            selectedChildTeeth: selectedChildTeeth);
        break;

      case AddProcedureProcedurePerformedAtInputEvent:
        AddProcedureProcedurePerformedAtInputEvent inputEvent =
            event as AddProcedureProcedurePerformedAtInputEvent;
        newState = AddProcedureInitializedState.clone(
            newState as AddProcedureInitializedState,
            procedurePerformedAt: inputEvent.procedurePerformedAt);
        break;

      case AddProcedureNextVisitInputEvent:
        AddProcedureNextVisitInputEvent inputEvent =
            event as AddProcedureNextVisitInputEvent;
        newState = AddProcedureInitializedState.clone(
            newState as AddProcedureInitializedState,
            nextVisitAt: inputEvent.nextVisitAt);
        break;

      case AddProcedureErrorEvent:
        newState = AddProcedureErrorState();
        break;
    }
    return newState;
  }
}

abstract class AddProcedureEvent {}

class AddProcedureErrorEvent extends AddProcedureEvent {
  AddProcedureErrorEvent();
}

class AddProcedureInitializedEvent extends AddProcedureEvent {
  final PatientInformation patientInformation;
  AddProcedureInitializedEvent({required this.patientInformation});
}

class AddProcedureLoadingEvent extends AddProcedureEvent {}

class ProcedurePerformedInputEvent extends AddProcedureEvent {
  final Procedure procedurePerformed;
  ProcedurePerformedInputEvent({required this.procedurePerformed});
}

class AddProcedureTeethChartTypeInputEvent extends AddProcedureEvent {
  final TeethChartType teethChartType;
  AddProcedureTeethChartTypeInputEvent({required this.teethChartType});
}

class AddProcedureAdultToothSelectionInputEvent extends AddProcedureEvent {
  final AdultTeethType adultTooth;
  AddProcedureAdultToothSelectionInputEvent({required this.adultTooth});
}

class AddProcedureChildToothSelectionInputEvent extends AddProcedureEvent {
  final ChildTeethType childTooth;
  AddProcedureChildToothSelectionInputEvent({required this.childTooth});
}

class AddProcedureProcedurePerformedAtInputEvent extends AddProcedureEvent {
  final DateTime procedurePerformedAt;
  AddProcedureProcedurePerformedAtInputEvent(
      {required this.procedurePerformedAt});
}

class AddProcedureNextVisitInputEvent extends AddProcedureEvent {
  final DateTime nextVisitAt;
  AddProcedureNextVisitInputEvent({required this.nextVisitAt});
}

abstract class AddProcedureState {}

class AddProcedureLoadingState implements AddProcedureState {}

class AddProcedureInitializationState implements AddProcedureState {}

class AddProcedureInitializedState implements AddProcedureState {
  final String patientId;
  final Procedure? procedurePerformed;
  final TeethChartType teethChartType;
  final List<AdultTeethType> selectedAdultTeeth;
  final List<ChildTeethType> selectedChildTeeth;
  final DateTime procedurePerformedAt;
  final DateTime nextVisitAt;
  AddProcedureInitializedState(
      {required this.patientId,
      required this.procedurePerformed,
      required this.teethChartType,
      required this.selectedAdultTeeth,
      required this.selectedChildTeeth,
      required this.procedurePerformedAt,
      required this.nextVisitAt});

  AddProcedureInitializedState.clone(
    AddProcedureInitializedState prevState, {
    Procedure? procedurePerformed,
    TeethChartType? teethChartType,
    List<AdultTeethType>? selectedAdultTeeth,
    List<ChildTeethType>? selectedChildTeeth,
    DateTime? procedurePerformedAt,
    DateTime? nextVisitAt,
  }) : this(
            patientId: prevState.patientId,
            procedurePerformed:
                procedurePerformed ?? prevState.procedurePerformed,
            teethChartType: teethChartType ?? prevState.teethChartType,
            selectedAdultTeeth:
                selectedAdultTeeth ?? prevState.selectedAdultTeeth,
            selectedChildTeeth:
                selectedChildTeeth ?? prevState.selectedChildTeeth,
            procedurePerformedAt:
                procedurePerformedAt ?? prevState.procedurePerformedAt,
            nextVisitAt: nextVisitAt ?? prevState.nextVisitAt);
}

class AddProcedureErrorState implements AddProcedureState {}
