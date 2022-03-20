import 'package:dentalApp/app/patientManagement/domain/entities/teethChart.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/viewProcedure/viewProcedureController.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/viewProcedure/viewProcedureStateMachine.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/widgets/adultTeethChartWidget.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/widgets/childTeethChartWidget.dart';
import 'package:dentalApp/core/designSystem/appTheme.dart';
import 'package:dentalApp/core/designSystem/fundamentals/spacing.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(RawSpacing.extraSmall),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                      ),
                      onPressed: () => controller.navigateBack(),
                    ),
                    const Text(
                      'Procedure Information',
                      style: TextStyle(
                        fontSize: 22,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 25,
                      ),
                      onPressed: () =>
                          controller.navigateToEditPatientProcedureView(
                              patientId: initializedState.patientId,
                              procedureId: initializedState
                                  .patientProcedureEnity.procedureId),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(RawSpacing.extraSmall),
                  child: Padding(
                      padding: const EdgeInsets.all(RawSpacing.extraSmall),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Procedure Performed At :',
                              style: AppTheme.inputFieldTitleTextStyle,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${initializedState.patientProcedureEnity.performedAt.day}/${initializedState.patientProcedureEnity.performedAt.month}/${initializedState.patientProcedureEnity.performedAt.year}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Diagnosis :',
                              style: AppTheme.inputFieldTitleTextStyle,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${enumValueToString(initializedState.patientProcedureEnity.diagnosis).capitalizeEnum}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Procedure Performed :',
                              style: AppTheme.inputFieldTitleTextStyle,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${enumValueToString(initializedState.patientProcedureEnity.procedurePerformed).capitalizeEnum}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Teeth Chart :',
                              style: AppTheme.inputFieldTitleTextStyle,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            _displayTeethChart(initializedState),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Next Visit At :',
                              style: AppTheme.inputFieldTitleTextStyle,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${initializedState.patientProcedureEnity.nextVisit.day}/${initializedState.patientProcedureEnity.nextVisit.month}/${initializedState.patientProcedureEnity.nextVisit.year}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Estimated Cost :',
                              style: AppTheme.inputFieldTitleTextStyle,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${initializedState.patientProcedureEnity.estimatedCost}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Paid Amount :',
                              style: AppTheme.inputFieldTitleTextStyle,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${initializedState.patientProcedureEnity.amountPaid}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Additional Remarks :',
                              style: AppTheme.inputFieldTitleTextStyle,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: initializedState.patientProcedureEnity
                                          .additionalRemarks !=
                                      ''
                                  ? Text(
                                      '${initializedState.patientProcedureEnity.additionalRemarks}',
                                      style: AppTheme.inputFieldTitleTextStyle,
                                    )
                                  : _emptyContainer(),
                            ),
                          ]))),
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

  Widget _emptyContainer() {
    return Container(
      padding: const EdgeInsets.all(RawSpacing.extraSmall),
      decoration: AppTheme.informationBox,
      child: Text(
        '                          ',
        style: AppTheme.inputFieldTitleTextStyle,
      ),
    );
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
