import 'package:dentist_app/app/patientManagement/presentation/patientManagementController.dart';
import 'package:dentist_app/app/patientManagement/presentation/patientManagementStateMachine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientManagementPage extends View {
  @override
  State<StatefulWidget> createState() => PatientManagementPageState();
}

class PatientManagementPageState extends ResponsiveViewState<
    PatientManagementPage, PatientManagementController> {
  PatientManagementPageState() : super(PatientManagementController());

  @override
  Widget get desktopView => throw UnimplementedError();

  @override
  Widget get mobileView => ControlledWidgetBuilder<PatientManagementController>(
        builder: (context, controller) {
          final currentState = controller.getCurrentState();
          final currentStateType = controller.getCurrentState().runtimeType;

          print(
              "BuildMobileView of PatientManagementPage called with state $currentStateType");

          switch (currentStateType) {
            case PatientManagementInitializedState:
              PatientManagementInitializedState
                  patientManagementInitializedState =
                  currentState as PatientManagementInitializedState;
              return _buildInitializedStateView(
                  patientManagementInitializedState, controller);

            case PatientManagementLoadingState:
              return _buildLoadingStateView(controller);

            case PatientManagementErrorState:
              return _buildErrorStateView();
          }

          throw Exception(
              "Unrecognized state $currentStateType encountered in PatientManagementPage");
        },
      );

  @override
  Widget get tabletView => mobileView; // View same as mobile

  @override
  Widget get watchView => throw UnimplementedError();

  Widget _buildInitializedStateView(
      PatientManagementInitializedState initializedState,
      PatientManagementController controller) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ...initializedState.patientsMetaInformation.map((patientMeta) {
              return Container(
                  child: Column(
                children: [
                  Text("Name : ${patientMeta.name}"),
                  Text("Age : ${patientMeta.age}"),
                  Text("Sex : ${patientMeta.sex}")
                ],
              ));
            })
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingStateView(PatientManagementController controller) {
    controller.fetchPatientsMeta();
    return const CircularProgressIndicator();
  }

  Widget _buildErrorStateView() {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Text(
          'Error',
          style: TextStyle(
            color: Colors.red,
          ),
        )
      ],
    ));
  }
}
