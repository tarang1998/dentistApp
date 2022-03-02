import 'package:dentalApp/app/patientManagement/domain/entities/teethChart.dart';

class PatientProcedureEnity {
  final String procedureId;
  final Procedure procedurePerformed;
  final num estimatedCost;
  final num amountPaid;
  final DateTime performedAt;
  final DateTime nextVisit;
  final String additionalRemarks;
  final TeethChart selectedTeethChart;

  PatientProcedureEnity(
      {required this.procedureId,
      required this.procedurePerformed,
      required this.estimatedCost,
      required this.amountPaid,
      required this.performedAt,
      required this.nextVisit,
      required this.additionalRemarks,
      required this.selectedTeethChart});
}

enum Procedure {
  ROOT_CANAL_TREATMENT,
  EXTRACTION,
  GIC_FILLINGS,
  COMPOSITE_FILLINGS,
  DRESSING_FILLINGS,
  SCALING_AND_POLISHING,
  SURGERY
}
