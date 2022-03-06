import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/presentation/AddEditPatient/AddEditPatientController.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/addEditPatientStateMachine.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';
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
            IconButton(
              onPressed: controller.navigateBack,
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Name'),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: controller.nameTextEditingController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                // onChanged: (val) => _subjectName = val.trim(),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Email'),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: controller.emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                // onChanged: (val) => _subjectName = val.trim(),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Date Of Birth'),
            ),
            GestureDetector(
              child: Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Text(
                          "${initializedState.dob.year}/${initializedState.dob.month}/${initializedState.dob.day}",
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
              child: Text('Sex'),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<Sex>(
                isExpanded: true,
                elevation: 0,
                iconSize: 30,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: Sex.values.map((Sex dropDownStringItem) {
                  return DropdownMenuItem<Sex>(
                    key: ValueKey(
                        '${enumValueToString(dropDownStringItem)}-item'),
                    value: dropDownStringItem,
                    child: Text(
                      enumValueToString(dropDownStringItem).toUpperCase(),
                    ),
                  );
                }).toList(),
                disabledHint: Text(
                  enumValueToString(initializedState.sex).toUpperCase(),
                ),
                onChanged: (Sex? newValueSelected) =>
                    controller.handleUserSexToggled(newValueSelected!),
                value: initializedState.sex,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Address'),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: controller.addressTextEditingController,
                keyboardType: TextInputType.streetAddress,
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
