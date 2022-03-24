import 'dart:io';

import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/presentation/AddEditPatient/AddEditPatientController.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/addEditPatientStateMachine.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/widgets/allergiesSelectionWidget.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/widgets/bloodGroupSelectionWidget.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/widgets/childNursingSelectionWidget.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/widgets/diseaseSelectionWidget.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/widgets/genderSelectionWidget.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/widgets/habitSelectionWidget.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/widgets/maritialStatusSelectionWidget.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/widgets/pregnancySelectionWidget.dart';
import 'package:dentalApp/core/designSystem/appTheme.dart';
import 'package:dentalApp/core/designSystem/fundamentals/colors.dart';
import 'package:dentalApp/core/designSystem/fundamentals/spacing.dart';
import 'package:dentalApp/core/presentation/screenDimensions.dart';
import 'package:dentalApp/core/utilities/validateEmail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddEditPatientPage extends View {
  final AddEditPatientPageParams params;
  AddEditPatientPage(this.params);

  @override
  State<StatefulWidget> createState() => AddEditPatientPageState();
}

class AddEditPatientPageState
    extends ResponsiveViewState<AddEditPatientPage, AddEditPatientController> {
  AddEditPatientPageState() : super(AddEditPatientController());
  final _form = GlobalKey<FormState>(); //for storing form state.

  @override
  Widget get desktopView => throw UnimplementedError();

  @override
  Widget get mobileView => ControlledWidgetBuilder<AddEditPatientController>(
        builder: (context, controller) {
          final currentState = controller.getCurrentState();
          final currentStateType = controller.getCurrentState().runtimeType;

          print(
              "BuildMobileView of AddEditPatientPage called with state $currentStateType");

          switch (currentStateType) {
            case AddEditPatientInitializedState:
              AddEditPatientInitializedState addEditPatientInitializedState =
                  currentState as AddEditPatientInitializedState;
              return _buildInitializedStateView(
                  addEditPatientInitializedState, controller);

            case AddEditPatientLoadingState:
              return _buildLoadingStateView(controller);

            case AddEditPatientInitializationState:
              return _buildInitializationStateView(controller,
                  widget.params.inEditMode, widget.params.patientId);

            case AddEditPatientErrorState:
              return _buildErrorStateView();
          }

          throw Exception(
              "Unrecognized state $currentStateType encountered in AddEditPatientPage");
        },
      );

  @override
  Widget get tabletView => mobileView; // View same as mobile

  @override
  Widget get watchView => throw UnimplementedError();

  Widget _buildInitializedStateView(
    AddEditPatientInitializedState initializedState,
    AddEditPatientController controller,
  ) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(RawSpacing.extraSmall),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                      ),
                      onPressed: () => controller.navigateBack(),
                    ),
                    Text(
                        widget.params.inEditMode
                            ? 'Edit Patient Information'
                            : 'Patient Registration Form',
                        style: AppTheme.headingTextStyle),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(RawSpacing.extraSmall),
                child: Text('Personal Information : ',
                    style: AppTheme.subHeadingTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: GestureDetector(
                    onTap: () => controller.captureUserImage(),
                    child: CircleAvatar(
                      backgroundImage: (initializedState.userImagePath != null)
                          ? FileImage(File(initializedState.userImagePath!))
                          : null,
                      backgroundColor: RawColors.grey20,
                      minRadius: 100,
                      maxRadius: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('+',
                              style: TextStyle(
                                  fontSize: 30, color: RawColors.white100)),
                          Text('Add User Image',
                              style: TextStyle(
                                  fontSize: 20, color: RawColors.white100))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Name *',
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Please enter the patient's Name";
                    }
                    return null;
                  },
                  controller: controller.nameTextEditingController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    enabledBorder: AppTheme.textFieldInputEnabledBorder,
                    focusedBorder: AppTheme.textFieldInputFocusedBorder,
                    errorBorder: AppTheme.textFieldInputFocusedBorder,
                    focusedErrorBorder: AppTheme.textFieldInputFocusedBorder,
                    hintStyle: AppTheme.hintTextStyle,
                    hintText: "Enter Patient's Name",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(RawSpacing.extraSmall),
                child: Text(
                  'Email Id *',
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Please enter the patient's Email Id";
                    }
                    if (!EmailValidator.validate(text)) {
                      return "Please enter a valid Email Id.";
                    }
                    return null;
                  },
                  controller: controller.emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    enabledBorder: AppTheme.textFieldInputEnabledBorder,
                    focusedBorder: AppTheme.textFieldInputFocusedBorder,
                    errorBorder: AppTheme.textFieldInputFocusedBorder,
                    focusedErrorBorder: AppTheme.textFieldInputFocusedBorder,
                    hintStyle: AppTheme.hintTextStyle,
                    hintText: "Enter Patient's Email Id",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Address *',
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                height: getScreenHeight(context) * 0.2,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: controller.addressTextEditingController,
                  keyboardType: TextInputType.streetAddress,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Please enter the patient's Address";
                    }
                    return null;
                  },
                  minLines: getScreenHeight(context) ~/ 50,
                  maxLines: null,
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(),
                    enabledBorder: AppTheme.textFieldInputEnabledBorder,
                    focusedBorder: AppTheme.textFieldInputFocusedBorder,
                    errorBorder: AppTheme.textFieldInputFocusedBorder,
                    focusedErrorBorder: AppTheme.textFieldInputFocusedBorder,
                    hintStyle: AppTheme.hintTextStyle,
                    hintText: "Enter Patient's Address",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GenderSelectionWidget(
                selectedSex: initializedState.sex,
                handleUserSexToggled: controller.handleUserSexToggled,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Date Of Birth',
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: RawColors.grey20,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Text(
                            "${initializedState.dob.year}/${initializedState.dob.month}/${initializedState.dob.day}",
                            style: TextStyle(
                                color: RawColors.grey70, fontSize: 16),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () =>
                    _pickDateOfBirth(controller, context, initializedState.dob),
              ),
              const SizedBox(height: 20),
              maritialStatusSelectionWidget(
                  selectedMaritialStatus: initializedState.maritialStatus,
                  handlePatientMaritialStatusToggledEvent:
                      controller.handlePatientMaritialStatusToggledEvent,
                  context: context),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Profession *',
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Please enter the patient's Profession";
                    }
                    return null;
                  },
                  controller: controller.professionTextEditingController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    enabledBorder: AppTheme.textFieldInputEnabledBorder,
                    focusedBorder: AppTheme.textFieldInputFocusedBorder,
                    errorBorder: AppTheme.textFieldInputFocusedBorder,
                    focusedErrorBorder: AppTheme.textFieldInputFocusedBorder,
                    hintStyle: AppTheme.hintTextStyle,
                    hintText: "Enter Patient's Profession",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(RawSpacing.extraSmall),
                child: Text(
                  'Mobile No. *',
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please enter the patient's Mobile No.";
                      }
                      return null;
                    },
                    controller: controller.mobileNumberTextEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      enabledBorder: AppTheme.textFieldInputEnabledBorder,
                      focusedBorder: AppTheme.textFieldInputFocusedBorder,
                      errorBorder: AppTheme.textFieldInputFocusedBorder,
                      focusedErrorBorder: AppTheme.textFieldInputFocusedBorder,
                      hintStyle: AppTheme.hintTextStyle,
                      hintText: "Enter Mobile No.",
                    )),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(RawSpacing.extraSmall),
                child: Text(
                  'Telephone No.',
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                    controller: controller.telephoneNoTextEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      enabledBorder: AppTheme.textFieldInputEnabledBorder,
                      focusedBorder: AppTheme.textFieldInputFocusedBorder,
                      errorBorder: AppTheme.textFieldInputFocusedBorder,
                      hintStyle: AppTheme.hintTextStyle,
                      hintText: "Enter Telephone No.",
                    )),
              ),
              const SizedBox(height: 20),
              bloodGroupSelectionWidget(
                  selectedBloodGroup: initializedState.bloodGroup,
                  context: context,
                  handlePatientBloodGroupToggledEvent:
                      controller.handlePatientBloodGroupToggledEvent),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(RawSpacing.extraSmall),
                child: Text(
                  'Office Address & Telephone No.',
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                height: getScreenHeight(context) * 0.2,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: controller.officeInformationTextEditingController,
                  keyboardType: TextInputType.streetAddress,
                  minLines: getScreenHeight(context) ~/ 50,
                  maxLines: null,
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(),
                    enabledBorder: AppTheme.textFieldInputEnabledBorder,
                    focusedBorder: AppTheme.textFieldInputFocusedBorder,
                    errorBorder: AppTheme.textFieldInputFocusedBorder,
                    hintStyle: AppTheme.hintTextStyle,
                    hintText: "Enter Office Address & Telephone No.",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(RawSpacing.extraSmall),
                child: Text(
                  'Reffered By',
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                    controller: controller.refferedByTextEditingController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      enabledBorder: AppTheme.textFieldInputEnabledBorder,
                      focusedBorder: AppTheme.textFieldInputFocusedBorder,
                      errorBorder: AppTheme.textFieldInputFocusedBorder,
                      hintStyle: AppTheme.hintTextStyle,
                      hintText: "Reffered By",
                    )),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(RawSpacing.extraSmall),
                child: Text('Medical Information : ',
                    style: AppTheme.subHeadingTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Family Doctor's Name",
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: controller.familyDoctorsName,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    enabledBorder: AppTheme.textFieldInputEnabledBorder,
                    focusedBorder: AppTheme.textFieldInputFocusedBorder,
                    errorBorder: AppTheme.textFieldInputFocusedBorder,
                    hintStyle: AppTheme.hintTextStyle,
                    hintText: "Enter Family Doctors Name",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Address & Telephone No.",
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                height: getScreenHeight(context) * 0.2,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: controller.familyDoctorsAddressAndTelephoneNo,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.streetAddress,
                  minLines: getScreenHeight(context) ~/ 50,
                  maxLines: null,
                  decoration: InputDecoration(
                    enabledBorder: AppTheme.textFieldInputEnabledBorder,
                    focusedBorder: AppTheme.textFieldInputFocusedBorder,
                    errorBorder: AppTheme.textFieldInputFocusedBorder,
                    hintStyle: AppTheme.hintTextStyle,
                    hintText: "Enter Address & Telephone No.",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              diseaseSelectionWidget(
                  context: context,
                  handlePatientDiseaseSelectionEvent:
                      controller.handlePatientDiseaseSelectionEvent,
                  selectedDiseases: initializedState.diseases),
              const SizedBox(height: 10),
              if (initializedState.sex == Sex.FEMALE)
                pregnancySelectionWidget(
                    context: context,
                    handlePatientPregnancyStatusInput:
                        controller.handlePatientPregnancyStatusInput,
                    status: initializedState.pregnancyStatus),
              if (initializedState.sex == Sex.FEMALE)
                childNursingStatus(
                    context: context,
                    handlePatientChildNursingStatus:
                        controller.handlePatientChildNursingStatus,
                    status: initializedState.childNursingStatus),
              habitSelectionWidget(
                  context: context,
                  selectedHabits: initializedState.habits,
                  handlePatientHabitSelection:
                      controller.handlePatientHabitSelection),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(RawSpacing.extraSmall),
                child: Text('Medication Information : ',
                    style: AppTheme.subHeadingTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "List Of Medicines you are taking currently",
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                height: getScreenHeight(context) * 0.15,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller:
                      controller.medicationInformationTextEditingController,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  minLines: getScreenHeight(context) ~/ 50,
                  maxLines: null,
                  decoration: InputDecoration(
                    enabledBorder: AppTheme.textFieldInputEnabledBorder,
                    focusedBorder: AppTheme.textFieldInputFocusedBorder,
                    errorBorder: AppTheme.textFieldInputFocusedBorder,
                    hintStyle: AppTheme.hintTextStyle,
                    hintText: "Enter Medications",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Allergies :",
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              allergiesSelectionWidget(
                  selectedAllergies: initializedState.allergies,
                  handlePatientAllergiesSelectionEvent:
                      controller.handlePatientAllergiesSelectionEvent,
                  context: context),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Any Other ",
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                height: getScreenHeight(context) * 0.15,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: controller.allergiesInformation,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  minLines: getScreenHeight(context) ~/ 50,
                  maxLines: null,
                  decoration: InputDecoration(
                    enabledBorder: AppTheme.textFieldInputEnabledBorder,
                    focusedBorder: AppTheme.textFieldInputFocusedBorder,
                    errorBorder: AppTheme.textFieldInputFocusedBorder,
                    hintStyle: AppTheme.hintTextStyle,
                    hintText: "Other allergies",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(RawSpacing.extraSmall),
                child: Text('Dental Information : ',
                    style: AppTheme.subHeadingTextStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "What is your main complain? *. ",
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                height: getScreenHeight(context) * 0.2,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: controller.mainDentalComplain,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Please enter the patient's main complain";
                    }
                    return null;
                  },
                  minLines: getScreenHeight(context) ~/ 50,
                  maxLines: null,
                  decoration: InputDecoration(
                    enabledBorder: AppTheme.textFieldInputEnabledBorder,
                    focusedBorder: AppTheme.textFieldInputFocusedBorder,
                    errorBorder: AppTheme.textFieldInputFocusedBorder,
                    focusedErrorBorder: AppTheme.textFieldInputFocusedBorder,
                    hintStyle: AppTheme.hintTextStyle,
                    hintText: "Enter your main complain",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "List any dental treatment done in the last one year ",
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                height: getScreenHeight(context) * 0.15,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: controller.pastDentalInformation,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  minLines: getScreenHeight(context) ~/ 50,
                  maxLines: null,
                  decoration: InputDecoration(
                    enabledBorder: AppTheme.textFieldInputEnabledBorder,
                    focusedBorder: AppTheme.textFieldInputFocusedBorder,
                    errorBorder: AppTheme.textFieldInputFocusedBorder,
                    hintStyle: AppTheme.hintTextStyle,
                    hintText: "List your dental treatments",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Additional Remarks",
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                height: getScreenHeight(context) * 0.15,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller:
                      controller.additionalInformationTextEditingController,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  minLines: getScreenHeight(context) ~/ 50,
                  maxLines: null,
                  decoration: InputDecoration(
                    enabledBorder: AppTheme.textFieldInputEnabledBorder,
                    focusedBorder: AppTheme.textFieldInputFocusedBorder,
                    errorBorder: AppTheme.textFieldInputFocusedBorder,
                    hintStyle: AppTheme.hintTextStyle,
                    hintText: "Enter any additional remarks",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 40,
                  margin: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    child: Container(
                      //Could Perform validation here
                      decoration: AppTheme.pageButtonBox,
                      child: Center(
                        child: Text(
                          "Submit",
                          style: AppTheme.pageButtonText,
                        ),
                      ),
                    ),
                    onTap: () {
                      final isValid = _form.currentState!.validate();

                      if (isValid) {
                        controller.submitUserData(
                            initializedState.dob,
                            initializedState.sex,
                            initializedState.createdAt,
                            initializedState.maritialStatus,
                            initializedState.bloodGroup,
                            initializedState.diseases,
                            initializedState.pregnancyStatus,
                            initializedState.childNursingStatus,
                            initializedState.habits,
                            initializedState.allergies,
                            initializedState.userImagePath,
                            initializedState.storedUserImageFilePath,
                            widget.params.inEditMode,
                            widget.params
                                .reloadPatientsMetaPageOnSuccessFullPatientAdditionOrEdition,
                            widget.params.patientId);
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please enter all the required fields');
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      )),
    );
  }

  // _validate(AddEditPatientController controller) {
  //   if (controller.nameTextEditingController.text.isEmpty) {
  //     return false;
  //   }
  //   if (controller.emailTextEditingController.text.isEmpty) {
  //     return false;
  //   }
  //   return true;
  // }

  _pickDateOfBirth(AddEditPatientController controller, BuildContext context,
      DateTime selectedDOB) async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 150),
      lastDate: DateTime.now(),
      initialDate: selectedDOB,
    );
    if (date != null) controller.handleDOBUpdation(date);
  }

  Widget _buildLoadingStateView(AddEditPatientController controller) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }

  Widget _buildInitializationStateView(AddEditPatientController controller,
      bool isInEditMode, String? patientId) {
    WidgetsBinding.instance.addPostFrameCallback((_) => controller
        .initializePage(isInEditMode: isInEditMode, patientId: patientId));
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }

  Widget _buildErrorStateView() {
    return Scaffold(
        body: Center(
      child: Text('Error'),
    ));
  }
}

class AddEditPatientPageParams {
  Function reloadPatientsMetaPageOnSuccessFullPatientAdditionOrEdition;
  bool inEditMode;
  String? patientId;
  AddEditPatientPageParams(
      {required this.reloadPatientsMetaPageOnSuccessFullPatientAdditionOrEdition,
      required this.inEditMode,
      this.patientId});
}
