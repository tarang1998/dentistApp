class PatientProcedureEnity {
  final String procedureId;
  final Procedure procedurePerformed;
  final num estimatedCost;
  final num amountPaid;
  final DateTime performedAt;
  final DateTime nextVisit;
  final String additionalRemarks;

  PatientProcedureEnity(
      {required this.procedureId,
      required this.procedurePerformed,
      required this.estimatedCost,
      required this.amountPaid,
      required this.performedAt,
      required this.nextVisit,
      required this.additionalRemarks});
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

enum TeethType { ADULT, CHILD }

enum AdultTeethType { LU1, LU2, RU1, RU2, LD1, LD2, RD1, RD2 }

enum ChildTeethType { LUA, RUA, LDA, RDA }
