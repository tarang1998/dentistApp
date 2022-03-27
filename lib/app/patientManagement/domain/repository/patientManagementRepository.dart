import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';

abstract class PatientManagementRepository {
  Future<List<PatientMetaInformation>> getListOfPatientsMeta();

  Future<void> fetchPatientsData();

  Future<void> fetchNextBatchOfPatientsData();

  PatientInformation getPatientInformation({required String patientId});

  Future<String> addPatientData({
    required PatientInformation patientInformation,
    required String? localUserImageFilePath,
    required List<String> localImagesPath,
  });

  Future<void> editPatientData(
      {required PatientInformation patientInformation,
      required String? localUserImageFilePath,
      required List<String> localImagesPath,
      required List<String> uploadedImagesRef});

  Future<List<PatientProcedureEnity>> getPatientProcedures(
      {required String patientId});

  Future<String> addPatientProcedure(
      {required String patientId,
      required PatientProcedureEnity patientProcedureEntity});

  Future<void> editPatientProcedure(
      {required String patientId,
      required String procedureId,
      required PatientProcedureEnity patientProcedureEntity});

  PatientProcedureEnity getPatientProcedureInformation(
      {required String patientId, required String patientProcedureId});

  Future<String> getUserImageRef({required String patientId});

  Future<List<String>> getUserAdditionalImagesRef(
      {required List<String> uploadedImagePaths});
}
