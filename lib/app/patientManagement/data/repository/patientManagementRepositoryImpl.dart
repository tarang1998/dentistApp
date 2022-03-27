import 'package:dentalApp/app/patientManagement/data/mapper/patientInformationEntityMapper.dart';
import 'package:dentalApp/app/patientManagement/data/mapper/patientProcedureEntityMapper.dart';
import 'package:dentalApp/app/patientManagement/data/serializer/addEditPatientEntitySerializer.dart';
import 'package:dentalApp/app/patientManagement/data/serializer/addPatientProcedureSerializer.dart';
import 'package:dentalApp/app/patientManagement/data/wrapper/patientManagementFirebaseCloudStorageWrapper.dart';
import 'package:dentalApp/app/patientManagement/data/wrapper/patientManagementFirebaseWrapper.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/repository/patientManagementRepository.dart';

class PatientManagementRepositoryImpl extends PatientManagementRepository {
  final PatientManagementFirebaseWrapper _patientManagementFirebaseWrapper;
  final PatientManagementFirebaseStorageWrapper
      _patientManagementFirebaseStorageWrapper;
  final PatientInformationMapperEntity _patientInformationMapperEntity;
  final PatientProcedureEntityMapper _patientProcedureEntityMapper;
  final AddEditPatientEntitySerializer _addEditPatientEntitySerializer;
  final AddPatientProcedureSerializer _addPatientProcedureSerializer;

  PatientManagementRepositoryImpl(
      this._patientManagementFirebaseWrapper,
      this._patientManagementFirebaseStorageWrapper,
      this._patientInformationMapperEntity,
      this._addEditPatientEntitySerializer,
      this._patientProcedureEntityMapper,
      this._addPatientProcedureSerializer);

  List<PatientInformation>? _patientsInformation;

  //key : patientId
  Map<String, List<PatientProcedureEnity>> _patientsProcedures = {};

  //key : patientId , value : downloadable User Image Uri
  Map<String, String> _downloadableUserImageUri = {};

  //1st Key : uploaded firestore Image path
  Map<String, String> _downloadableAdditionalImagesUri = {};

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
    //Clearing the cache for patient Information, downloadable User images and the patient Procedures on page refresh
    _patientsInformation = [];
    _patientsProcedures = {};
    _downloadableUserImageUri = {};

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
  Future<String> addPatientData({
    required PatientInformation patientInformation,
    required String? localUserImageFilePath,
    required List<String> localImagesPath,
  }) async {
    //Getting a reference for the patient
    final String patientId =
        await _patientManagementFirebaseWrapper.getPatientReference();

    //uploading the user Image
    String? userImageStorageLocation;

    if (localUserImageFilePath != null) {
      userImageStorageLocation = 'patients/$patientId/userImage.jpeg';

      await _patientManagementFirebaseStorageWrapper.uploadUserImageFile(
          userImageStorageLocation, localUserImageFilePath);
    }

    //uploading the additional Images
    List<String> userAdditionalImagesStorageLocation = [];

    await Future.wait(localImagesPath.map((element) async {
      String storagePath =
          'patients/$patientId/additionalImages/${DateTime.now().microsecondsSinceEpoch}';

      await _patientManagementFirebaseStorageWrapper.uploadUserImageFile(
          storagePath, element);

      userAdditionalImagesStorageLocation.add(storagePath);
    }));

    Map<String, dynamic> _addPatientSerializedData =
        _addEditPatientEntitySerializer.serialize(patientInformation,
            userImageStorageLocation, userAdditionalImagesStorageLocation);

    //Adding the patient Data

    await _patientManagementFirebaseWrapper.addPatientData(
        patientId: patientId,
        addPatientSerializedData: _addPatientSerializedData);

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
              userImagePath: userImageStorageLocation,
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
            additionalInformation: patientInformation.additionalInformation,
            additionalImages: userAdditionalImagesStorageLocation));

    return patientId;
  }

  @override
  Future<void> editPatientData(
      {required PatientInformation patientInformation,
      required String? localUserImageFilePath,
      required List<String> localImagesPath,
      required List<String> uploadedImagesRef}) async {
    String? userImageStorageLocation;

    //uploading the user image
    if (localUserImageFilePath != null) {
      userImageStorageLocation =
          'patients/${patientInformation.patientPersonalInformation.patientMetaInformation.patientId}/userImage.jpeg';

      await _patientManagementFirebaseStorageWrapper.uploadUserImageFile(
          userImageStorageLocation, localUserImageFilePath);

      _downloadableUserImageUri[patientInformation
              .patientPersonalInformation.patientMetaInformation.patientId] =
          await _patientManagementFirebaseStorageWrapper.getDownloadableUri(
              userImageStorageLocation: userImageStorageLocation);
    }

    //uploading the user additional images
    List<String> userAdditionalImagesStorageLocation = [];

    await Future.wait(localImagesPath.map((element) async {
      String storagePath =
          'patients/${patientInformation.patientPersonalInformation.patientMetaInformation.patientId}/additionalImages/${DateTime.now().microsecondsSinceEpoch}';

      await _patientManagementFirebaseStorageWrapper.uploadUserImageFile(
          storagePath, element);

      userAdditionalImagesStorageLocation.add(storagePath);
    }));

    //Checking for the already updated images
    uploadedImagesRef.forEach((element) {
      final String key = _downloadableAdditionalImagesUri.keys.firstWhere(
        (k) => _downloadableAdditionalImagesUri[k] == element,
      );
      userAdditionalImagesStorageLocation.add(key);
    });

    Map<String, dynamic> _editPatientSerializedData =
        _addEditPatientEntitySerializer.serialize(patientInformation,
            userImageStorageLocation, userAdditionalImagesStorageLocation);

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
              userImagePath: userImageStorageLocation ??
                  _downloadableUserImageUri.keys.firstWhere(
                      (element) =>
                          _downloadableUserImageUri[element] ==
                          patientInformation
                              .patientPersonalInformation.userImagePath,
                      orElse: null),
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
              patientMetaInformation: patientInformation
                  .patientPersonalInformation.patientMetaInformation,
            ),
            createdAt: patientInformation.createdAt,
            additionalInformation: patientInformation.additionalInformation,
            additionalImages: userAdditionalImagesStorageLocation));
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
      required PatientProcedureEnity patientProcedureEntity}) async {
    Map<String, dynamic> patientProcedureData =
        _addPatientProcedureSerializer.serialize(patientProcedureEntity);

    String procedureId =
        await _patientManagementFirebaseWrapper.addPatientProcedureData(
            patientId: patientId,
            patientProcedureSerializedData: patientProcedureData);

    _patientsProcedures[patientId]!.insert(
        0,
        PatientProcedureEnity(
            procedureId: procedureId,
            procedurePerformed: patientProcedureEntity.procedurePerformed,
            diagnosis: patientProcedureEntity.diagnosis,
            estimatedCost: patientProcedureEntity.estimatedCost,
            amountPaid: patientProcedureEntity.amountPaid,
            performedAt: patientProcedureEntity.performedAt,
            nextVisit: patientProcedureEntity.nextVisit,
            additionalRemarks: patientProcedureEntity.additionalRemarks,
            selectedTeethChart: patientProcedureEntity.selectedTeethChart));

    return patientId;
  }

  @override
  Future<void> editPatientProcedure(
      {required String patientId,
      required String procedureId,
      required PatientProcedureEnity patientProcedureEntity}) async {
    Map<String, dynamic> patientProcedureData =
        _addPatientProcedureSerializer.serialize(patientProcedureEntity);

    await _patientManagementFirebaseWrapper.editPatientProcedureData(
        patientId: patientId,
        procedureId: procedureId,
        procedureData: patientProcedureData);

    final int index = _patientsProcedures[patientId]!
        .indexWhere((element) => element.procedureId == procedureId);
    _patientsProcedures[patientId]!.removeAt(index);
    _patientsProcedures[patientId]!.insert(index, patientProcedureEntity);
  }

  @override
  PatientProcedureEnity getPatientProcedureInformation(
      {required String patientId, required String patientProcedureId}) {
    List<PatientProcedureEnity> procedures = _patientsProcedures[patientId]!;

    PatientProcedureEnity procedure = procedures
        .singleWhere((element) => element.procedureId == patientProcedureId);

    return procedure;
  }

  @override
  Future<String> getUserImageRef({required String patientId}) async {
    if (_downloadableUserImageUri[patientId] != null) {
      return _downloadableUserImageUri[patientId]!;
    } else {
      final String userImageStorageLocation =
          'patients/$patientId/userImage.jpeg';

      final String downloadableImageUri =
          await _patientManagementFirebaseStorageWrapper.getDownloadableUri(
              userImageStorageLocation: userImageStorageLocation);
      _downloadableUserImageUri[patientId] = downloadableImageUri;
      return downloadableImageUri;
    }
  }

  @override
  Future<List<String>> getUserAdditionalImagesRef(
      {required List<String> uploadedImagePaths}) async {
    final List<String> downloadableUris = [];

    await Future.wait(uploadedImagePaths.map((element) async {
      if (_downloadableAdditionalImagesUri[element] != null) {
        downloadableUris.add(_downloadableAdditionalImagesUri[element]!);
      } else {
        String uri = await _patientManagementFirebaseStorageWrapper
            .getDownloadableUri(userImageStorageLocation: element);
        _downloadableAdditionalImagesUri[element] = uri;
        downloadableUris.add(uri);
      }
    }));

    return downloadableUris;
  }
}
