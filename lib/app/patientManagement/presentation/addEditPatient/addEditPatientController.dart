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

  //Personal Information
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController professionTextEditingController =
      TextEditingController();
  final TextEditingController telephoneNoTextEditingController =
      TextEditingController();
  final TextEditingController mobileNumberTextEditingController =
      TextEditingController();
  final TextEditingController addressTextEditingController =
      TextEditingController();
  final TextEditingController officeInformationTextEditingController =
      TextEditingController();
  final TextEditingController refferedByTextEditingController =
      TextEditingController();

  //Medical Informatiom
  final TextEditingController familyDoctorsName = TextEditingController();
  final TextEditingController familyDoctorsAddressAndTelephoneNo =
      TextEditingController();

  //Medication Information
  final TextEditingController medicationInformationTextEditingController =
      TextEditingController();
  final TextEditingController allergiesInformation = TextEditingController();

  //Dental Information
  final TextEditingController mainDentalComplain = TextEditingController();
  final TextEditingController pastDentalInformation = TextEditingController();

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
            nameTextEditingController.text = patientInformation
                .patientPersonalInformation.patientMetaInformation.name;
            emailTextEditingController.text = patientInformation
                .patientPersonalInformation.patientMetaInformation.emailId;
            professionTextEditingController.text =
                patientInformation.patientPersonalInformation.profession;
            mobileNumberTextEditingController.text = patientInformation
                .patientPersonalInformation.mobileNo
                .toString();
            telephoneNoTextEditingController.text = patientInformation
                .patientPersonalInformation.telephoneNo
                .toString();
            addressTextEditingController.text =
                patientInformation.patientPersonalInformation.address;
            officeInformationTextEditingController.text =
                patientInformation.patientPersonalInformation.officeInformation;
            refferedByTextEditingController.text =
                patientInformation.patientPersonalInformation.refferedBy;

            familyDoctorsName.text =
                patientInformation.patientMedicalInformation.familyDoctorsName;
            familyDoctorsAddressAndTelephoneNo.text = patientInformation
                .patientMedicalInformation.familyDoctorsAddressInformation;

            medicationInformationTextEditingController.text = patientInformation
                .patientMedicationInformation.medicationInformation;
            allergiesInformation.text = patientInformation
                .patientMedicationInformation.allergiesInformation;

            mainDentalComplain.text =
                patientInformation.patientDentalInformation.mainComplain;
            pastDentalInformation.text = patientInformation
                .patientDentalInformation.pastDentalTreatmentInformation;

            additionalInformationTextEditingController.text =
                patientInformation.additionalInformation;

            _stateMachine.onEvent(AddEditPatientInitializedEvent(
                dob: patientInformation
                    .patientPersonalInformation.patientMetaInformation.dob,
                sex: patientInformation
                    .patientPersonalInformation.patientMetaInformation.sex,
                createdAt: patientInformation.createdAt,
                maritialStatus: patientInformation
                    .patientPersonalInformation.maritialStatus,
                bloodGroup:
                    patientInformation.patientPersonalInformation.bloodGroup,
                diseases: patientInformation.patientMedicalInformation.diseases,
                pregnancyStatus: patientInformation
                    .patientMedicalInformation.pregnancyStatus,
                childNursingStatus: patientInformation
                    .patientMedicalInformation.childNursingStatus,
                habits: patientInformation.patientMedicalInformation.habits,
                allergies:
                    patientInformation.patientMedicationInformation.allergies));
            refreshUI();
          }),
          patientId: patientId!);
    } else {
      _stateMachine.onEvent(
        AddEditPatientInitializedEvent(
            dob: DateTime.now(),
            sex: Sex.MALE,
            createdAt: DateTime.now(),
            maritialStatus: MaritialStatus.SINGLE,
            bloodGroup: BloodGroup.AP,
            diseases: [],
            pregnancyStatus: PregnancyStatus.NOT_PREGNANT,
            childNursingStatus: ChildNursingStatus.NOT_NURSING_CHILD,
            habits: [],
            allergies: []),
      );
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

  void handlePatientMaritialStatusToggledEvent(MaritialStatus maritialStatus) {
    _stateMachine.onEvent(AddEditPatientMaritialStatusToggledEvent(
        maritialStatus: maritialStatus));
    refreshUI();
  }

  void handlePatientBloodGroupToggledEvent(BloodGroup bloodGroup) {
    _stateMachine.onEvent(
        AddEditPatientBloodGroupSelectionEvent(bloodGroup: bloodGroup));
    refreshUI();
  }

  void handlePatientDiseaseSelectionEvent(List<Diseases> diseases) {
    _stateMachine
        .onEvent(AddEditPatientDiseaseSelectionEvent(diseases: diseases));
    refreshUI();
  }

  void handlePatientPregnancyStatusInput(PregnancyStatus status) {
    _stateMachine
        .onEvent(AddEditPatientPregnancySelectionEvent(status: status));
    refreshUI();
  }

  void handlePatientChildNursingStatus(ChildNursingStatus status) {
    _stateMachine
        .onEvent(AddEditPatientChildNursingSelectionEvent(status: status));
    refreshUI();
  }

  void handlePatientHabitSelection(List<Habits> habits) {
    _stateMachine.onEvent(AddEditPatientHabitSelectionEvent(habits: habits));
    refreshUI();
  }

  void handlePatientAllergiesSelectionEvent(List<Allergies> allergies) {
    _stateMachine
        .onEvent(AddEditPatientAllergiesSelectionEvent(allergies: allergies));
    refreshUI();
  }

  void submitUserData(
      DateTime dob,
      Sex sex,
      DateTime createdAt,
      MaritialStatus maritialStatus,
      BloodGroup bloodGroup,
      List<Diseases> diseases,
      PregnancyStatus pregnancyStatus,
      ChildNursingStatus childNursingStatus,
      List<Habits> habits,
      List<Allergies> allergies,
      bool isInEditMode,
      Function reloadPatientsMetaPageOnSuccessFullPatientAdditionOrEdition,
      String? patientId) {
    _stateMachine.onEvent(AddEditPatientLoadingEvent());
    refreshUI();
    if (isInEditMode) {
      _presenter.editPatientData(
          UseCaseObserver(() {
            //Reloading the patients meta Information page on successfull edition
            reloadPatientsMetaPageOnSuccessFullPatientAdditionOrEdition();
            _navigationService
                .navigateBackUntil(NavigationService.patientsManagementPage);
          }, (error) {
            Fluttertoast.showToast(
                msg:
                    'Error while editing patient Data. Please try again later');
            _stateMachine.onEvent(AddEditPatientErrorEvent());
            refreshUI();
          }),
          patientInformation: PatientInformation(
              patientPersonalInformation: PatientPersonalInformation(
                patientMetaInformation: PatientMetaInformation(
                    patientId: patientId!,
                    name: nameTextEditingController.text,
                    dob: dob,
                    emailId: emailTextEditingController.text,
                    sex: sex),
                address: addressTextEditingController.text,
                mobileNo: int.parse(mobileNumberTextEditingController.text),
                bloodGroup: bloodGroup,
                maritialStatus: maritialStatus,
                officeInformation: officeInformationTextEditingController.text,
                profession: professionTextEditingController.text,
                refferedBy: refferedByTextEditingController.text,
                telephoneNo: telephoneNoTextEditingController.text.isEmpty
                    ? null
                    : int.parse(telephoneNoTextEditingController.text),
              ),
              updatedAt: DateTime.now(),
              patientDentalInformation: PatientDentalInformation(
                  mainComplain: mainDentalComplain.text,
                  pastDentalTreatmentInformation: pastDentalInformation.text),
              patientMedicalInformation: PatientMedicalInformation(
                childNursingStatus: sex == Sex.MALE
                    ? ChildNursingStatus.NOT_APPLICABLE
                    : childNursingStatus,
                diseases: diseases,
                familyDoctorsAddressInformation:
                    familyDoctorsAddressAndTelephoneNo.text,
                familyDoctorsName: familyDoctorsName.text,
                habits: habits,
                pregnancyStatus: sex == Sex.MALE
                    ? PregnancyStatus.NOT_APPLICABLE
                    : pregnancyStatus,
              ),
              patientMedicationInformation: PatientMedicationInformation(
                  allergies: allergies,
                  allergiesInformation: allergiesInformation.text,
                  medicationInformation:
                      medicationInformationTextEditingController.text),
              additionalInformation:
                  additionalInformationTextEditingController.text,
              createdAt: createdAt));
    } else {
      _presenter.addPatientData(
          UseCaseObserver(() {
            //Reloading the patients meta Information page on successfull add ition

            reloadPatientsMetaPageOnSuccessFullPatientAdditionOrEdition();
            _navigationService.navigateBack();
          }, (error) {
            Fluttertoast.showToast(
                msg: 'Error while adding patient Data. Please try again later');
            _stateMachine.onEvent(AddEditPatientErrorEvent());
            refreshUI();
          }),
          patientInformation: PatientInformation(
              patientPersonalInformation: PatientPersonalInformation(
                patientMetaInformation: PatientMetaInformation(
                    patientId: '',
                    name: nameTextEditingController.text,
                    dob: dob,
                    emailId: emailTextEditingController.text,
                    sex: sex),
                address: addressTextEditingController.text,
                mobileNo: int.parse(mobileNumberTextEditingController.text),
                bloodGroup: bloodGroup,
                maritialStatus: maritialStatus,
                officeInformation: officeInformationTextEditingController.text,
                profession: professionTextEditingController.text,
                refferedBy: refferedByTextEditingController.text,
                telephoneNo: telephoneNoTextEditingController.text.isEmpty
                    ? null
                    : int.parse(telephoneNoTextEditingController.text),
              ),
              updatedAt: DateTime.now(),
              patientDentalInformation: PatientDentalInformation(
                  mainComplain: mainDentalComplain.text,
                  pastDentalTreatmentInformation: pastDentalInformation.text),
              patientMedicalInformation: PatientMedicalInformation(
                childNursingStatus: sex == Sex.MALE
                    ? ChildNursingStatus.NOT_APPLICABLE
                    : childNursingStatus,
                diseases: diseases,
                familyDoctorsAddressInformation:
                    familyDoctorsAddressAndTelephoneNo.text,
                familyDoctorsName: familyDoctorsName.text,
                habits: habits,
                pregnancyStatus: sex == Sex.MALE
                    ? PregnancyStatus.NOT_APPLICABLE
                    : pregnancyStatus,
              ),
              patientMedicationInformation: PatientMedicationInformation(
                  allergies: allergies,
                  allergiesInformation: allergiesInformation.text,
                  medicationInformation:
                      medicationInformationTextEditingController.text),
              additionalInformation:
                  additionalInformationTextEditingController.text,
              createdAt: DateTime.now()));
    }
  }
}
