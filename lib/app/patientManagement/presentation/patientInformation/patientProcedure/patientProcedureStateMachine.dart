import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/core/presentation/stateMachine.dart';

class PatientProcedureStateMachine
    extends StateMachine<PatientProcedureState?, PatientProcedureEvent> {
  PatientProcedureStateMachine() : super(PatientProcedureInitializationState());

  @override
  PatientProcedureState? getStateOnEvent(PatientProcedureEvent event) {
    final eventType = event.runtimeType;
    PatientProcedureState? newState = getCurrentState();
    switch (eventType) {
      case PatientProcedureInitializedEvent:
        PatientProcedureInitializedEvent initEvent =
            event as PatientProcedureInitializedEvent;
        newState = PatientProcedureInitializedState(
            initEvent.patientId, initEvent.patientProcedures);
        break;

      case PatientProcedureLoadingEvent:
        newState = PatientProcedureLoadingState();
        break;

      case PatientProcedureErrorEvent:
        newState = PatientProcedureErrorState();
        break;
    }
    return newState;
  }
}

abstract class PatientProcedureEvent {}

class PatientProcedureErrorEvent extends PatientProcedureEvent {
  PatientProcedureErrorEvent();
}

class PatientProcedureInitializedEvent extends PatientProcedureEvent {
  final String patientId;
  final List<PatientProcedureEnity> patientProcedures;
  PatientProcedureInitializedEvent(this.patientId, this.patientProcedures);
}

class PatientProcedureLoadingEvent extends PatientProcedureEvent {}

abstract class PatientProcedureState {}

class PatientProcedureInitializationState implements PatientProcedureState {}

class PatientProcedureLoadingState implements PatientProcedureState {}

class PatientProcedureInitializedState implements PatientProcedureState {
  final String patientId;
  final List<PatientProcedureEnity> patientProcedures;
  PatientProcedureInitializedState(this.patientId, this.patientProcedures);
}

class PatientProcedureErrorState implements PatientProcedureState {}
