import 'package:dentist_app/app/patientManagement/domain/entities/addPatientEntity.dart';
import 'package:dentist_app/app/patientManagement/domain/entities/patientInformation.dart';

abstract class PatientManagementRepository {
  Future<List<PatientMetaInformation>> getListOfPatientsMeta();

  Future<void> fetchPatientsData();

  Future<void> fetchNextBatchOfPatientsData();

  PatientInformation getPatientInformation({required String patientId});

  Future<String> addPatientData({required AddPatientEntity patientEntity});
}
