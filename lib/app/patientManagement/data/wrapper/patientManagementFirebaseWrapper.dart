import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentalApp/app/patientManagement/data/keys/patientManagementKeys.dart';
import 'package:dentalApp/app/patientManagement/data/keys/patientProcedureKeys.dart';

class PatientManagementFirebaseWrapper {
  final int _documentBatchSize = 15;

  final String _keyPatientProceduresSubCollection = 'procedures';
  final CollectionReference patientsCollection =
      FirebaseFirestore.instance.collection('patients');

  Future<List<Map<String, dynamic>>> fetchPatients() async {
    final List<Map<String, dynamic>> patientsRawData = [];

    final querySnapshot = await patientsCollection
        .orderBy(PatientManagementKeys.keyUpdatedAt, descending: true)
        .limit(_documentBatchSize)
        .get();

    querySnapshot.docs.forEach((element) => {
          patientsRawData.add(
              {...(element.data() as Map<String, dynamic>), 'id': element.id})
        });

    return patientsRawData;
  }

  Future<List<Map<String, dynamic>>> fetchNextBatchOfPatients(
      {required String lastDocumentId}) async {
    final List<Map<String, dynamic>> patientsRawData = [];

    final documentSnapshot = await patientsCollection.doc(lastDocumentId).get();

    final querySnapshot = await patientsCollection
        .orderBy(PatientManagementKeys.keyUpdatedAt, descending: true)
        .limit(_documentBatchSize)
        .startAfterDocument(documentSnapshot)
        .get();

    querySnapshot.docs.forEach((element) => {
          patientsRawData.add(
              {...(element.data() as Map<String, dynamic>), 'id': element.id})
        });
    return patientsRawData;
  }

  Future<String> addPatientData(
      {required Map<String, dynamic> addPatientSerializedData}) async {
    final DocumentReference docReference =
        await patientsCollection.add(addPatientSerializedData);
    return docReference.id;
  }

  Future<void> editPatientData(
      {required String patientId,
      required Map<String, dynamic> editPatientSerializedData}) async {
    await patientsCollection.doc(patientId).update(editPatientSerializedData);
  }

  Future<List<Map<String, dynamic>>> fetchPatientProcedures(
      {required String patientId}) async {
    final List<Map<String, dynamic>> _patientProceduresRawInformation = [];

    final querySnapshot = await patientsCollection
        .doc(patientId)
        .collection(_keyPatientProceduresSubCollection)
        .orderBy(PatientProcedureKeys.keyProcedurePerformedAt, descending: true)
        .get();

    querySnapshot.docs.forEach((element) => {
          _patientProceduresRawInformation.add(
              {...(element.data() as Map<String, dynamic>), 'id': element.id})
        });

    return _patientProceduresRawInformation;
  }

  Future<String> addPatientProcedureData(
      {required String patientId,
      required Map<String, dynamic> patientProcedureSerializedData}) async {
    final DocumentReference docReference = await patientsCollection
        .doc(patientId)
        .collection(_keyPatientProceduresSubCollection)
        .add(patientProcedureSerializedData);
    return docReference.id;
  }

  Future<void> editPatientProcedureData(
      {required String patientId,
      required String procedureId,
      required Map<String, dynamic> procedureData}) async {
    await patientsCollection
        .doc(patientId)
        .collection(_keyPatientProceduresSubCollection)
        .doc(procedureId)
        .update(procedureData);
  }
}
