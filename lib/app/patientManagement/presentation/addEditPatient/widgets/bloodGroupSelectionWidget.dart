import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/core/designSystem/appTheme.dart';
import 'package:dentalApp/core/designSystem/fundamentals/colors.dart';
import 'package:flutter/material.dart';

Widget bloodGroupSelectionWidget(
    {required BloodGroup selectedBloodGroup,
    required Function(BloodGroup) handlePatientBloodGroupToggledEvent,
    required BuildContext context}) {
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

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Blood Group',
          style: AppTheme.inputFieldTitleTextStyle,
        ),
        const SizedBox(height: 5),
        Wrap(
          children: BloodGroup.values.map(
            (level) {
              final bool isSelected = level == selectedBloodGroup;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => handlePatientBloodGroupToggledEvent(level),
                    child: Chip(
                      label: Text(bloodGroupName[level]!),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : RawColors.grey40,
                      ),
                      backgroundColor: isSelected
                          ? RawColors.red300
                          : Theme.of(context).scaffoldBackgroundColor,
                      side: !isSelected
                          ? const BorderSide(color: RawColors.grey30)
                          : null,
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        )
      ],
    ),
  );
}
