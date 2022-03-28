import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientAdditionalImages/patientImagesPresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientAdditionalImages/patientImagesStateMachine.dart';
import 'package:dentalApp/core/injectionContainer.dart';
import 'package:dentalApp/core/navigationService.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientImageController extends Controller {
  final PatientImagePresenter _presenter;
  final NavigationService _navigationService;

  final PatientImageStateMachine _stateMachine = PatientImageStateMachine();

  PatientImageController()
      : _presenter = serviceLocator<PatientImagePresenter>(),
        _navigationService = serviceLocator<NavigationService>(),
        super();

  @override
  void initListeners() {}

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  PatientImageState? getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  void initializePage(String patientId) {
    _presenter.getPatientInformation(
        UseCaseObserver(() {}, (error) {
          _stateMachine.onEvent(PatientImageErrorEvent());
          refreshUI();
        }, onNextFunc: (PatientInformation patientInformation) {
          final List<String> uploadedImagesPath =
              patientInformation.additionalImages;
          if (uploadedImagesPath.length != 0) {
            _presenter.getAdditionImagesRef(
                UseCaseObserver(() {}, (error) {
                  _stateMachine.onEvent(PatientImageErrorEvent());
                  refreshUI();
                }, onNextFunc: (List<String> storedImagesRef) {
                  _stateMachine
                      .onEvent(PatientImageInitializedEvent(storedImagesRef));
                  refreshUI();
                }),
                uploadedImagesPath);
          } else {
            _stateMachine.onEvent(PatientImageInitializedEvent([]));
            refreshUI();
          }
        }),
        patientId);
  }

  void navigateBack() {
    _navigationService.navigateBack();
  }
}
