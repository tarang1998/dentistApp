import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/teethChart.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/addProcedure/addProcedureController.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/addProcedure/addProcedureStateMachine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AddProcedurePage extends View {
  final AddProcedurePageParams params;
  AddProcedurePage({required this.params});

  @override
  State<StatefulWidget> createState() => AddProcedurePageState();
}

class AddProcedurePageState
    extends ResponsiveViewState<AddProcedurePage, AddProcedureController> {
  AddProcedurePageState() : super(AddProcedureController());

  @override
  Widget get desktopView => throw UnimplementedError();

  @override
  Widget get mobileView => ControlledWidgetBuilder<AddProcedureController>(
        builder: (context, controller) {
          final currentState = controller.getCurrentState();
          final currentStateType = controller.getCurrentState().runtimeType;

          print(
              "BuildMobileView of AddProcedurePage called with state $currentStateType");

          switch (currentStateType) {
            case AddProcedureInitializedState:
              AddProcedureInitializedState addProcedureInitializedState =
                  currentState as AddProcedureInitializedState;
              return _buildInitializedStateView(
                  addProcedureInitializedState, controller);

            case AddProcedureLoadingState:
              return _buildLoadingStateView(controller);

            case AddProcedureInitializationState:
              return _buildInitializationStateView(
                  controller, widget.params.patientId);

            case AddProcedureErrorState:
              return _buildErrorStateView();
          }

          throw Exception(
              "Unrecognized state $currentStateType encountered in AddProcedurePage");
        },
      );

  @override
  Widget get tabletView => mobileView; // View same as mobile

  @override
  Widget get watchView => throw UnimplementedError();

  Widget _buildInitializedStateView(
    AddProcedureInitializedState initializedState,
    AddProcedureController controller,
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
              child: Text('Procedure Performed'),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<Procedure>(
                isExpanded: true,
                value: initializedState.procedurePerformed,
                // iconEnabledColor: AppTheme.primaryColor,
                // dropdownColor: AppTheme.colorDropDownItems,
                // style: AppTheme.dropDownItemTextStyle,
                onChanged: (value) =>
                    {controller.handleProcedurePerformedInputEvent(value)},
                items: [
                  DropdownMenuItem<Procedure>(
                    value: null,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Select Procedure')),
                  ),
                  ...Procedure.values
                      .map((e) => DropdownMenuItem<Procedure>(
                            value: e,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${e}'),
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Select Teeth Chart'),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<TeethChartType>(
                isExpanded: true,
                value: initializedState.teethChartType,
                // iconEnabledColor: AppTheme.primaryColor,
                // dropdownColor: AppTheme.colorDropDownItems,
                // style: AppTheme.dropDownItemTextStyle,
                onChanged: (value) =>
                    {controller.handleTeethChartTypeInputEvent(value)},
                items: [
                  DropdownMenuItem<TeethChartType>(
                    value: null,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Select Teeth Chart')),
                  ),
                  ...TeethChartType.values
                      .map((e) => DropdownMenuItem<TeethChartType>(
                            value: e,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${e}'),
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Procedure Performed At'),
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
                          "${initializedState.procedurePerformedAt.year}/${initializedState.procedurePerformedAt.month}/${initializedState.procedurePerformedAt.day}",
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Next Visit At'),
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
                          "${initializedState.nextVisitAt.year}/${initializedState.nextVisitAt.month}/${initializedState.nextVisitAt.day}",
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
              padding: const EdgeInsets.all(8),
              child: Text('Estimated Cost'),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: controller.estimatedAmountTextEditingController,
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.words,
                // onChanged: (val) => _subjectName = val.trim(),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Paid amount'),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: controller.paidAmountTextEditingController,
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.words,
                // onChanged: (val) => _subjectName = val.trim(),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Additional Remarks'),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: controller.additionalRemarksTextEditingController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                // onChanged: (val) => _subjectName = val.trim(),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                controller.addProcedure(
                    patientId: initializedState.patientId,
                    procedurePerformed: initializedState.procedurePerformed,
                    teethChartType: initializedState.teethChartType,
                    selectedAdultTeeth: initializedState.selectedAdultTeeth,
                    selectedChildTeeth: initializedState.selectedChildTeeth,
                    procedurePerformedAt: initializedState.procedurePerformedAt,
                    nextVisitAt: initializedState.nextVisitAt,
                    reloadPatientProceduresPageOnSuccessfullProcedureAddition:
                        widget.params
                            .reloadPatientProceduresPageOnSuccessfullProcedureAddition);
              },
              child: Container(
                height: 30,
                color: Colors.blue,
                child: Text('Add Procedure'),
              ),
            )
          ],
        ),
      )),
    );
  }

  _pickProcedurePerformedAt(AddProcedureController controller,
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

  _pickNextVisitAt(AddProcedureController controller, BuildContext context,
      DateTime nextVisitAt) async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 150),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDate: nextVisitAt,
    );
    if (date != null) controller.handleNextVisitInput(nextVisitAt: date);
  }

  Widget _buildLoadingStateView(AddProcedureController controller) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }

  Widget _buildInitializationStateView(
      AddProcedureController controller, String patientId) {
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => controller.initializePage(patientId: patientId));
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

class AddProcedurePageParams {
  final String patientId;
  final Function reloadPatientProceduresPageOnSuccessfullProcedureAddition;
  AddProcedurePageParams(
      {required this.patientId,
      required this.reloadPatientProceduresPageOnSuccessfullProcedureAddition});
}
