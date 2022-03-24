import 'package:dentalApp/app/patientManagement/domain/entities/teethChart.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/addEditProcedure/addEditProcedureController.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/addEditProcedure/addEditProcedureStateMachine.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/addEditProcedure/widgets/diagnosisSelectionWidget.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/addEditProcedure/widgets/procedureSelectionWidget.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/addEditProcedure/widgets/teethChartSelectionWidget.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/widgets/adultTeethChartWidget.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/widgets/childTeethChartWidget.dart';
import 'package:dentalApp/core/designSystem/appTheme.dart';
import 'package:dentalApp/core/designSystem/fundamentals/colors.dart';
import 'package:dentalApp/core/designSystem/fundamentals/spacing.dart';
import 'package:dentalApp/core/presentation/screenDimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddEditProcedurePage extends View {
  final AddEditProcedurePageParams params;
  AddEditProcedurePage({required this.params});

  @override
  State<StatefulWidget> createState() => AddEditProcedurePageState();
}

class AddEditProcedurePageState extends ResponsiveViewState<
    AddEditProcedurePage, AddEditProcedureController> {
  AddEditProcedurePageState() : super(AddEditProcedureController());

  final _patientProcedureForm =
      GlobalKey<FormState>(); //for storing form state.

  @override
  Widget get desktopView => throw UnimplementedError();

  @override
  Widget get mobileView => ControlledWidgetBuilder<AddEditProcedureController>(
        builder: (context, controller) {
          final currentState = controller.getCurrentState();
          final currentStateType = controller.getCurrentState().runtimeType;

          print(
              "BuildMobileView of AddEditProcedurePage called with state $currentStateType");

          switch (currentStateType) {
            case AddEditProcedureInitializedState:
              AddEditProcedureInitializedState
                  addEditProcedureInitializedState =
                  currentState as AddEditProcedureInitializedState;
              return _buildInitializedStateView(
                  addEditProcedureInitializedState, controller);

            case AddEditProcedureLoadingState:
              return _buildLoadingStateView(controller);

            case AddEditProcedureInitializationState:
              return _buildInitializationStateView(
                  controller, widget.params.patientId);

            case AddEditProcedureErrorState:
              return _buildErrorStateView();
          }

          throw Exception(
              "Unrecognized state $currentStateType encountered in AddEditProcedurePage");
        },
      );

  @override
  Widget get tabletView => mobileView; // View same as mobile

  @override
  Widget get watchView => throw UnimplementedError();

  Widget _buildInitializedStateView(
    AddEditProcedureInitializedState initializedState,
    AddEditProcedureController controller,
  ) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: _patientProcedureForm,
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
                        widget.params.isInEditMode
                            ? 'Edit Patient Procedure'
                            : 'Add Patient Procedure',
                        style: AppTheme.headingTextStyle),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Procedure Performed At',
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
                            "${initializedState.procedurePerformedAt.year}/${initializedState.procedurePerformedAt.month}/${initializedState.procedurePerformedAt.day}",
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
                onTap: () => _pickProcedurePerformedAt(
                    controller, context, initializedState.procedurePerformedAt),
              ),
              Padding(
                padding: EdgeInsets.all(RawSpacing.extraSmall),
                child: Text('Diagnosis : ',
                    style: AppTheme.inputFieldTitleTextStyle),
              ),
              diagnosisSelectionWidget(
                  selectedDiagnosis: initializedState.diagnosis,
                  handleDiagnosisSelectionEvent:
                      controller.handleDiagnosisInputEvent,
                  context: context),
              Padding(
                padding: EdgeInsets.all(RawSpacing.extraSmall),
                child: Text('Procedure Performed : ',
                    style: AppTheme.inputFieldTitleTextStyle),
              ),
              procedureSelectionWidget(
                  selectedProcedure: initializedState.procedurePerformed,
                  handlePatientProcedureSelectionEvent:
                      controller.handleProcedurePerformedInputEvent,
                  context: context),
              Padding(
                padding: EdgeInsets.all(RawSpacing.extraSmall),
                child:
                    Text('Teeth Chart : ', style: AppTheme.subHeadingTextStyle),
              ),
              teethChartSelectionWidget(
                  selectedTeethChartType: initializedState.teethChartType,
                  handleTeethChartSelectionEvent:
                      controller.handleTeethChartTypeInputEvent,
                  context: context),
              if (initializedState.teethChartType == TeethChartType.ADULT)
                adultTeethChartWidget(initializedState.selectedAdultTeeth, true,
                    controller.handleAdultToothSelectionInputEvent),
              if (initializedState.teethChartType == TeethChartType.CHILD)
                childTeethChartWidget(initializedState.selectedChildTeeth, true,
                    controller.handleChildToothSelectionInputEvent),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Next Visit At :',
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
                            "${initializedState.nextVisitAt.year}/${initializedState.nextVisitAt.month}/${initializedState.nextVisitAt.day}",
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
                onTap: () => _pickNextVisitAt(
                    controller, context, initializedState.nextVisitAt),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(RawSpacing.extraSmall),
                child: Text(
                  'Estimated Cost : ',
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please enter the Estimated Cost";
                      }
                      return null;
                    },
                    controller: controller.estimatedAmountTextEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: AppTheme.textFieldInputEnabledBorder,
                      focusedBorder: AppTheme.textFieldInputFocusedBorder,
                      errorBorder: AppTheme.textFieldInputFocusedBorder,
                      focusedErrorBorder: AppTheme.textFieldInputFocusedBorder,
                      hintStyle: AppTheme.hintTextStyle,
                      hintText: "Enter Estimated Cost",
                    )),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(RawSpacing.extraSmall),
                child: Text(
                  'Paid Amount : ',
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please enter the Paid Amount";
                      }
                      return null;
                    },
                    controller: controller.paidAmountTextEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: AppTheme.textFieldInputEnabledBorder,
                      focusedBorder: AppTheme.textFieldInputFocusedBorder,
                      errorBorder: AppTheme.textFieldInputFocusedBorder,
                      focusedErrorBorder: AppTheme.textFieldInputFocusedBorder,
                      hintStyle: AppTheme.hintTextStyle,
                      hintText: "Enter Paid Amount",
                    )),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(RawSpacing.extraSmall),
                child: Text(
                  'Additional Remarks : ',
                  style: AppTheme.inputFieldTitleTextStyle,
                ),
              ),
              Container(
                height: getScreenHeight(context) * 0.2,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: controller.additionalRemarksTextEditingController,
                  keyboardType: TextInputType.streetAddress,
                  minLines: getScreenHeight(context) ~/ 50,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(),
                    enabledBorder: AppTheme.textFieldInputEnabledBorder,
                    focusedBorder: AppTheme.textFieldInputFocusedBorder,
                    errorBorder: AppTheme.textFieldInputFocusedBorder,
                    hintStyle: AppTheme.hintTextStyle,
                    hintText: "Enter Any Additional Remarks",
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
                      child: const Center(
                        child: Text(
                          "Submit",
                          style: AppTheme.pageButtonText,
                        ),
                      ),
                    ),
                    onTap: () {
                      final isValid =
                          _patientProcedureForm.currentState!.validate();

                      if (isValid) {
                        controller.addEditProcedure(
                          isInEditMode: widget.params.isInEditMode,
                          procedureId: widget.params.procedureId,
                          patientId: initializedState.patientId,
                          procedurePerformed:
                              initializedState.procedurePerformed,
                          diagnosis: initializedState.diagnosis,
                          teethChartType: initializedState.teethChartType,
                          selectedAdultTeeth:
                              initializedState.selectedAdultTeeth,
                          selectedChildTeeth:
                              initializedState.selectedChildTeeth,
                          procedurePerformedAt:
                              initializedState.procedurePerformedAt,
                          nextVisitAt: initializedState.nextVisitAt,
                        );
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

  _pickProcedurePerformedAt(AddEditProcedureController controller,
      BuildContext context, DateTime procedurePerformedAt) async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 150),
      lastDate: DateTime.now(),
      initialDate: procedurePerformedAt,
    );
    if (date != null)
      controller.handleProcedurePerformedAtInput(procedurePerformedAt: date);
  }

  _pickNextVisitAt(AddEditProcedureController controller, BuildContext context,
      DateTime nextVisitAt) async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 150),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDate: nextVisitAt,
    );
    if (date != null) controller.handleNextVisitInput(nextVisitAt: date);
  }

  Widget _buildLoadingStateView(AddEditProcedureController controller) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }

  Widget _buildInitializationStateView(
      AddEditProcedureController controller, String patientId) {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        controller.initializePage(
            isInEditMode: widget.params.isInEditMode,
            patientId: patientId,
            procedureId: widget.params.procedureId));
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

class AddEditProcedurePageParams {
  final String patientId;
  final bool isInEditMode;
  final String? procedureId;
  AddEditProcedurePageParams(
      {required this.patientId, required this.isInEditMode, this.procedureId});
}
