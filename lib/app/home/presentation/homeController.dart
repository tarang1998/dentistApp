import 'package:dentalApp/app/home/presentation/homePresenter.dart';
import 'package:dentalApp/app/home/presentation/homeStateMachine.dart';
import 'package:dentalApp/core/injectionContainer.dart';
import 'package:dentalApp/core/navigationService.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class HomePageController extends Controller {
  final HomePagePresenter? _presenter;
  final NavigationService _navigationService;

  final HomePageStateMachine _stateMachine = new HomePageStateMachine();

  HomePageController()
      : _presenter = serviceLocator<HomePagePresenter>(),
        _navigationService = serviceLocator<NavigationService>(),
        super();

  @override
  void initListeners() {}

  HomePageState? getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  void initializePage() {
    _stateMachine.onEvent(HomePageInitializedEvent());
    refreshUI();
  }

  void navigateToPatientsManagementPage() {
    _navigationService.navigateTo(NavigationService.patientsManagementPage);
  }
}
