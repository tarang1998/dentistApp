import 'package:dentalApp/app/patientManagement/data/keys/patientProcedureKeys.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/teethChart.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';

class AddPatientProcedureSerializer {
  Map<String, dynamic> serialize(PatientProcedureEnity patientProcedureEntity) {
    Map<String, dynamic> _patientProcedureSerializedData = {};

    _patientProcedureSerializedData[PatientProcedureKeys.keyProcedure] =
        enumValueToString(patientProcedureEntity.procedurePerformed);
    _patientProcedureSerializedData[PatientProcedureKeys.keyEstimatedCost] =
        patientProcedureEntity.estimatedCost;
    _patientProcedureSerializedData[PatientProcedureKeys.keyAmountPaid] =
        patientProcedureEntity.amountPaid;
    _patientProcedureSerializedData[PatientProcedureKeys
        .keyProcedurePerformedAt] = patientProcedureEntity.performedAt;
    _patientProcedureSerializedData[PatientProcedureKeys.keyNextVisit] =
        patientProcedureEntity.nextVisit;
    _patientProcedureSerializedData[PatientProcedureKeys.keyAdditionalRemarks] =
        patientProcedureEntity.additionalRemarks;

    _patientProcedureSerializedData[PatientProcedureKeys.keyTeethChart] = {};

    if (patientProcedureEntity.selectedTeethChart.runtimeType ==
        AdultTeethChart) {
      AdultTeethChart adultTeethChart =
          patientProcedureEntity.selectedTeethChart as AdultTeethChart;

      _patientProcedureSerializedData[PatientProcedureKeys.keyTeethChart]
              [PatientProcedureKeys.keyTeethChartType] =
          enumValueToString(TeethChartType.ADULT);

      List<String> selectedTeethValue = [];

      adultTeethChart.selectedValues.forEach((element) {
        selectedTeethValue.add(enumValueToString(element));
      });

      _patientProcedureSerializedData[PatientProcedureKeys.keyTeethChart]
              [PatientProcedureKeys.keyTeethChartSelectedValues] =
          selectedTeethValue;
    }

    if (patientProcedureEntity.selectedTeethChart.runtimeType ==
        ChildTeethType) {
      ChildTeethChart childTeethChart =
          patientProcedureEntity.selectedTeethChart as ChildTeethChart;

      _patientProcedureSerializedData[PatientProcedureKeys.keyTeethChart]
              [PatientProcedureKeys.keyTeethChartType] =
          enumValueToString(TeethChartType.CHILD);

      List<String> selectedTeethValue = [];

      childTeethChart.selectedValues.forEach((element) {
        selectedTeethValue.add(enumValueToString(element));
      });

      _patientProcedureSerializedData[PatientProcedureKeys.keyTeethChart]
              [PatientProcedureKeys.keyTeethChartSelectedValues] =
          selectedTeethValue;
    }

    return _patientProcedureSerializedData;
  }
}
