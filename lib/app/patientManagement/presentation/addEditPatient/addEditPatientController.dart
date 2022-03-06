import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/addEditPatientPresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/addEditPatientStateMachine.dart';
import 'package:dentalApp/core/injectionContainer.dart';
import 'package:dentalApp/core/navigationService.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddEditPatientController extends Controller {
  final AddEditPatientPresenter _presenter;
  final NavigationService _navigationService;

  final AddEditPatientStateMachine _stateMachine = AddEditPatientStateMachine();

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

  AddEditPatientController()
      : _presenter = serviceLocator<AddEditPatientPresenter>(),
        _navigationService = serviceLocator<NavigationService>(),
        super();

  @override
  void initListeners() {}

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  AddEditPatientState? getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  void initializePage({required bool isInEditMode, String? patientId}) {
    if (isInEditMode) {
      _presenter.getPatientInformation(
          UseCaseObserver(() {}, (error) {
            _stateMachine.onEvent(AddEditPatientErrorEvent());
            refreshUI();
          }, onNextFunc: (final PatientInformation patientInformation) {
            nameTextEditingController.text =
                patientInformation.patientMetaInformation.name;
            emailTextEditingController.text = patientInformation.emailId;
            phoneNoTextEditingController.text = patientInformation.phoneNo;
            addressTextEditingController.text = patientInformation.address;
            additionalInformationTextEditingController.text =
                patientInformation.additionalInformation;
            _stateMachine.onEvent(AddEditPatientInitializedEvent(
                dob: patientInformation.patientMetaInformation.dob,
                sex: patientInformation.patientMetaInformation.sex,
                createdAt: patientInformation.createdAt));
            refreshUI();
          }),
          patientId: patientId!);
    } else {
      _stateMachine.onEvent(AddEditPatientInitializedEvent(
          dob: DateTime.now(), sex: Sex.MALE, createdAt: DateTime.now()));
      refreshUI();
    }
  }

  void navigateBack() {
    _navigationService.navigateBack();
  }

  void handleDOBUpdation(DateTime dob) {
    _stateMachine.onEvent(AddEditPatientDOBUpdatedEvent(dob));
    refreshUI();
  }

  void handleUserSexToggled(Sex sex) {
    _stateMachine.onEvent(AddEditPatientUserSexToggledEvent(sex));
    refreshUI();
  }

  validateUserData(
      DateTime dob,
      Sex sex,
      DateTime createdAt,
      bool isInEditMode,
      Function reloadPatientsMetaPageOnSuccessFullPatientAdditionOrEdition,
      String? patientId) {
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

    if (isInEditMode) {
      _presenter.editPatientData(
          UseCaseObserver(() {
            //Reloading the patients meta Information page on successfull edition
            reloadPatientsMetaPageOnSuccessFullPatientAdditionOrEdition();
            _navigationService
                .navigateBackUntil(NavigationService.patientsManagementPage);
          }, (error) {}),
          patientInformation: PatientInformation(
              patientMetaInformation: PatientMetaInformation(
                  patientId: patientId!,
                  name: nameTextEditingController.text,
                  dob: dob,
                  sex: sex),
              address: addressTextEditingController.text,
              phoneNo: phoneNoTextEditingController.text,
              emailId: emailTextEditingController.text,
              additionalInformation:
                  additionalInformationTextEditingController.text,
              createdAt: createdAt));
    } else {
      _presenter.addPatientData(
          UseCaseObserver(() {
            //Reloading the patients meta Information page on successfull add ition

            // reloadPatientsMetaPageOnSuccessFullPatientAdditionOrEdition();
            _navigationService.navigateBack();
          }, (error) {
            Fluttertoast.showToast(
                msg: 'Error while adding patient Data. Please try again later');
            _stateMachine.onEvent(AddEditPatientErrorEvent());
            refreshUI();
          }),
          patientInformation: PatientInformation(
              patientMetaInformation: PatientMetaInformation(
                  patientId: 'id',
                  name: nameTextEditingController.text,
                  dob: dob,
                  sex: sex),
              address: addressTextEditingController.text,
              phoneNo: phoneNoTextEditingController.text,
              emailId: emailTextEditingController.text,
              additionalInformation:
                  additionalInformationTextEditingController.text,
              createdAt: DateTime.now()));
    }
  }
}
