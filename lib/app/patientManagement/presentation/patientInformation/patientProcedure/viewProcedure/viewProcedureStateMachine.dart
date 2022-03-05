import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/core/presentation/stateMachine.dart';

class ViewProcedureStateMachine
    extends StateMachine<ViewProcedureState?, ViewProcedureEvent> {
  ViewProcedureStateMachine() : super(ViewProcedureInitializationState());

  @override
  ViewProcedureState? getStateOnEvent(ViewProcedureEvent event) {
    final eventType = event.runtimeType;
    ViewProcedureState? newState = getCurrentState();
    switch (eventType) {
      case ViewProcedureInitializedEvent:
        ViewProcedureInitializedEvent initEvent =
            event as ViewProcedureInitializedEvent;
        newState = ViewProcedureInitializedState(
            initEvent.patientId, initEvent.patientProcedureEnity);
        break;

      case ViewProcedureLoadingEvent:
        newState = ViewProcedureLoadingState();
        break;

      case ViewProcedureErrorEvent:
        newState = ViewProcedureErrorState();
        break;
    }
    return newState;
  }
}

abstract class ViewProcedureEvent {}

class ViewProcedureErrorEvent extends ViewProcedureEvent {
  ViewProcedureErrorEvent();
}

class ViewProcedureInitializedEvent extends ViewProcedureEvent {
  final String patientId;
  final PatientProcedureEnity patientProcedureEnity;
  ViewProcedureInitializedEvent(this.patientId, this.patientProcedureEnity);
}

class ViewProcedureLoadingEvent extends ViewProcedureEvent {}

abstract class ViewProcedureState {}

class ViewProcedureInitializationState implements ViewProcedureState {}

class ViewProcedureLoadingState implements ViewProcedureState {}

class ViewProcedureInitializedState implements ViewProcedureState {
  final String patientId;
  final PatientProcedureEnity patientProcedureEnity;
  ViewProcedureInitializedState(this.patientId, this.patientProcedureEnity);
}

class ViewProcedureErrorState implements ViewProcedureState {}
