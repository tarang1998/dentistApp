import 'package:dentalApp/app/patientManagement/presentation/patientManagementController.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientManagementStateMachine.dart';
import 'package:dentalApp/core/designSystem/fundamentals/elevation.dart';
import 'package:dentalApp/core/designSystem/fundamentals/spacing.dart';
import 'package:dentalApp/core/presentation/screenDimensions.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';
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
        backgroundColor: Colors.red[300],
        child: const Icon(Icons.add),
        onPressed: () {
          controller.navigateToAddPatientPage();
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => controller.refreshPage(),
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
                    'Patient List',
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
              height: getScreenHeight(context) * 0.89,
              padding: const EdgeInsets.all(RawSpacing.extraSmall),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                controller: controller.scrollController,
                child: Column(
                  children: <Widget>[
                    ...initializedState.patientsMetaInformation
                        .map((patientMeta) {
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
                            onTap: () =>
                                controller.navigateToPatientInformationPage(
                                    patientId: patientMeta.patientId),
                            leading: const Icon(
                              Icons.account_circle,
                              size: 45,
                            ),
                            title: Text(
                              '${patientMeta.name}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            isThreeLine: true,
                            subtitle: Text(
                                'Email : ${patientMeta.emailId}\nGender : ${enumValueToString(patientMeta.sex)}\nAge : ${DateTime.now().year - patientMeta.dob.year}'),
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
          ]),
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
