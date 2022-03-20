import 'package:dentalApp/app/patientManagement/domain/entities/teethChart.dart';

class PatientProcedureEnity {
  final String procedureId;
  final Procedure procedurePerformed;
  final Diagnosis diagnosis;
  final num estimatedCost;
  final num amountPaid;
  final DateTime performedAt;
  final DateTime nextVisit;
  final String additionalRemarks;
  final TeethChart? selectedTeethChart;

  PatientProcedureEnity(
      {required this.procedureId,
      required this.procedurePerformed,
      required this.diagnosis,
      required this.estimatedCost,
      required this.amountPaid,
      required this.performedAt,
      required this.nextVisit,
      required this.additionalRemarks,
      required this.selectedTeethChart});
}

enum Procedure {
  SILVER_FILLING,
  COMPOSITE_FILLING,
  PIT_SEALANT,
  ROOT_CANAL_TREATMENT,
  PULPOTOMY,
  EXTRACTION,
  X_RAY,
  SCALING_AND_POLISHING,
  IMPACTION,
  GINGIVECTOMY,
  BLEACHING,
  POST_AND_CORE,
  MIRACLE_MIX,
  GLASS_IONOMER,
  CROWN,
  BRIDGE,
  DENTURES,
  IMPLANTS,
  ORTHODONTICS,
  REGULAR_RECALL,
  VENEERS
}

enum Diagnosis {
  CARIES,
  ABRASION,
  FILLED_AMALGAM,
  FILLED_COMPOSITE,
  FILLED_OTHER,
  DEEP_PIT,
  FILLED_AND_DECAYED,
  FRACTURED,
  ROOT_PIECES,
  MISSING,
  DIASTEMA,
  DISCOLOURED,
  BLEEDING_GUMS,
  PAIN_ON_PERCUSSION,
  EXISTING_PROSTHESIS,
  SWELLING,
  PERICORONITIS,
  NON_VITAL_TOOTH
}
