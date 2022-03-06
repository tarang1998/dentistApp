import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/addEditPatientView.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientInformationView.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientManagementPresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientManagementStateMachine.dart';
import 'package:dentalApp/core/injectionContainer.dart';
import 'package:dentalApp/core/loggingWrapper.dart';
import 'package:dentalApp/core/navigationService.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientManagementController extends Controller {
  final PatientManagementPresenter _presenter;
  final NavigationService _navigationService;

  final PatientManagementStateMachine _stateMachine =
      PatientManagementStateMachine();

  final ScrollController scrollController = ScrollController();

  //Variable to control the scroll controller
  bool isFetchingNextPage = false;

  PatientManagementController()
      : _presenter = serviceLocator<PatientManagementPresenter>(),
        _navigationService = serviceLocator<NavigationService>(),
        super();

  @override
  void initListeners() {
    scrollController.addListener(_scrollListener);
  }

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      fetchNextBatchOfPatientsMeta();
    }
  }

  PatientManagementState? getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  //Function called whenever the user enters the patient Tab
  void fetchPatientsMeta() {
    _presenter.getPatientsMetaInformation(UseCaseObserver(() {}, (error) {
      _stateMachine.onEvent(PatientManagementErrorEvent());
      refreshUI();
    }, onNextFunc: (List<PatientMetaInformation> patientMetaInformation) {
      _stateMachine
          .onEvent(PatientManagementInitializedEvent(patientMetaInformation));
      refreshUI();
    }));
  }

  //Function to be called on Pagination
  void fetchNextBatchOfPatientsMeta() {
    if (isFetchingNextPage) return;
    isFetchingNextPage = true;
    refreshUI();
    _presenter.fetchNextBatchOfPatientsMetaInformation(UseCaseObserver(() {
      isFetchingNextPage = false;
      fetchPatientsMeta();
    }, (error) {
      isFetchingNextPage = false;
      _stateMachine.onEvent(PatientManagementErrorEvent());
      refreshUI();
    }));
  }

  void navigateToPatientInformationPage({required String patientId}) {
    _navigationService.navigateTo(NavigationService.patientInformationPage,
        shouldReplace: false,
        arguments: PatientInformationPageParams(patientId, reloadPage));

    //TODO : Using the .then operator to reload the page on navigation back
  }

  void navigateToAddPatientPage() {
    _navigationService
        .navigateTo(NavigationService.addEditPatientPage,
            shouldReplace: false,
            arguments: AddEditPatientPageParams(
                reloadPatientsMetaPageOnSuccessFullPatientAdditionOrEdition:
                    reloadPage,
                inEditMode: false))
        .then((value) =>
            LoggingWrapper.print('Navigated Back to Patient management Page'));
  }

  //Function called on Pull to Refresh
  Future<void> refreshPage() async {
    _stateMachine.onEvent(PatientManagementLoadingEvent());
    refreshUI();
    //Deleting the cache and refetching all of the patient Data
    _presenter.fetchPatientsMetaInformation(UseCaseObserver(() {
      fetchPatientsMeta();
    }, (error) {
      _stateMachine.onEvent(PatientManagementErrorEvent());
      refreshUI();
    }));
  }

  //Function called to reload the page
  ///On successfull staff addition so that added staff data is fetched too
  void reloadPage() {
    _stateMachine.onEvent(PatientManagementLoadingEvent());
    refreshUI();
    fetchPatientsMeta();
  }
}
