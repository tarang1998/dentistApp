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
        newState = AddEditPatientInitializedState(
            initializedEvent.dob,
            initializedEvent.sex,
            initializedEvent.createdAt,
            initializedEvent.maritialStatus,
            initializedEvent.bloodGroup,
            initializedEvent.diseases,
            initializedEvent.pregnancyStatus,
            initializedEvent.childNursingStatus,
            initializedEvent.habits,
            initializedEvent.allergies,
            initializedEvent.userImagePath,
            initializedEvent.storedUserImageFilePath);
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

      case AddEditPatientMaritialStatusToggledEvent:
        AddEditPatientMaritialStatusToggledEvent
            addEditPatientMaritialStatusToggledEvent =
            event as AddEditPatientMaritialStatusToggledEvent;
        if (newState.runtimeType == AddEditPatientInitializedState) {
          newState = AddEditPatientInitializedState.clone(
              newState as AddEditPatientInitializedState,
              maritialStatus:
                  addEditPatientMaritialStatusToggledEvent.maritialStatus);
        }
        break;

      case AddEditPatientBloodGroupSelectionEvent:
        AddEditPatientBloodGroupSelectionEvent
            addEditPatientBloodGroupSelectionEvent =
            event as AddEditPatientBloodGroupSelectionEvent;
        if (newState.runtimeType == AddEditPatientInitializedState) {
          newState = AddEditPatientInitializedState.clone(
              newState as AddEditPatientInitializedState,
              bloodGroup: addEditPatientBloodGroupSelectionEvent.bloodGroup);
        }
        break;

      case AddEditPatientDiseaseSelectionEvent:
        AddEditPatientDiseaseSelectionEvent
            addEditPatientDiseaseSelectionEvent =
            event as AddEditPatientDiseaseSelectionEvent;
        if (newState.runtimeType == AddEditPatientInitializedState) {
          newState = AddEditPatientInitializedState.clone(
              newState as AddEditPatientInitializedState,
              diseases: addEditPatientDiseaseSelectionEvent.diseases);
        }
        break;

      case AddEditPatientPregnancySelectionEvent:
        AddEditPatientPregnancySelectionEvent
            addEditPatientPregnancySelectionEvent =
            event as AddEditPatientPregnancySelectionEvent;
        if (newState.runtimeType == AddEditPatientInitializedState) {
          newState = AddEditPatientInitializedState.clone(
              newState as AddEditPatientInitializedState,
              pregnancyStatus: addEditPatientPregnancySelectionEvent.status);
        }
        break;

      case AddEditPatientChildNursingSelectionEvent:
        AddEditPatientChildNursingSelectionEvent
            addEditPatientChildNursingSelectionEvent =
            event as AddEditPatientChildNursingSelectionEvent;
        if (newState.runtimeType == AddEditPatientInitializedState) {
          newState = AddEditPatientInitializedState.clone(
              newState as AddEditPatientInitializedState,
              childNursingStatus:
                  addEditPatientChildNursingSelectionEvent.status);
        }
        break;

      case AddEditPatientHabitSelectionEvent:
        AddEditPatientHabitSelectionEvent addEditPatientHabitSelectionEvent =
            event as AddEditPatientHabitSelectionEvent;
        if (newState.runtimeType == AddEditPatientInitializedState) {
          newState = AddEditPatientInitializedState.clone(
              newState as AddEditPatientInitializedState,
              habits: addEditPatientHabitSelectionEvent.habits);
        }
        break;

      case AddEditPatientAllergiesSelectionEvent:
        AddEditPatientAllergiesSelectionEvent
            addEditPatientAllergiesSelectionEvent =
            event as AddEditPatientAllergiesSelectionEvent;
        if (newState.runtimeType == AddEditPatientInitializedState) {
          newState = AddEditPatientInitializedState.clone(
              newState as AddEditPatientInitializedState,
              allergies: addEditPatientAllergiesSelectionEvent.allergies);
        }
        break;

      case AddEditPatientUserImageSelectionEvent:
        AddEditPatientUserImageSelectionEvent
            addEditPatientUserImageSelectionEvent =
            event as AddEditPatientUserImageSelectionEvent;
        if (newState.runtimeType == AddEditPatientInitializedState) {
          newState = AddEditPatientInitializedState.clone(
              newState as AddEditPatientInitializedState,
              userImagePath:
                  addEditPatientUserImageSelectionEvent.userImagePath);
        }
        break;

      case AddEditPatientErrorEvent:
        newState = AddEditPatientErrorState();
        break;

      case AddEditPatientLoadingEvent:
        newState = AddEditPatientLoadingState();
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
  final MaritialStatus maritialStatus;
  final BloodGroup bloodGroup;
  final List<Diseases> diseases;
  final PregnancyStatus pregnancyStatus;
  final ChildNursingStatus childNursingStatus;
  final List<Habits> habits;
  final List<Allergies> allergies;
  final String? userImagePath; //image Path for the view
  final String? storedUserImageFilePath; //user Image path stored in the cloud
  AddEditPatientInitializedEvent(
      {required this.dob,
      required this.sex,
      required this.createdAt,
      required this.maritialStatus,
      required this.bloodGroup,
      required this.diseases,
      required this.pregnancyStatus,
      required this.childNursingStatus,
      required this.habits,
      required this.allergies,
      required this.userImagePath,
      required this.storedUserImageFilePath});
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

class AddEditPatientMaritialStatusToggledEvent extends AddEditPatientEvent {
  final MaritialStatus maritialStatus;
  AddEditPatientMaritialStatusToggledEvent({required this.maritialStatus});
}

class AddEditPatientBloodGroupSelectionEvent extends AddEditPatientEvent {
  final BloodGroup bloodGroup;
  AddEditPatientBloodGroupSelectionEvent({required this.bloodGroup});
}

class AddEditPatientDiseaseSelectionEvent extends AddEditPatientEvent {
  final List<Diseases> diseases;
  AddEditPatientDiseaseSelectionEvent({required this.diseases});
}

class AddEditPatientPregnancySelectionEvent extends AddEditPatientEvent {
  final PregnancyStatus status;
  AddEditPatientPregnancySelectionEvent({required this.status});
}

class AddEditPatientChildNursingSelectionEvent extends AddEditPatientEvent {
  final ChildNursingStatus status;
  AddEditPatientChildNursingSelectionEvent({required this.status});
}

class AddEditPatientHabitSelectionEvent extends AddEditPatientEvent {
  final List<Habits> habits;
  AddEditPatientHabitSelectionEvent({required this.habits});
}

class AddEditPatientAllergiesSelectionEvent extends AddEditPatientEvent {
  final List<Allergies> allergies;
  AddEditPatientAllergiesSelectionEvent({required this.allergies});
}

class AddEditPatientUserImageSelectionEvent extends AddEditPatientEvent {
  final String userImagePath;
  AddEditPatientUserImageSelectionEvent({required this.userImagePath});
}

abstract class AddEditPatientState {}

class AddEditPatientLoadingState implements AddEditPatientState {}

class AddEditPatientInitializationState implements AddEditPatientState {}

class AddEditPatientInitializedState implements AddEditPatientState {
  final DateTime dob;
  final Sex sex;
  final DateTime createdAt;
  final MaritialStatus maritialStatus;
  final BloodGroup bloodGroup;
  final List<Diseases> diseases;
  final PregnancyStatus pregnancyStatus;
  final ChildNursingStatus childNursingStatus;
  final List<Habits> habits;
  final List<Allergies> allergies;
  final String? userImagePath; //image Path for the view
  final String? storedUserImageFilePath; //user Image path stored in the cloud

  AddEditPatientInitializedState(
      this.dob,
      this.sex,
      this.createdAt,
      this.maritialStatus,
      this.bloodGroup,
      this.diseases,
      this.pregnancyStatus,
      this.childNursingStatus,
      this.habits,
      this.allergies,
      this.userImagePath,
      this.storedUserImageFilePath);

  AddEditPatientInitializedState.clone(AddEditPatientInitializedState prevState,
      {DateTime? dob,
      Sex? sex,
      MaritialStatus? maritialStatus,
      BloodGroup? bloodGroup,
      List<Diseases>? diseases,
      PregnancyStatus? pregnancyStatus,
      ChildNursingStatus? childNursingStatus,
      List<Habits>? habits,
      List<Allergies>? allergies,
      String? userImagePath,
      String? storedUserImageFilePath})
      : this(
            dob ?? prevState.dob,
            sex ?? prevState.sex,
            prevState.createdAt,
            maritialStatus ?? prevState.maritialStatus,
            bloodGroup ?? prevState.bloodGroup,
            diseases ?? prevState.diseases,
            pregnancyStatus ?? prevState.pregnancyStatus,
            childNursingStatus ?? prevState.childNursingStatus,
            habits ?? prevState.habits,
            allergies ?? prevState.allergies,
            userImagePath ?? prevState.userImagePath,
            storedUserImageFilePath ?? prevState.storedUserImageFilePath);
}

class AddEditPatientErrorState implements AddEditPatientState {}
