import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientInformationController.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientInformationStateMachine.dart';
import 'package:dentalApp/core/designSystem/appTheme.dart';
import 'package:dentalApp/core/designSystem/fundamentals/colors.dart';
import 'package:dentalApp/core/designSystem/fundamentals/spacing.dart';
import 'package:dentalApp/core/presentation/screenDimensions.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';
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
    Map<BloodGroup, String> bloodGroupName = {
      BloodGroup.ABP: 'AB+',
      BloodGroup.ABN: 'AB-',
      BloodGroup.AP: 'A+',
      BloodGroup.AN: 'A-',
      BloodGroup.ON: 'O-',
      BloodGroup.OP: 'O+',
      BloodGroup.BP: 'B+',
      BloodGroup.BN: 'B-',
    };

    Map<PregnancyStatus, String> pregnancyStatusLabels = {
      PregnancyStatus.NOT_PREGNANT: "NO",
      PregnancyStatus.PREGNANT: "YES"
    };

    Map<ChildNursingStatus, String> childNursingStatus = {
      ChildNursingStatus.NURSING_CHILD: "YES",
      ChildNursingStatus.NOT_NURSING_CHILD: "NO"
    };
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  const Text(
                    'Patient Information',
                    style: TextStyle(
                      fontSize: 22,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.list_alt,
                      size: 25,
                    ),
                    onPressed: () => controller.navigateToPatientProcedurePage(
                        patientId: initializedState
                            .patientInformation
                            .patientPersonalInformation
                            .patientMetaInformation
                            .patientId),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: 25,
                    ),
                    onPressed: () => controller.navigateToEditPatientPage(
                        widget.params
                            .reloadPatientMetaPageOnPatientInformationEdition,
                        initializedState
                            .patientInformation
                            .patientPersonalInformation
                            .patientMetaInformation
                            .patientId),
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
                child: Padding(
                  padding: const EdgeInsets.all(RawSpacing.extraSmall),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Personal Information : ',
                          style: AppTheme.subHeadingTextStyle),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Name :',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(RawSpacing.extraSmall),
                        decoration: AppTheme.informationBox,
                        child: Text(
                          '${initializedState.patientInformation.patientPersonalInformation.patientMetaInformation.name}',
                          style: AppTheme.inputFieldTitleTextStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Email :',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(RawSpacing.extraSmall),
                        decoration: AppTheme.informationBox,
                        child: Text(
                          '${initializedState.patientInformation.patientPersonalInformation.patientMetaInformation.emailId}',
                          style: AppTheme.inputFieldTitleTextStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Address :',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(RawSpacing.extraSmall),
                        decoration: AppTheme.informationBox,
                        child: Text(
                          '${initializedState.patientInformation.patientPersonalInformation.address}',
                          style: AppTheme.inputFieldTitleTextStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Gender :',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(RawSpacing.extraSmall),
                        decoration: AppTheme.informationBox,
                        child: Text(
                          '${enumValueToString(initializedState.patientInformation.patientPersonalInformation.patientMetaInformation.sex)}',
                          style: AppTheme.inputFieldTitleTextStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Date Of Birth :',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(RawSpacing.extraSmall),
                        decoration: AppTheme.informationBox,
                        child: Text(
                          '${initializedState.patientInformation.patientPersonalInformation.patientMetaInformation.dob.day}/${initializedState.patientInformation.patientPersonalInformation.patientMetaInformation.dob.month}/${initializedState.patientInformation.patientPersonalInformation.patientMetaInformation.dob.year}',
                          style: AppTheme.inputFieldTitleTextStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Maritial Status :',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(RawSpacing.extraSmall),
                        decoration: AppTheme.informationBox,
                        child: Text(
                          '${enumValueToString(initializedState.patientInformation.patientPersonalInformation.maritialStatus)}',
                          style: AppTheme.inputFieldTitleTextStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Profession :',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(RawSpacing.extraSmall),
                        decoration: AppTheme.informationBox,
                        child: Text(
                          '${initializedState.patientInformation.patientPersonalInformation.profession}',
                          style: AppTheme.inputFieldTitleTextStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Mobile No :',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(RawSpacing.extraSmall),
                        decoration: AppTheme.informationBox,
                        child: Text(
                          '${initializedState.patientInformation.patientPersonalInformation.mobileNo}',
                          style: AppTheme.inputFieldTitleTextStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Telephone No :',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (initializedState.patientInformation
                                  .patientPersonalInformation.telephoneNo !=
                              null)
                          ? Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${initializedState.patientInformation.patientPersonalInformation.telephoneNo}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            )
                          : _emptyContainer(),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Blood Group :',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(RawSpacing.extraSmall),
                        decoration: AppTheme.informationBox,
                        child: Text(
                          '${bloodGroupName[initializedState.patientInformation.patientPersonalInformation.bloodGroup]}',
                          style: AppTheme.inputFieldTitleTextStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Office Address & Telephone No. :',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (initializedState
                                  .patientInformation
                                  .patientPersonalInformation
                                  .officeInformation !=
                              '')
                          ? Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${initializedState.patientInformation.patientPersonalInformation.officeInformation}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            )
                          : _emptyContainer(),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Reffered By :',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (initializedState.patientInformation
                                  .patientPersonalInformation.refferedBy !=
                              '')
                          ? Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${initializedState.patientInformation.patientPersonalInformation.refferedBy}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            )
                          : _emptyContainer(),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text('Medical Information : ',
                          style: AppTheme.subHeadingTextStyle),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Family Doctor's Name :",
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (initializedState.patientInformation
                                  .patientPersonalInformation.refferedBy !=
                              '')
                          ? Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${initializedState.patientInformation.patientMedicalInformation.familyDoctorsName}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            )
                          : _emptyContainer(),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Address & Telephone No. : ",
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (initializedState.patientInformation
                                  .patientPersonalInformation.refferedBy !=
                              '')
                          ? Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${initializedState.patientInformation.patientMedicalInformation.familyDoctorsAddressInformation}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            )
                          : _emptyContainer(),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Have you ever suffered from any of the following?',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        children: Diseases.values.map(
                          (element) {
                            final bool isSelected = initializedState
                                .patientInformation
                                .patientMedicalInformation
                                .diseases
                                .contains(element);
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Chip(
                                  label: Text(enumValueToString(element)
                                      .capitalizeEnum),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : RawColors.grey40,
                                  ),
                                  backgroundColor: isSelected
                                      ? RawColors.red300
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor,
                                  side: !isSelected
                                      ? const BorderSide(
                                          color: RawColors.grey30)
                                      : null,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      if (initializedState
                              .patientInformation
                              .patientPersonalInformation
                              .patientMetaInformation
                              .sex ==
                          Sex.FEMALE)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Are you pregnant?',
                              style: AppTheme.inputFieldTitleTextStyle,
                            ),
                            const SizedBox(height: 5),
                            Wrap(
                              children: PregnancyStatus.values
                                  .where((level) =>
                                      level != PregnancyStatus.NOT_APPLICABLE)
                                  .map(
                                (element) {
                                  final bool isSelected = initializedState
                                          .patientInformation
                                          .patientMedicalInformation
                                          .pregnancyStatus ==
                                      element;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 3.0),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Chip(
                                        label: Text(
                                            pregnancyStatusLabels[element]!),
                                        labelStyle: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : RawColors.grey40,
                                        ),
                                        backgroundColor: isSelected
                                            ? RawColors.red300
                                            : Theme.of(context)
                                                .scaffoldBackgroundColor,
                                        side: !isSelected
                                            ? const BorderSide(
                                                color: RawColors.grey30)
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            )
                          ],
                        ),
                      if (initializedState
                              .patientInformation
                              .patientPersonalInformation
                              .patientMetaInformation
                              .sex ==
                          Sex.FEMALE)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Are you nursing a child??',
                              style: AppTheme.inputFieldTitleTextStyle,
                            ),
                            const SizedBox(height: 5),
                            Wrap(
                              children: ChildNursingStatus.values
                                  .where((level) =>
                                      level !=
                                      ChildNursingStatus.NOT_APPLICABLE)
                                  .map(
                                (element) {
                                  final bool isSelected = initializedState
                                          .patientInformation
                                          .patientMedicalInformation
                                          .childNursingStatus ==
                                      element;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 3.0),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Chip(
                                        label:
                                            Text(childNursingStatus[element]!),
                                        labelStyle: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : RawColors.grey40,
                                        ),
                                        backgroundColor: isSelected
                                            ? RawColors.red300
                                            : Theme.of(context)
                                                .scaffoldBackgroundColor,
                                        side: !isSelected
                                            ? const BorderSide(
                                                color: RawColors.grey30)
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            )
                          ],
                        ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Habits',
                            style: AppTheme.inputFieldTitleTextStyle,
                          ),
                          const SizedBox(height: 5),
                          Wrap(
                            children: Habits.values.map(
                              (element) {
                                final bool isSelected = initializedState
                                    .patientInformation
                                    .patientMedicalInformation
                                    .habits
                                    .contains(element);
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3.0),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Chip(
                                      label: Text(enumValueToString(element)
                                          .capitalizeEnum),
                                      labelStyle: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : RawColors.grey40,
                                      ),
                                      backgroundColor: isSelected
                                          ? RawColors.red300
                                          : Theme.of(context)
                                              .scaffoldBackgroundColor,
                                      side: !isSelected
                                          ? const BorderSide(
                                              color: RawColors.grey30)
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text('Medication Information : ',
                          style: AppTheme.subHeadingTextStyle),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "List Of Medicines you are taking currently",
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (initializedState
                                  .patientInformation
                                  .patientMedicationInformation
                                  .medicationInformation !=
                              '')
                          ? Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${initializedState.patientInformation.patientMedicationInformation.medicationInformation}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            )
                          : _emptyContainer(),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Allergies :",
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Are you allergic to any of the following?',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        children: Allergies.values.map(
                          (element) {
                            final bool isSelected = initializedState
                                .patientInformation
                                .patientMedicationInformation
                                .allergies
                                .contains(element);
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Chip(
                                  label: Text(enumValueToString(element)
                                      .capitalizeEnum),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : RawColors.grey40,
                                  ),
                                  backgroundColor: isSelected
                                      ? RawColors.red300
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor,
                                  side: !isSelected
                                      ? const BorderSide(
                                          color: RawColors.grey30)
                                      : null,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Any Other ",
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      (initializedState
                                  .patientInformation
                                  .patientMedicationInformation
                                  .allergiesInformation !=
                              '')
                          ? Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${initializedState.patientInformation.patientMedicationInformation.allergiesInformation}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            )
                          : _emptyContainer(),
                      const SizedBox(height: 40),
                      const Text('Dental Information : ',
                          style: AppTheme.subHeadingTextStyle),
                      const SizedBox(height: 20),
                      const Text(
                        "What is your main complain?. ",
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(RawSpacing.extraSmall),
                        decoration: AppTheme.informationBox,
                        child: Text(
                          '${initializedState.patientInformation.patientDentalInformation.mainComplain}',
                          style: AppTheme.inputFieldTitleTextStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'List any dental treatment done in the last one year ',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(height: 5),
                      (initializedState
                                  .patientInformation
                                  .patientDentalInformation
                                  .pastDentalTreatmentInformation !=
                              '')
                          ? Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${initializedState.patientInformation.patientDentalInformation.pastDentalTreatmentInformation}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            )
                          : _emptyContainer(),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Additional Remarks',
                        style: AppTheme.inputFieldTitleTextStyle,
                      ),
                      const SizedBox(height: 5),
                      (initializedState
                                  .patientInformation.additionalInformation !=
                              '')
                          ? Container(
                              padding:
                                  const EdgeInsets.all(RawSpacing.extraSmall),
                              decoration: AppTheme.informationBox,
                              child: Text(
                                '${initializedState.patientInformation.additionalInformation}',
                                style: AppTheme.inputFieldTitleTextStyle,
                              ),
                            )
                          : _emptyContainer(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
  final Function reloadPatientMetaPageOnPatientInformationEdition;

  PatientInformationPageParams(
      this.patientId, this.reloadPatientMetaPageOnPatientInformationEdition);
}
