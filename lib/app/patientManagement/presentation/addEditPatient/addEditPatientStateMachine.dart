import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/core/presentation/stateMachine.dart';

class AddEditPatientStateMachine
    extends StateMachine<AddEditPatientState?, AddEditPatientEvent> {
  AddEditPatientStateMachine() : super(AddEditPatientInitializationState());

  @override
  AddEditPatientState? getStateOnEvent(AddEditPatientEvent event) {
    final eventType = event.runtimeType;
    AddEditPatientState? newState = getCurrentState();
    switch (eventType) {
      case AddEditPatientInitializedEvent:
        AddEditPatientInitializedEvent initializedEvent =
            event as AddEditPatientInitializedEvent;
        newState = AddEditPatientInitializedState(initializedEvent.dob,
            initializedEvent.sex, initializedEvent.createdAt);
        break;

      case AddEditPatientDOBUpdatedEvent:
        AddEditPatientDOBUpdatedEvent dobUpdatedEvent =
            event as AddEditPatientDOBUpdatedEvent;
        if (newState.runtimeType == AddEditPatientInitializedState) {
          newState = AddEditPatientInitializedState.clone(
              newState as AddEditPatientInitializedState,
              dob: dobUpdatedEvent.dob);
        }
        break;

      case AddEditPatientUserSexToggledEvent:
        AddEditPatientUserSexToggledEvent userSexToggledEvent =
            event as AddEditPatientUserSexToggledEvent;
        if (newState.runtimeType == AddEditPatientInitializedState) {
          newState = AddEditPatientInitializedState.clone(
              newState as AddEditPatientInitializedState,
              sex: userSexToggledEvent.sex);
        }
        break;

      case AddEditPatientErrorEvent:
        newState = AddEditPatientErrorState();
        break;
    }
    return newState;
  }
}

abstract class AddEditPatientEvent {}

class AddEditPatientErrorEvent extends AddEditPatientEvent {
  AddEditPatientErrorEvent();
}

class AddEditPatientInitializedEvent extends AddEditPatientEvent {
  final DateTime dob;
  final Sex sex;
  final DateTime createdAt;
  AddEditPatientInitializedEvent(
      {required this.dob, required this.sex, required this.createdAt});
}

class AddEditPatientLoadingEvent extends AddEditPatientEvent {}

class AddEditPatientDOBUpdatedEvent extends AddEditPatientEvent {
  DateTime dob;
  AddEditPatientDOBUpdatedEvent(this.dob);
}

class AddEditPatientUserSexToggledEvent extends AddEditPatientEvent {
  Sex sex;
  AddEditPatientUserSexToggledEvent(this.sex);
}

abstract class AddEditPatientState {}

class AddEditPatientLoadingState implements AddEditPatientState {}

class AddEditPatientInitializationState implements AddEditPatientState {}

class AddEditPatientInitializedState implements AddEditPatientState {
  final DateTime dob;
  final Sex sex;
  final DateTime createdAt;
  AddEditPatientInitializedState(this.dob, this.sex, this.createdAt);

  AddEditPatientInitializedState.clone(
    AddEditPatientInitializedState prevState, {
    DateTime? dob,
    Sex? sex,
  }) : this(dob ?? prevState.dob, sex ?? prevState.sex, prevState.createdAt);
}

class AddEditPatientErrorState implements AddEditPatientState {}
