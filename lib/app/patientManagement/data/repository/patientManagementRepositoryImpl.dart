import 'package:dentist_app/app/patientManagement/data/mapper/patientInformationEntityMapper.dart';
import 'package:dentist_app/app/patientManagement/data/serializer/addPatientEntitySerializer.dart';
import 'package:dentist_app/app/patientManagement/data/wrapper/patientManagementFirebaseWrapper.dart';
import 'package:dentist_app/app/patientManagement/domain/entities/addPatientEntity.dart';
import 'package:dentist_app/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentist_app/app/patientManagement/domain/repository/patientManagementRepository.dart';

class PatientManagementRepositoryImpl extends PatientManagementRepository {
  final PatientManagementFirebaseWrapper _patientManagementFirebaseWrapper;
  final PatientInformationMapperEntity _patientInformationMapperEntity;
  final AddPatientEntitySerializer _addPatientEntitySerializaer;

  PatientManagementRepositoryImpl(this._patientManagementFirebaseWrapper,
      this._patientInformationMapperEntity, this._addPatientEntitySerializaer);

  List<PatientInformation>? _patientsInformation;

  @override
  Future<List<PatientMetaInformation>> getListOfPatientsMeta(
      {bool? fetchNextBatch}) async {
    if (_patientsInformation == null) {
      _patientsInformation = [];
      await fetchPatientsData();
    }
    List<PatientMetaInformation> _patientsMeta = [];
    _patientsInformation!.forEach((element) {
      _patientsMeta.add(element.patientMetaInformation);
    });
    return _patientsMeta;
  }

  @override
  Future<void> fetchPatientsData() async {
    _patientsInformation = [];

    final List<Map<String, dynamic>> patientsRawData =
        await _patientManagementFirebaseWrapper.fetchPatients();

    patientsRawData.forEach((element) {
      _patientsInformation!.add(_patientInformationMapperEntity.map(element));
    });
  }

  @override
  Future<void> fetchNextBatchOfPatientsData() async {
    final List<Map<String, dynamic>> patientsRawData =
        await _patientManagementFirebaseWrapper.fetchNextBatchOfPatients(
            lastDocumentId:
                _patientsInformation!.last.patientMetaInformation.patientId);

    patientsRawData.forEach((element) {
      _patientsInformation!.add(_patientInformationMapperEntity.map(element));
    });
  }

  @override
  PatientInformation getPatientInformation({required String patientId}) {
    return _patientsInformation!.singleWhere(
        (element) => element.patientMetaInformation.patientId == patientId);
  }

  @override
  Future<String> addPatientData(
      {required AddPatientEntity patientEntity}) async {
    Map<String, dynamic> _addPatientSerializedData =
        _addPatientEntitySerializaer.serialize(patientEntity);
    final String patientId = await _patientManagementFirebaseWrapper
        .addPatientData(addPatientSerializedData: _addPatientSerializedData);

    //Adding the patient data to the cached patient data's List
    _patientsInformation!.insert(
        0,
        PatientInformation(
            patientMetaInformation: PatientMetaInformation(
                patientId: patientId,
                name: patientEntity.name,
                dob: patientEntity.dob,
                sex: patientEntity.sex),
            address: patientEntity.address,
            emailId: patientEntity.emailId,
            phoneNo: patientEntity.phoneNo,
            createdAt: patientEntity.createdAt,
            additionalInformation: patientEntity.additionalInformation));

    return patientId;
  }
}
