import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/core/designSystem/appTheme.dart';
import 'package:dentalApp/core/designSystem/fundamentals/colors.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';
import 'package:flutter/material.dart';

Widget maritialStatusSelectionWidget(
    {required MaritialStatus selectedMaritialStatus,
    required Function(MaritialStatus) handlePatientMaritialStatusToggledEvent,
    required BuildContext context}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Maritial Status',
          style: AppTheme.inputFieldTitleTextStyle,
        ),
        const SizedBox(height: 5),
        Wrap(
          children: MaritialStatus.values.map(
            (level) {
              final bool isSelected = level == selectedMaritialStatus;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => handlePatientMaritialStatusToggledEvent(level),
                    child: Chip(
                      label: Text(enumValueToString(level)),
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
