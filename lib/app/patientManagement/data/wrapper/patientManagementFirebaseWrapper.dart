import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentalApp/app/patientManagement/data/keys/patientManagementKeys.dart';

class PatientManagementFirebaseWrapper {
  final int _documentBatchSize = 2;

  final CollectionReference patientsCollection =
      FirebaseFirestore.instance.collection('patients');

  Future<List<Map<String, dynamic>>> fetchPatients() async {
    final List<Map<String, dynamic>> patientsRawData = [];

    final querySnapshot = await patientsCollection
        .orderBy(PatientManagementKeys.keyCreatedAt, descending: true)
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
        .orderBy(PatientManagementKeys.keyCreatedAt, descending: true)
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
}
