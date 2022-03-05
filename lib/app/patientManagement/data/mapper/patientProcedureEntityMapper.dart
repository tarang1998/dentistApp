import 'package:dentalApp/app/patientManagement/data/keys/patientProcedureKeys.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/teethChart.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';

class PatientProcedureEntityMapper {
  PatientProcedureEnity map(Map<String, dynamic> patientProcedureData) {
    return PatientProcedureEnity(
        procedureId: patientProcedureData[PatientProcedureKeys.keyProcedureId],
        procedurePerformed: convertStringToEnum(
          Procedure.values,
          patientProcedureData[PatientProcedureKeys.keyProcedure],
        ),
        estimatedCost:
            patientProcedureData[PatientProcedureKeys.keyEstimatedCost],
        amountPaid: patientProcedureData[PatientProcedureKeys.keyAmountPaid],
        performedAt:
            patientProcedureData[PatientProcedureKeys.keyProcedurePerformedAt]
                .toDate(),
        nextVisit:
            patientProcedureData[PatientProcedureKeys.keyNextVisit].toDate(),
        additionalRemarks:
            patientProcedureData[PatientProcedureKeys.keyAdditionalRemarks],
        selectedTeethChart: _mapTeethChart(
            patientProcedureData[PatientProcedureKeys.keyTeethChart]
                as Map<String, dynamic>));
  }

  TeethChart _mapTeethChart(Map<String, dynamic> teethChartData) {
    final TeethChartType teethChartType = convertStringToEnum(
        TeethChartType.values,
        teethChartData[PatientProcedureKeys.keyTeethChartType]);

    if (teethChartType == TeethChartType.ADULT) {
      final List<AdultTeethType> selectedValues = [];

      final List<String> selectedValuesRawData = List<String>.from(
          teethChartData[PatientProcedureKeys.keyTeethChartSelectedValues]);

      selectedValuesRawData.forEach((element) {
        selectedValues.add(convertStringToEnum(AdultTeethType.values, element));
      });

      return AdultTeethChart(selectedValues: selectedValues);
    } else if (teethChartType == TeethChartType.CHILD) {
      final List<ChildTeethType> selectedValues = [];

      final List<String> selectedValuesRawData = List<String>.from(
          teethChartData[PatientProcedureKeys.keyTeethChartSelectedValues]);

      selectedValuesRawData.forEach((element) {
        selectedValues.add(convertStringToEnum(ChildTeethType.values, element));
      });

      return ChildTeethChart(selectedValues: selectedValues);
    } else {
      throw new Exception(
          'Unknown value of teeth chart encountered : $teethChartType');
    }
  }
}
