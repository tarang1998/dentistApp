import 'package:dentalApp/app/patientManagement/domain/entities/teethChart.dart';
import 'package:dentalApp/core/designSystem/fundamentals/elevation.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';
import 'package:flutter/material.dart';

Widget childTeethChartWidget(final List<ChildTeethType> selectedChildTeethType,
    final bool isEditable, final Function? handleChildToothSelectionInput) {
  final List<ChildTeethType> upperJawChildTeeth = [
    ChildTeethType.LUE,
    ChildTeethType.LUD,
    ChildTeethType.LUC,
    ChildTeethType.LUB,
    ChildTeethType.LUA,
    ChildTeethType.RUA,
    ChildTeethType.RUB,
    ChildTeethType.RUC,
    ChildTeethType.RUD,
    ChildTeethType.RUE,
  ];

  final List<ChildTeethType> lowerJawChildTeeth = [
    ChildTeethType.LDE,
    ChildTeethType.LDD,
    ChildTeethType.LDC,
    ChildTeethType.LDB,
    ChildTeethType.LDA,
    ChildTeethType.RDA,
    ChildTeethType.RDB,
    ChildTeethType.RDC,
    ChildTeethType.RDD,
    ChildTeethType.RDE,
  ];

  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: RawElevation.high,
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: Column(
          children: [
            Row(
              children: (upperJawChildTeeth
                  .map((teeth) => Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 110,
                              width: 40,
                              child: FittedBox(
                                child: Image.asset(
                                  'assets/childTeeth/${enumValueToString(teeth)}.jpeg',
                                  alignment: Alignment.topCenter,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Checkbox(
                              value: selectedChildTeethType.contains(teeth),
                              onChanged: (value) {
                                if (isEditable) {
                                  handleChildToothSelectionInput!(teeth);
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
              children: (lowerJawChildTeeth
                  .map((teeth) => Expanded(
                        child: Column(
                          children: <Widget>[
                            Checkbox(
                              value: selectedChildTeethType.contains(teeth),
                              onChanged: (value) {
                                if (isEditable) {
                                  handleChildToothSelectionInput!(teeth);
                                }
                              },
                            ),
                            Container(
                              height: 120,
                              width: 50,
                              child: FittedBox(
                                child: Image.asset(
                                  'assets/childTeeth/${enumValueToString(teeth)}.jpeg',
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
        ),
      ),
    ),
  );
}
