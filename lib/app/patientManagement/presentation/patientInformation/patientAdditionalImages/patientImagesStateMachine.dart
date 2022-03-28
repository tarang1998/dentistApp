import 'package:dentalApp/core/presentation/stateMachine.dart';

class PatientImageStateMachine
    extends StateMachine<PatientImageState?, PatientImageEvent> {
  PatientImageStateMachine() : super(PatientImageInitializationState());

  @override
  PatientImageState? getStateOnEvent(PatientImageEvent event) {
    final eventType = event.runtimeType;
    PatientImageState? newState = getCurrentState();
    switch (eventType) {
      case PatientImageInitializedEvent:
        PatientImageInitializedEvent initEvent =
            event as PatientImageInitializedEvent;
        newState =
            PatientImageInitializedState(initEvent.downloadableImageUris);
        break;

      case PatientImageLoadingEvent:
        newState = PatientImageLoadingState();
        break;

      case PatientImageErrorEvent:
        newState = PatientImageErrorState();
        break;
    }
    return newState;
  }
}

abstract class PatientImageEvent {}

class PatientImageErrorEvent extends PatientImageEvent {
  PatientImageErrorEvent();
}

class PatientImageInitializedEvent extends PatientImageEvent {
  final List<String> downloadableImageUris;
  PatientImageInitializedEvent(this.downloadableImageUris);
}

class PatientImageLoadingEvent extends PatientImageEvent {}

abstract class PatientImageState {}

class PatientImageInitializationState implements PatientImageState {}

class PatientImageLoadingState implements PatientImageState {}

class PatientImageInitializedState implements PatientImageState {
  final List<String> downloadableImageUris;
  PatientImageInitializedState(this.downloadableImageUris);
}

class PatientImageErrorState implements PatientImageState {}
