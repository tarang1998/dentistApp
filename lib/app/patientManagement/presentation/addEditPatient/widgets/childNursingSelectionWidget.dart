import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/core/designSystem/appTheme.dart';
import 'package:dentalApp/core/designSystem/fundamentals/colors.dart';
import 'package:flutter/material.dart';

Widget childNursingStatus(
    {required ChildNursingStatus status,
    required Function(ChildNursingStatus) handlePatientChildNursingStatus,
    required BuildContext context}) {
  Map<ChildNursingStatus, String> childNursingStatus = {
    ChildNursingStatus.NURSING_CHILD: "YES",
    ChildNursingStatus.NOT_NURSING_CHILD: "NO"
  };

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Are you nursing a child?',
          style: AppTheme.inputFieldTitleTextStyle,
        ),
        const SizedBox(height: 5),
        Wrap(
          children: ChildNursingStatus.values
              .where((level) => level != ChildNursingStatus.NOT_APPLICABLE)
              .map(
            (element) {
              final bool isSelected = status == element;
              if (element != ChildNursingStatus.NOT_APPLICABLE) {}
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => handlePatientChildNursingStatus(element),
                    child: Chip(
                      label: Text(childNursingStatus[element]!),
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
