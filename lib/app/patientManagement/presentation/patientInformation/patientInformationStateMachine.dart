import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/core/presentation/stateMachine.dart';

class PatientInformationStateMachine
    extends StateMachine<PatientInformationState?, PatientInformationEvent> {
  PatientInformationStateMachine()
      : super(PatientInformationInitializationState());

  @override
  PatientInformationState? getStateOnEvent(PatientInformationEvent event) {
    final eventType = event.runtimeType;
    PatientInformationState? newState = getCurrentState();
    switch (eventType) {
      case PatientInformationInitializedEvent:
        PatientInformationInitializedEvent initEvent =
            event as PatientInformationInitializedEvent;

        newState = PatientInformationInitializedState(
            initEvent.patientInformation, initEvent.storageImagePath);
        break;

      case PatientInformationErrorEvent:
        newState = PatientInformationErrorState();
        break;
    }
    return newState;
  }
}

abstract class PatientInformationEvent {}

class PatientInformationErrorEvent extends PatientInformationEvent {
  PatientInformationErrorEvent();
}

class PatientInformationInitializedEvent extends PatientInformationEvent {
  final PatientInformation patientInformation;
  final String? storageImagePath;
  PatientInformationInitializedEvent(
      this.patientInformation, this.storageImagePath);
}

class PatientInformationLoadingEvent extends PatientInformationEvent {}

abstract class PatientInformationState {}

class PatientInformationLoadingState implements PatientInformationState {}

class PatientInformationInitializationState implements PatientInformationState {
}

class PatientInformationInitializedState implements PatientInformationState {
  final PatientInformation patientInformation;
  final String? storageImagePath;
  PatientInformationInitializedState(
      this.patientInformation, this.storageImagePath);
}

class PatientInformationErrorState implements PatientInformationState {}
