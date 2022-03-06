import 'package:dentalApp/app/patientManagement/domain/entities/teethChart.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';
import 'package:flutter/material.dart';

Widget adultTeethChartWidget(final List<AdultTeethType> selectedAdultTeethType,
    final bool isEditable, final Function? handleAdultToothSelectionInput) {
  final List<AdultTeethType> upperJawAdultTeeth = [
    AdultTeethType.LU8,
    AdultTeethType.LU7,
    AdultTeethType.LU6,
    AdultTeethType.LU5,
    AdultTeethType.LU4,
    AdultTeethType.LU3,
    AdultTeethType.LU2,
    AdultTeethType.LU1,
    AdultTeethType.RU1,
    AdultTeethType.RU2,
    AdultTeethType.RU3,
    AdultTeethType.RU4,
    AdultTeethType.RU5,
    AdultTeethType.RU6,
    AdultTeethType.RU7,
    AdultTeethType.RU8,
  ];

  final List<AdultTeethType> lowerJawAdultTeeth = [
    AdultTeethType.LD8,
    AdultTeethType.LD7,
    AdultTeethType.LD6,
    AdultTeethType.LD5,
    AdultTeethType.LD4,
    AdultTeethType.LD3,
    AdultTeethType.LD2,
    AdultTeethType.LD1,
    AdultTeethType.RD1,
    AdultTeethType.RD2,
    AdultTeethType.RD3,
    AdultTeethType.RD4,
    AdultTeethType.RD5,
    AdultTeethType.RD6,
    AdultTeethType.RD7,
    AdultTeethType.RD8
  ];

  return Column(
    children: [
      Row(
        children: (upperJawAdultTeeth
            .map((teeth) => Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 120,
                        width: 50,
                        child: FittedBox(
                          child: Image.asset(
                            'assets/adultTeeth/${enumValueToString(teeth)}.jpeg',
                            alignment: Alignment.topCenter,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Checkbox(
                        value: selectedAdultTeethType.contains(teeth),
                        onChanged: (value) {
                          if (isEditable) {
                            handleAdultToothSelectionInput!(teeth);
                          }
                        },
                      )
                    ],
                  ),
                ))
            .toList()),
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        children: (lowerJawAdultTeeth
            .map((teeth) => Expanded(
                  child: Column(
                    children: <Widget>[
                      Checkbox(
                        value: selectedAdultTeethType.contains(teeth),
                        onChanged: (value) {
                          if (isEditable) {
                            handleAdultToothSelectionInput!(teeth);
                          }
                        },
                      ),
                      Container(
                        height: 120,
                        width: 50,
                        child: FittedBox(
                          child: Image.asset(
                            'assets/adultTeeth/${enumValueToString(teeth)}.jpeg',
                            alignment: Alignment.topCenter,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList()),
      )
    ],
  );
}
