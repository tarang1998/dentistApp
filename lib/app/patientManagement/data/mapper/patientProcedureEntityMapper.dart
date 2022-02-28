import 'package:dentalApp/app/patientManagement/data/keys/patientProcedureKeys.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
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
            patientProcedureData[PatientProcedureKeys.keyAdditionalRemarks]);
  }
}
