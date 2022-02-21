import 'dart:async';
import 'package:dentist_app/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentist_app/core/loggingWrapper.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class FetchPatientsMetaUsecase extends CompletableUseCase<void> {
  final PatientManagementRepository _repository;

  FetchPatientsMetaUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(params) async {
    final StreamController<void> streamController = StreamController();

    try {
      await _repository.fetchPatientsData();
      LoggingWrapper.print(
        "Fetched Patients Meta Information Successful",
        name: 'FetchPatientsMetaUsecase',
      );
      streamController.close();
    } catch (error) {
      streamController.addError(error);
      LoggingWrapper.print(
          "Fetching Patients Meta Information Unsuccessful: $error",
          name: 'FetchPatientsMetaUsecase',
          isError: true);
    }
    return streamController.stream;
  }
}
