import 'dart:async';
import 'package:dentist_app/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentist_app/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentist_app/core/loggingWrapper.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetPatientsMetaInformationUsecase extends CompletableUseCase<void> {
  final PatientManagementRepository _repository;

  GetPatientsMetaInformationUsecase(this._repository);

  @override
  Future<Stream<List<PatientMetaInformation>>> buildUseCaseStream(
      params) async {
    final StreamController<List<PatientMetaInformation>> streamController =
        StreamController();

    try {
      final List<PatientMetaInformation> patientsMeta =
          await _repository.getListOfPatientsMeta();
      LoggingWrapper.print(
        "Retrieved Patients Meta Information Successful",
        name: 'GetListOfPatientsMetaUsecase',
      );
      streamController.add(patientsMeta);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
      LoggingWrapper.print(
          "Retrieving Patients Meta Information Unsuccessful: $error",
          name: 'GetListOfPatientsMetaUsecase',
          isError: true);
    }
    return streamController.stream;
  }
}
