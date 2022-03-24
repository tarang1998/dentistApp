import 'package:dentalApp/app/home/presentation/homeController.dart';
import 'package:dentalApp/app/home/presentation/homeStateMachine.dart';
import 'package:dentalApp/core/designSystem/fundamentals/colors.dart';
import 'package:dentalApp/core/designSystem/fundamentals/elevation.dart';
import 'package:dentalApp/core/designSystem/fundamentals/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class HomePage extends View {
  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends ResponsiveViewState<HomePage, HomePageController> {
  HomeViewState() : super(new HomePageController());

  @override
  Widget get desktopView => throw UnimplementedError();

  @override
  Widget get mobileView => ControlledWidgetBuilder<HomePageController>(
        builder: (context, controller) {
          final currentState = controller.getCurrentState();
          final currentStateType = controller.getCurrentState().runtimeType;

          print(
              "BuildMobileView of Home Page called with state $currentStateType");

          switch (currentStateType) {
            case HomePageInitializedState:
              HomePageInitializedState homePageInitializedState =
                  currentState as HomePageInitializedState;
              return _buildInitializedStateView(
                  homePageInitializedState, controller);

            case HomePageLoadingState:
              return _buildLoadingStateView(controller);

            case HomePageErrorState:
              HomePageErrorState errorState =
                  currentState as HomePageErrorState;
              return _buildErrorStateView();
          }

          throw Exception("Unrecognized state $currentStateType encountered");
        },
      );

  @override
  Widget get tabletView => mobileView; // View same as mobile

  @override
  Widget get watchView => throw UnimplementedError();

  Widget _buildInitializedStateView(
      HomePageInitializedState homePageInitializedState,
      HomePageController controller) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: controller.navigateToPatientsManagementPage,
              child: Padding(
                padding: const EdgeInsets.all(RawSpacing.medium),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: RawElevation.high,
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Column(
                          children: [
                            const Expanded(
                              child: IconButton(
                                onPressed: null,
                                iconSize: 85,
                                icon: Icon(
                                  Icons.person,
                                  color: RawColors.grey100,
                                ),
                              ),
                              flex: 3,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.red[300],
                                height: 100,
                                child: const Center(
                                  child: Text(
                                    'Patients',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 25,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              flex: 2,
                            )
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingStateView(HomePageController controller) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => controller.initializePage());

    return const CircularProgressIndicator();
  }

  Widget _buildErrorStateView() {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Text(
          'Error Page',
          style: TextStyle(
            color: Colors.red,
          ),
        )
      ],
    ));
  }
}
