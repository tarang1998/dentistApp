import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentist_app/app/patientManagement/data/keys/patientManagementKeys.dart';

class PatientManagementFirebaseWrapper {
  final int _documentBatchSize = 15;

  final CollectionReference patientsCollection =
      FirebaseFirestore.instance.collection('patients');

  Future<List<Map<String, dynamic>>> fetchPatients() async {
    final List<Map<String, dynamic>> patientsRawData = [];

    final querySnapshot = await patientsCollection
        .orderBy(PatientManagementKeys.keyName)
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
        .orderBy(PatientManagementKeys.keyName)
        .limit(_documentBatchSize)
        .startAfterDocument(documentSnapshot)
        .get();

    querySnapshot.docs.forEach((element) =>
        {patientsRawData.add(element.data() as Map<String, dynamic>)});

    return patientsRawData;
  }
}
