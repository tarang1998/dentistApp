import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/core/designSystem/appTheme.dart';
import 'package:dentalApp/core/designSystem/fundamentals/colors.dart';
import 'package:flutter/material.dart';

Widget pregnancySelectionWidget(
    {required PregnancyStatus status,
    required Function(PregnancyStatus) handlePatientPregnancyStatusInput,
    required BuildContext context}) {
  Map<PregnancyStatus, String> pregnancyStatusLabels = {
    PregnancyStatus.NOT_PREGNANT: "NO",
    PregnancyStatus.PREGNANT: "YES"
  };

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Are you pregnant?',
          style: AppTheme.inputFieldTitleTextStyle,
        ),
        const SizedBox(height: 5),
        Wrap(
          children: PregnancyStatus.values
              .where((level) => level != PregnancyStatus.NOT_APPLICABLE)
              .map(
            (element) {
              final bool isSelected = status == element;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => handlePatientPregnancyStatusInput(element),
                    child: Chip(
                      label: Text(pregnancyStatusLabels[element]!),
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
