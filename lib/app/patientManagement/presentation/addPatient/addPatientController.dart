import 'package:dentalApp/app/patientManagement/domain/entities/addPatientEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/presentation/addPatient/addPatientPresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/addPatient/addPatientStateMachine.dart';
import 'package:dentalApp/core/injectionContainer.dart';
import 'package:dentalApp/core/navigationService.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPatientController extends Controller {
  final AddPatientPresenter _presenter;
  final NavigationService _navigationService;

  final AddPatientStateMachine _stateMachine = AddPatientStateMachine();

  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController phoneNoTextEditingController =
      TextEditingController();
  final TextEditingController addressTextEditingController =
      TextEditingController();
  final TextEditingController additionalInformationTextEditingController =
      TextEditingController();

  AddPatientController()
      : _presenter = serviceLocator<AddPatientPresenter>(),
        _navigationService = serviceLocator<NavigationService>(),
        super();

  @override
  void initListeners() {}

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  AddPatientState? getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  void initializePage() {
    _stateMachine.onEvent(AddPatientInitializedEvent());
    refreshUI();
  }

  void navigateBack() {
    _navigationService.navigateBack();
  }

  void handleDOBUpdation(DateTime dob) {
    _stateMachine.onEvent(AddPatientDOBUpdatedEvent(dob));
    refreshUI();
  }

  void handleUserSexToggled(Sex sex) {
    _stateMachine.onEvent(AddPatientUserSexToggledEvent(sex));
    refreshUI();
  }

  void validateUserData(DateTime dob, Sex sex,
      Function reloadPatientsMetaPageOnSuccessFullPatientAddition) {
    if (nameTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter a name ');
      return;
    }

    if (emailTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter an email Id ');
      return;
    }

    //TODO : Perform email validation

    if (phoneNoTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter phone Number ');
      return;
    }

    _presenter.addPatientData(
        UseCaseObserver(() {
          reloadPatientsMetaPageOnSuccessFullPatientAddition();
          _navigationService.navigateBack();
        }, (error) {
          Fluttertoast.showToast(
              msg: 'Error while adding patient Data. Please try again later');
          _stateMachine.onEvent(AddPatientErrorEvent());
          refreshUI();
        }),
        addPatientEntity: AddPatientEntity(
            name: nameTextEditingController.text,
            address: addressTextEditingController.text,
            phoneNo: phoneNoTextEditingController.text,
            emailId: emailTextEditingController.text,
            additionalInformation:
                additionalInformationTextEditingController.text,
            dob: dob,
            sex: sex,
            createdAt: DateTime.now()));
  }
}
