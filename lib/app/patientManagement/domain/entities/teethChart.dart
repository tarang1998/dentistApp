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

enum AdultTeethType {
  LU1,
  LU2,
  LU3,
  LU4,
  LU5,
  LU6,
  LU7,
  LU8,
  RU1,
  RU2,
  RU3,
  RU4,
  RU5,
  RU6,
  RU7,
  RU8,
  LD1,
  LD2,
  LD3,
  LD4,
  LD5,
  LD6,
  LD7,
  LD8,
  RD1,
  RD2,
  RD3,
  RD4,
  RD5,
  RD6,
  RD7,
  RD8
}

enum ChildTeethType {
  LUA,
  LUB,
  LUC,
  LUD,
  LUE,
  RUA,
  RUB,
  RUC,
  RUD,
  RUE,
  LDA,
  LDB,
  LDC,
  LDD,
  LDE,
  RDA,
  RDB,
  RDC,
  RDD,
  RDE
}
