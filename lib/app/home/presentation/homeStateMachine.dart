import 'package:dentist_app/core/presentation/stateMachine.dart';

class HomePageStateMachine extends StateMachine<HomePageState?, HomePageEvent> {
  HomePageStateMachine() : super(new HomePageLoadingState());

  @override
  HomePageState? getStateOnEvent(HomePageEvent event) {
    final eventType = event.runtimeType;
    HomePageState? newState = getCurrentState();
    switch (eventType) {
      case HomePageInitializedEvent:
        newState = HomePageInitializedState();
        break;

      case HomePageErrorEvent:
        newState = HomePageErrorState();
        break;
    }
    return newState;
  }
}

abstract class HomePageEvent {}

class HomePageErrorEvent extends HomePageEvent {
  final Exception error;
  HomePageErrorEvent(this.error);
}

class HomePageInitializedEvent extends HomePageEvent {
  HomePageInitializedEvent();
}

class HomePageLoadingEvent extends HomePageEvent {}

abstract class HomePageState {}

class HomePageLoadingState implements HomePageState {}

class HomePageInitializedState implements HomePageState {}

class HomePageErrorState implements HomePageState {
  HomePageErrorState();
}
