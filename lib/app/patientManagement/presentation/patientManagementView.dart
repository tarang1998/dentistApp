import 'package:dentalApp/app/patientManagement/presentation/patientManagementController.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientManagementStateMachine.dart';
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

            case PatientManagementInitializationState:
              return _buildInitializationStateView(controller);

            case PatientManagementLoadingState:
              return _buildLoadingStateView();

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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          controller.navigateToAddPatientPage();
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => controller.refreshPage(),
          child: Container(
            width: 300,
            margin: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: controller.scrollController,
              child: Column(
                children: <Widget>[
                  ...initializedState.patientsMetaInformation
                      .map((patientMeta) {
                    return GestureDetector(
                      onTap: () => controller.navigateToPatientInformationPage(
                          patientId: patientMeta.patientId),
                      child: Card(
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name : ${patientMeta.name}"),
                              Text("Age : ${patientMeta.dob}"),
                              Text("Sex : ${patientMeta.sex}")
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  if (controller.isFetchingNextPage)
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: const CircularProgressIndicator(),
                    ),
                ],
              ),
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

  Widget _buildInitializationStateView(PatientManagementController controller) {
    controller.fetchPatientsMeta();
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
