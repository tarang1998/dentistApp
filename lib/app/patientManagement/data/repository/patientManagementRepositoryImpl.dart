import 'package:dentist_app/app/patientManagement/data/mapper/patientInformationEntityMapper.dart';
import 'package:dentist_app/app/patientManagement/data/wrapper/patientManagementFirebaseWrapper.dart';
import 'package:dentist_app/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentist_app/app/patientManagement/domain/repository/patientManagementRepository.dart';

class PatientManagementRepositoryImpl extends PatientManagementRepository {
  final PatientManagementFirebaseWrapper _patientManagementFirebaseWrapper;
  final PatientInformationMapperEntity _patientInformationMapperEntity;

  PatientManagementRepositoryImpl(this._patientManagementFirebaseWrapper,
      this._patientInformationMapperEntity);

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
}
