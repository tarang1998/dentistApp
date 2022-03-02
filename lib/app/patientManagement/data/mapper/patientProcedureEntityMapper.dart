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
        estimatedCost: patientProcedureData[PatientProcedureKeys.keyProcedure],
        amountPaid: patientProcedureData[PatientProcedureKeys.keyAmountPaid],
        performedAt:
            patientProcedureData[PatientProcedureKeys.keyProcedurePerformedAt],
        nextVisit: patientProcedureData[PatientProcedureKeys.keyNextVisit],
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

    if (teethChartData == TeethChartType.ADULT) {
      final List<AdultTeethType> selectedValues = [];

      final List<String> selectedValuesRawData =
          teethChartData[PatientProcedureKeys.keyTeethChartSelectedValues]
              as List<String>;

      selectedValuesRawData.forEach((element) {
        selectedValues.add(convertStringToEnum(AdultTeethType.values, element));
      });

      return AdultTeethChart(selectedValues: selectedValues);
    } else if (teethChartData == TeethChartType.CHILD) {
      final List<ChildTeethType> selectedValues = [];

      final List<String> selectedValuesRawData =
          teethChartData[PatientProcedureKeys.keyTeethChartSelectedValues]
              as List<String>;

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
