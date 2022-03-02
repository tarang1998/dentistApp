import 'package:dentalApp/app/patientManagement/domain/entities/addPatientEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';

abstract class PatientManagementRepository {
  Future<List<PatientMetaInformation>> getListOfPatientsMeta();

  Future<void> fetchPatientsData();

  Future<void> fetchNextBatchOfPatientsData();

  PatientInformation getPatientInformation({required String patientId});

  Future<String> addPatientData({required AddPatientEntity patientEntity});

  Future<List<PatientProcedureEnity>> getPatientProcedures(
      {required String patientId});

  Future<String> addPatientPrcedure(
      {required String patientId,
      required PatientProcedureEnity patientProcedureEnity});
}
