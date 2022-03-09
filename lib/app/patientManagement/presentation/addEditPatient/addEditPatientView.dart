import 'package:dentalApp/app/patientManagement/presentation/AddEditPatient/AddEditPatientController.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/addEditPatientStateMachine.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/widgets/genderSelectionWidget.dart';
import 'package:dentalApp/core/designSystem/appTheme.dart';
import 'package:dentalApp/core/designSystem/fundamentals/colors.dart';
import 'package:dentalApp/core/designSystem/fundamentals/spacing.dart';
import 'package:dentalApp/core/presentation/screenDimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AddEditPatientPage extends View {
  final AddEditPatientPageParams params;
  AddEditPatientPage(this.params);

  @override
  State<StatefulWidget> createState() => AddEditPatientPageState();
}

class AddEditPatientPageState
    extends ResponsiveViewState<AddEditPatientPage, AddEditPatientController> {
  AddEditPatientPageState() : super(AddEditPatientController());

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
                  Text('Patient Registration Form',
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
              child: Text(
                'Name',
                style: AppTheme.inputFieldTitleTextStyle,
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: controller.nameTextEditingController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  enabledBorder: AppTheme.textFieldInputEnabledBorder,
                  focusedBorder: AppTheme.textFieldInputFocusedBorder,
                  errorBorder: AppTheme.textFieldInputFocusedBorder,
                  hintStyle: AppTheme.hintTextStyle,
                  hintText: "Enter Patient's Name",
                ),
                // onChanged: (val) => _subjectName = val.trim(),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(RawSpacing.extraSmall),
              child: Text(
                'Email Id',
                style: AppTheme.inputFieldTitleTextStyle,
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: controller.emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabledBorder: AppTheme.textFieldInputEnabledBorder,
                  focusedBorder: AppTheme.textFieldInputFocusedBorder,
                  errorBorder: AppTheme.textFieldInputFocusedBorder,
                  hintStyle: AppTheme.hintTextStyle,
                  hintText: "Enter Patient's Email Id",
                ),
                // onChanged: (val) => _subjectName = val.trim(),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Address',
                style: AppTheme.inputFieldTitleTextStyle,
              ),
            ),
            Container(
              height: getScreenHeight(context) * 0.2,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: controller.addressTextEditingController,
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
                  hintText: "Enter Patient's Address",
                ),
                // onChanged: (val) => _subjectName = val.trim(),
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
                          style:
                              TextStyle(color: RawColors.grey70, fontSize: 16),
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Phone No'),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: controller.phoneNoTextEditingController,
                keyboardType: TextInputType.phone,
                // onChanged: (val) => _subjectName = val.trim(),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Additional Information'),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller:
                    controller.additionalInformationTextEditingController,
                keyboardType: TextInputType.text,
                // onChanged: (val) => _subjectName = val.trim(),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => controller.validateUserData(
                  initializedState.dob,
                  initializedState.sex,
                  initializedState.createdAt,
                  widget.params.inEditMode,
                  widget.params
                      .reloadPatientsMetaPageOnSuccessFullPatientAdditionOrEdition,
                  widget.params.patientId),
              child: Container(
                height: 50,
                color: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

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
    WidgetsBinding.instance!.addPostFrameCallback((_) => controller
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
