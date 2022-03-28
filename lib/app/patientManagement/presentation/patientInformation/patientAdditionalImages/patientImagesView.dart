import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientAdditionalImages/patientImagesController.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientAdditionalImages/patientImagesStateMachine.dart';
import 'package:dentalApp/core/designSystem/fundamentals/elevation.dart';
import 'package:dentalApp/core/designSystem/fundamentals/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientImagePage extends View {
  final PatientImagePageParams params;
  PatientImagePage(this.params);
  @override
  State<StatefulWidget> createState() => PatientImagePageState();
}

class PatientImagePageState
    extends ResponsiveViewState<PatientImagePage, PatientImageController> {
  PatientImagePageState() : super(PatientImageController());

  @override
  Widget get desktopView => throw UnimplementedError();

  @override
  Widget get mobileView => ControlledWidgetBuilder<PatientImageController>(
        builder: (context, controller) {
          final currentState = controller.getCurrentState();
          final currentStateType = controller.getCurrentState().runtimeType;

          print(
              "BuildMobileView of PatientImagePage called with state $currentStateType");

          switch (currentStateType) {
            case PatientImageInitializedState:
              PatientImageInitializedState patientImageInitializedState =
                  currentState as PatientImageInitializedState;
              return _buildInitializedStateView(
                  patientImageInitializedState, controller);

            case PatientImageInitializationState:
              return _buildInitializationStateView(controller);

            case PatientImageLoadingState:
              return _buildLoadingStateView();

            case PatientImageErrorState:
              return _buildErrorStateView();
          }

          throw Exception(
              "Unrecognized state $currentStateType encountered in PatientImagePage");
        },
      );

  @override
  Widget get tabletView => mobileView; // View same as mobile

  @override
  Widget get watchView => throw UnimplementedError();

  Widget _buildInitializedStateView(
      PatientImageInitializedState initializedState,
      PatientImageController controller) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(children: [
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
                  Text(
                    'Patient Images',
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
              padding: const EdgeInsets.all(RawSpacing.extraSmall),
              child: Column(
                children: <Widget>[
                  ...initializedState.downloadableImageUris.map((element) {
                    return Container(
                      margin: const EdgeInsets.all(RawSpacing.extraSmall),
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: RawElevation.high,
                          child: Image.network(
                            element,
                            loadingBuilder: (BuildContext ctx, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Container(
                                  height: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                          )),
                    );
                  }),
                ],
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

  Widget _buildInitializationStateView(PatientImageController controller) {
    controller.initializePage(widget.params.patientId);
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

class PatientImagePageParams {
  final String patientId;
  PatientImagePageParams({required this.patientId});
}
