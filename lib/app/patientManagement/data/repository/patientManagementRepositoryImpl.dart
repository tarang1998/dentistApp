import 'package:dentalApp/app/patientManagement/data/mapper/patientInformationEntityMapper.dart';
import 'package:dentalApp/app/patientManagement/data/mapper/patientProcedureEntityMapper.dart';
import 'package:dentalApp/app/patientManagement/data/serializer/addEditPatientEntitySerializer.dart';
import 'package:dentalApp/app/patientManagement/data/serializer/addPatientProcedureSerializer.dart';
import 'package:dentalApp/app/patientManagement/data/wrapper/patientManagementFirebaseWrapper.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/repository/patientManagementRepository.dart';

class PatientManagementRepositoryImpl extends PatientManagementRepository {
  final PatientManagementFirebaseWrapper _patientManagementFirebaseWrapper;
  final PatientInformationMapperEntity _patientInformationMapperEntity;
  final PatientProcedureEntityMapper _patientProcedureEntityMapper;
  final AddEditPatientEntitySerializer _addEditPatientEntitySerializer;
  final AddPatientProcedureSerializer _addPatientProcedureSerializer;

  PatientManagementRepositoryImpl(
      this._patientManagementFirebaseWrapper,
      this._patientInformationMapperEntity,
      this._addEditPatientEntitySerializer,
      this._patientProcedureEntityMapper,
      this._addPatientProcedureSerializer);

  List<PatientInformation>? _patientsInformation;

  //key : patientId
  final Map<String, List<PatientProcedureEnity>> _patientsProcedures = {};

  @override
  Future<List<PatientMetaInformation>> getListOfPatientsMeta(
      {bool? fetchNextBatch}) async {
    if (_patientsInformation == null) {
      _patientsInformation = [];
      await fetchPatientsData();
    }
    List<PatientMetaInformation> _patientsMeta = [];
    _patientsInformation!.forEach((element) {
      _patientsMeta
          .add(element.patientPersonalInformation.patientMetaInformation);
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
            lastDocumentId: _patientsInformation!.last
                .patientPersonalInformation.patientMetaInformation.patientId);

    patientsRawData.forEach((element) {
      _patientsInformation!.add(_patientInformationMapperEntity.map(element));
    });
  }

  @override
  PatientInformation getPatientInformation({required String patientId}) {
    return _patientsInformation!.singleWhere((element) =>
        element.patientPersonalInformation.patientMetaInformation.patientId ==
        patientId);
  }

  @override
  Future<String> addPatientData(
      {required PatientInformation patientInformation}) async {
    Map<String, dynamic> _addPatientSerializedData =
        _addEditPatientEntitySerializer.serialize(patientInformation);
    final String patientId = await _patientManagementFirebaseWrapper
        .addPatientData(addPatientSerializedData: _addPatientSerializedData);

    //Adding the patient data to the cached patient data's List
    _patientsInformation!.insert(
        0,
        PatientInformation(
            patientDentalInformation:
                patientInformation.patientDentalInformation,
            patientMedicalInformation:
                patientInformation.patientMedicalInformation,
            patientMedicationInformation:
                patientInformation.patientMedicationInformation,
            updatedAt: patientInformation.updatedAt,
            patientPersonalInformation: PatientPersonalInformation(
              address: patientInformation.patientPersonalInformation.address,
              mobileNo: patientInformation.patientPersonalInformation.mobileNo,
              bloodGroup:
                  patientInformation.patientPersonalInformation.bloodGroup,
              maritialStatus:
                  patientInformation.patientPersonalInformation.maritialStatus,
              officeInformation: patientInformation
                  .patientPersonalInformation.officeInformation,
              profession:
                  patientInformation.patientPersonalInformation.profession,
              refferedBy:
                  patientInformation.patientPersonalInformation.refferedBy,
              telephoneNo:
                  patientInformation.patientPersonalInformation.telephoneNo,
              patientMetaInformation: PatientMetaInformation(
                  patientId: patientId,
                  name: patientInformation
                      .patientPersonalInformation.patientMetaInformation.name,
                  dob: patientInformation
                      .patientPersonalInformation.patientMetaInformation.dob,
                  emailId: patientInformation.patientPersonalInformation
                      .patientMetaInformation.emailId,
                  sex: patientInformation
                      .patientPersonalInformation.patientMetaInformation.sex),
            ),
            createdAt: patientInformation.createdAt,
            additionalInformation: patientInformation.additionalInformation));

    return patientId;
  }

  @override
  Future<void> editPatientData(
      {required PatientInformation patientInformation}) async {
    Map<String, dynamic> _editPatientSerializedData =
        _addEditPatientEntitySerializer.serialize(patientInformation);
    await _patientManagementFirebaseWrapper.editPatientData(
        patientId: patientInformation
            .patientPersonalInformation.patientMetaInformation.patientId,
        editPatientSerializedData: _editPatientSerializedData);

    //Editing the patient data from the cached patient data's List

    final int index = _patientsInformation!.indexWhere((element) =>
        element.patientPersonalInformation.patientMetaInformation.patientId ==
        patientInformation
            .patientPersonalInformation.patientMetaInformation.patientId);
    _patientsInformation!.removeAt(index);
    _patientsInformation!.insert(0, patientInformation);
  }

  @override
  Future<List<PatientProcedureEnity>> getPatientProcedures(
      {required String patientId}) async {
    if (_patientsProcedures[patientId] != null) {
      return _patientsProcedures[patientId]!;
    } else {
      await fetchPatientProcedures(patientId: patientId);
      return _patientsProcedures[patientId]!;
    }
  }

  Future<void> fetchPatientProcedures({required String patientId}) async {
    final List<PatientProcedureEnity> _mappedPatientProcedures = [];
    final List<Map<String, dynamic>> _patientProceduresRawData =
        await _patientManagementFirebaseWrapper.fetchPatientProcedures(
            patientId: patientId);

    _patientProceduresRawData.forEach((element) {
      _mappedPatientProcedures.add(_patientProcedureEntityMapper.map(element));
    });

    _patientsProcedures[patientId] = _mappedPatientProcedures;
  }

  @override
  Future<String> addPatientProcedure(
      {required String patientId,
      required PatientProcedureEnity patientProcedureEnity}) async {
    Map<String, dynamic> patientProcedureData =
        _addPatientProcedureSerializer.serialize(patientProcedureEnity);

    String procedureId =
        await _patientManagementFirebaseWrapper.addPatientProcedureData(
            patientId: patientId,
            patientProcedureSerializedData: patientProcedureData);

    _patientsProcedures[patientId]!.insert(
        0,
        PatientProcedureEnity(
            procedureId: procedureId,
            procedurePerformed: patientProcedureEnity.procedurePerformed,
            estimatedCost: patientProcedureEnity.estimatedCost,
            amountPaid: patientProcedureEnity.amountPaid,
            performedAt: patientProcedureEnity.performedAt,
            nextVisit: patientProcedureEnity.nextVisit,
            additionalRemarks: patientProcedureEnity.additionalRemarks,
            selectedTeethChart: patientProcedureEnity.selectedTeethChart));

    return patientId;
  }

  @override
  PatientProcedureEnity getPatientProcedureInformation(
      {required String patientId, required String patientProcedureId}) {
    List<PatientProcedureEnity> procedures = _patientsProcedures[patientId]!;

    PatientProcedureEnity procedure = procedures
        .singleWhere((element) => element.procedureId == patientProcedureId);

    return procedure;
  }
}
