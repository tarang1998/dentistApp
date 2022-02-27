import 'package:dentist_app/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentist_app/core/presentation/stateMachine.dart';

class PatientManagementStateMachine
    extends StateMachine<PatientManagementState?, PatientManagementEvent> {
  PatientManagementStateMachine()
      : super(PatientManagementInitializationState());

  @override
  PatientManagementState? getStateOnEvent(PatientManagementEvent event) {
    final eventType = event.runtimeType;
    PatientManagementState? newState = getCurrentState();
    switch (eventType) {
      case PatientManagementInitializedEvent:
        PatientManagementInitializedEvent initEvent =
            event as PatientManagementInitializedEvent;
        newState = PatientManagementInitializedState(
            initEvent.patientsMetaInformation);
        break;

      case PatientManagementLoadingEvent:
        newState = PatientManagementLoadingState();
        break;

      case PatientManagementErrorEvent:
        newState = PatientManagementErrorState();
        break;
    }
    return newState;
  }
}

abstract class PatientManagementEvent {}

class PatientManagementErrorEvent extends PatientManagementEvent {
  PatientManagementErrorEvent();
}

class PatientManagementInitializedEvent extends PatientManagementEvent {
  final List<PatientMetaInformation> patientsMetaInformation;
  PatientManagementInitializedEvent(this.patientsMetaInformation);
}

class PatientManagementLoadingEvent extends PatientManagementEvent {}

abstract class PatientManagementState {}

class PatientManagementInitializationState implements PatientManagementState {}

class PatientManagementLoadingState implements PatientManagementState {}

class PatientManagementInitializedState implements PatientManagementState {
  final List<PatientMetaInformation> patientsMetaInformation;
  PatientManagementInitializedState(this.patientsMetaInformation);
}

class PatientManagementErrorState implements PatientManagementState {}
