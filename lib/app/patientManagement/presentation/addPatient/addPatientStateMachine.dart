import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/core/presentation/stateMachine.dart';

class AddPatientStateMachine
    extends StateMachine<AddPatientState?, AddPatientEvent> {
  AddPatientStateMachine() : super(AddPatientInitializationState());

  @override
  AddPatientState? getStateOnEvent(AddPatientEvent event) {
    final eventType = event.runtimeType;
    AddPatientState? newState = getCurrentState();
    switch (eventType) {
      case AddPatientInitializedEvent:
        newState = AddPatientInitializedState(DateTime.now(), Sex.male);
        break;

      case AddPatientDOBUpdatedEvent:
        AddPatientDOBUpdatedEvent dobUpdatedEvent =
            event as AddPatientDOBUpdatedEvent;
        if (newState.runtimeType == AddPatientInitializedState) {
          newState = AddPatientInitializedState.clone(
              newState as AddPatientInitializedState,
              dob: dobUpdatedEvent.dob);
        }
        break;

      case AddPatientUserSexToggledEvent:
        AddPatientUserSexToggledEvent userSexToggledEvent =
            event as AddPatientUserSexToggledEvent;
        if (newState.runtimeType == AddPatientInitializedState) {
          newState = AddPatientInitializedState.clone(
              newState as AddPatientInitializedState,
              sex: userSexToggledEvent.sex);
        }
        break;

      case AddPatientErrorEvent:
        newState = AddPatientErrorState();
        break;
    }
    return newState;
  }
}

abstract class AddPatientEvent {}

class AddPatientErrorEvent extends AddPatientEvent {
  AddPatientErrorEvent();
}

class AddPatientInitializedEvent extends AddPatientEvent {
  AddPatientInitializedEvent();
}

class AddPatientLoadingEvent extends AddPatientEvent {}

class AddPatientDOBUpdatedEvent extends AddPatientEvent {
  DateTime dob;
  AddPatientDOBUpdatedEvent(this.dob);
}

class AddPatientUserSexToggledEvent extends AddPatientEvent {
  Sex sex;
  AddPatientUserSexToggledEvent(this.sex);
}

abstract class AddPatientState {}

class AddPatientLoadingState implements AddPatientState {}

class AddPatientInitializationState implements AddPatientState {}

class AddPatientInitializedState implements AddPatientState {
  final DateTime dob;
  final Sex sex;
  AddPatientInitializedState(this.dob, this.sex);

  AddPatientInitializedState.clone(
    AddPatientInitializedState prevState, {
    DateTime? dob,
    Sex? sex,
  }) : this(dob ?? prevState.dob, sex ?? prevState.sex);
}

class AddPatientErrorState implements AddPatientState {}
