import 'package:dentalApp/app/patientManagement/domain/entities/teethChart.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/viewProcedure/viewProcedureController.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/viewProcedure/viewProcedureStateMachine.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/widgets/adultTeethChartWidget.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/widgets/childTeethChartWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ViewProcedurePage extends View {
  final ViewProcedurePageParams params;

  ViewProcedurePage(this.params);

  @override
  State<StatefulWidget> createState() => ViewProcedurePageState();
}

class ViewProcedurePageState
    extends ResponsiveViewState<ViewProcedurePage, ViewProcedureController> {
  ViewProcedurePageState() : super(ViewProcedureController());

  @override
  Widget get desktopView => throw UnimplementedError();

  @override
  Widget get mobileView => ControlledWidgetBuilder<ViewProcedureController>(
        builder: (context, controller) {
          final currentState = controller.getCurrentState();
          final currentStateType = controller.getCurrentState().runtimeType;

          print(
              "BuildMobileView of ViewProcedurePage called with state $currentStateType");

          switch (currentStateType) {
            case ViewProcedureInitializedState:
              ViewProcedureInitializedState viewProcedureInitializedState =
                  currentState as ViewProcedureInitializedState;
              return _buildInitializedStateView(
                  viewProcedureInitializedState, controller);

            case ViewProcedureLoadingState:
              return _buildLoadingStateView(controller);

            case ViewProcedureInitializationState:
              return _buildInitializationStateView(widget.params.patientId,
                  widget.params.patientProcedureId, controller);

            case ViewProcedureErrorState:
              return _buildErrorStateView();
          }

          throw Exception(
              "Unrecognized state $currentStateType encountered in ViewProcedurePage");
        },
      );

  @override
  Widget get tabletView => mobileView; // View same as mobile

  @override
  Widget get watchView => throw UnimplementedError();

  Widget _buildInitializedStateView(
      ViewProcedureInitializedState initializedState,
      ViewProcedureController controller) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Procedure Performed  : ${initializedState.patientProcedureEnity.procedurePerformed}"),
              Text(
                  "Estimated Cost : ${initializedState.patientProcedureEnity.estimatedCost}"),
              Text(
                  "Amount Paid : ${initializedState.patientProcedureEnity.amountPaid}"),
              Text(
                  "Performed At : ${initializedState.patientProcedureEnity.performedAt}"),
              Text(
                  "Next Visit : ${initializedState.patientProcedureEnity.nextVisit}"),
              Text(
                  "Additional Remarks : ${initializedState.patientProcedureEnity.additionalRemarks}"),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Teeth Chart'),
              ),
              _displayTeethChart(initializedState)
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayTeethChart(ViewProcedureInitializedState initializedState) {
    if (initializedState.patientProcedureEnity.selectedTeethChart
        is AdultTeethChart) {
      AdultTeethChart adultTeethChart = initializedState
          .patientProcedureEnity.selectedTeethChart as AdultTeethChart;

      return adultTeethChartWidget(adultTeethChart.selectedValues, false, null);
    } else if (initializedState.patientProcedureEnity.selectedTeethChart
        is ChildTeethChart) {
      ChildTeethChart childTeethChart = initializedState
          .patientProcedureEnity.selectedTeethChart as ChildTeethChart;

      return childTeethChartWidget(childTeethChart.selectedValues, false, null);
    } else {
      throw Exception('Unknown value of teeth Chart encountered');
    }
  }

  Widget _buildLoadingStateView(ViewProcedureController controller) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }

  Widget _buildInitializationStateView(String patientId,
      String patientProcedureId, ViewProcedureController controller) {
    controller.getPatientProcedureInformation(
        patientId: patientId, procedureId: patientProcedureId);
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

class ViewProcedurePageParams {
  final String patientId;
  final String patientProcedureId;

  ViewProcedurePageParams(this.patientId, this.patientProcedureId);
}
