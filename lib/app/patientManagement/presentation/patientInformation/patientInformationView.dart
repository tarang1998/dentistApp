import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientInformationController.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientInformationStateMachine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientInformationPage extends View {
  final PatientInformationPageParams params;

  PatientInformationPage(this.params);

  @override
  State<StatefulWidget> createState() => PatientInformationPageState();
}

class PatientInformationPageState extends ResponsiveViewState<
    PatientInformationPage, PatientInformationController> {
  PatientInformationPageState() : super(PatientInformationController());

  @override
  Widget get desktopView => throw UnimplementedError();

  @override
  Widget get mobileView =>
      ControlledWidgetBuilder<PatientInformationController>(
        builder: (context, controller) {
          final currentState = controller.getCurrentState();
          final currentStateType = controller.getCurrentState().runtimeType;

          print(
              "BuildMobileView of PatientInformationPage called with state $currentStateType");

          switch (currentStateType) {
            case PatientInformationInitializedState:
              PatientInformationInitializedState
                  patientInformationInitializedState =
                  currentState as PatientInformationInitializedState;
              return _buildInitializedStateView(
                  patientInformationInitializedState, controller);

            case PatientInformationLoadingState:
              return _buildLoadingStateView(controller);

            case PatientInformationInitializationState:
              return _buildInitializationStateView(
                  widget.params.patientId, controller);

            case PatientInformationErrorState:
              return _buildErrorStateView();
          }

          throw Exception(
              "Unrecognized state $currentStateType encountered in PatientInformationPage");
        },
      );

  @override
  Widget get tabletView => mobileView; // View same as mobile

  @override
  Widget get watchView => throw UnimplementedError();

  Widget _buildInitializedStateView(
      PatientInformationInitializedState initializedState,
      PatientInformationController controller) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Name : ${initializedState.patientInformation.patientMetaInformation.name}"),
              Text(
                  "Age : ${initializedState.patientInformation.patientMetaInformation.dob}"),
              Text(
                  "Sex : ${initializedState.patientInformation.patientMetaInformation.sex}"),
              Text(
                  "Email Id  : ${initializedState.patientInformation.emailId}"),
              Text(
                  "Phone No  : ${initializedState.patientInformation.phoneNo}"),
              Text("Address  : ${initializedState.patientInformation.address}"),
              Text(
                  "Created At  : ${initializedState.patientInformation.createdAt}"),
              Text(
                  "Additional Information : ${initializedState.patientInformation.additionalInformation}")
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingStateView(PatientInformationController controller) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }

  Widget _buildInitializationStateView(
      String patientId, PatientInformationController controller) {
    controller.fetchPatientData(patientId);
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

class PatientInformationPageParams {
  final String patientId;

  PatientInformationPageParams(this.patientId);
}
