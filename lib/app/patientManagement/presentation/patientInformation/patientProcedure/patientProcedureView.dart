import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/patientProcedureController.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/patientProcedureStateMachine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientProcedurePage extends View {
  final String patientId;

  PatientProcedurePage({required this.patientId});

  @override
  State<StatefulWidget> createState() => PatientProcedurePageState();
}

class PatientProcedurePageState extends ResponsiveViewState<
    PatientProcedurePage, PatientProcedureController> {
  PatientProcedurePageState() : super(PatientProcedureController());

  @override
  Widget get desktopView => throw UnimplementedError();

  @override
  Widget get mobileView => ControlledWidgetBuilder<PatientProcedureController>(
        builder: (context, controller) {
          final currentState = controller.getCurrentState();
          final currentStateType = controller.getCurrentState().runtimeType;

          print(
              "BuildMobileView of PatientProcedurePage called with state $currentStateType");

          switch (currentStateType) {
            case PatientProcedureInitializedState:
              PatientProcedureInitializedState
                  patientProcedureInitializedState =
                  currentState as PatientProcedureInitializedState;
              return _buildInitializedStateView(
                  patientProcedureInitializedState, controller);

            case PatientProcedureInitializationState:
              return _buildInitializationStateView(
                  controller, widget.patientId);

            case PatientProcedureLoadingState:
              return _buildLoadingStateView();

            case PatientProcedureErrorState:
              return _buildErrorStateView();
          }

          throw Exception(
              "Unrecognized state $currentStateType encountered in PatientProcedurePage");
        },
      );

  @override
  Widget get tabletView => mobileView; // View same as mobile

  @override
  Widget get watchView => throw UnimplementedError();

  Widget _buildInitializedStateView(
    PatientProcedureInitializedState initializedState,
    PatientProcedureController controller,
  ) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          controller.navigateToAddProcedurePage(
              patientId: initializedState.patientId);
        },
      ),
      body: SafeArea(
        child: Container(
          width: 300,
          margin: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              children: <Widget>[
                ...initializedState.patientProcedures.map((procedure) {
                  return GestureDetector(
                    onTap: () => {},
                    child: Card(
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Procedure Performed : ${procedure.procedurePerformed}'),
                            Text(
                                'Procedure Performed At : ${procedure.performedAt}'),
                            Text('Estimated Cost : ${procedure.estimatedCost}'),
                            Text('Amount paid : ${procedure.amountPaid}'),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingStateView() {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }

  Widget _buildInitializationStateView(
      PatientProcedureController controller, String patientId) {
    controller.initializePage(patientId: patientId);
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
