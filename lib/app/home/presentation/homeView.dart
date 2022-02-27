import 'package:dentalApp/app/home/presentation/homeController.dart';
import 'package:dentalApp/app/home/presentation/homeStateMachine.dart';
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
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.red,
                  height: 150,
                  width: 150,
                  child: Text('Patients'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingStateView(HomePageController controller) {
    WidgetsBinding.instance!
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
