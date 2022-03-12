import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/core/designSystem/appTheme.dart';
import 'package:dentalApp/core/designSystem/fundamentals/colors.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';
import 'package:flutter/material.dart';

Widget diseaseSelectionWidget(
    {required List<Diseases> selectedDiseases,
    required Function(List<Diseases>) handlePatientDiseaseSelectionEvent,
    required BuildContext context}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Have you ever suffered from any of the following?',
          style: AppTheme.inputFieldTitleTextStyle,
        ),
        const SizedBox(height: 5),
        Wrap(
          children: Diseases.values.map(
            (element) {
              final bool isSelected = selectedDiseases.contains(element);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      if (selectedDiseases.contains(element)) {
                        selectedDiseases.remove(element);
                        handlePatientDiseaseSelectionEvent(selectedDiseases);
                      } else {
                        selectedDiseases.add(element);
                        handlePatientDiseaseSelectionEvent(selectedDiseases);
                      }
                    },
                    child: Chip(
                      label: Text(enumValueToString(element).capitalizeEnum),
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
