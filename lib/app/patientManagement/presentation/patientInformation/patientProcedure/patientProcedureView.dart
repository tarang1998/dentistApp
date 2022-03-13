import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/patientProcedureController.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/patientProcedureStateMachine.dart';
import 'package:dentalApp/core/designSystem/fundamentals/colors.dart';
import 'package:dentalApp/core/designSystem/fundamentals/elevation.dart';
import 'package:dentalApp/core/designSystem/fundamentals/spacing.dart';
import 'package:dentalApp/core/presentation/screenDimensions.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';
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
        backgroundColor: Colors.red[300],
        child: const Icon(Icons.add),
        onPressed: () {
          // controller.navigateToAddProcedurePage(
          //     patientId: initializedState.patientId);
        },
      ),
      body: SafeArea(
        child: Column(children: [
          Container(
            height: getScreenHeight(context) * 0.05,
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
                Text(
                  'Patient Procedures',
                  style: const TextStyle(
                    fontSize: 22,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(RawSpacing.extraSmall),
            width: getScreenWidth(context),
            padding: const EdgeInsets.all(RawSpacing.extraSmall),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Estimated Cost : ${initializedState.totalEstimatedCost}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: RawColors.grey50),
                ),
                Text(
                  'Total Amount Cost : ${initializedState.totalAmountPaid}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: RawColors.grey50),
                ),
              ],
            ),
          ),
          Container(
            height: getScreenHeight(context) * 0.8,
            padding: const EdgeInsets.all(RawSpacing.extraSmall),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: <Widget>[
                  ...initializedState.patientProcedures
                      .map((patientProcedures) {
                    return Container(
                      margin: const EdgeInsets.all(RawSpacing.extraSmall),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: RawElevation.high,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(18),
                          hoverColor: Colors.white,
                          onTap: () => null,
                          title: Text(
                            '${enumValueToString(patientProcedures.procedurePerformed).capitalizeEnum}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          isThreeLine: true,
                          subtitle: Text(
                              'Estimated Cost : ${patientProcedures.estimatedCost} \nAmount Paid : ${patientProcedures.amountPaid} \nProcedure Performed : ${patientProcedures.performedAt.day}/${patientProcedures.performedAt.month}/${patientProcedures.performedAt.year}'),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ]),
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
