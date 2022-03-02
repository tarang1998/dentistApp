abstract class TeethChart {}

class AdultTeethChart implements TeethChart {
  final List<AdultTeethType> selectedValues;
  AdultTeethChart({required this.selectedValues});
}

class ChildTeethChart implements TeethChart {
  final List<ChildTeethType> selectedValues;
  ChildTeethChart({required this.selectedValues});
}

enum TeethChartType { ADULT, CHILD }

enum AdultTeethType { LU1, LU2, RU1, RU2, LD1, LD2, RD1, RD2 }

enum ChildTeethType { LUA, RUA, LDA, RDA }
