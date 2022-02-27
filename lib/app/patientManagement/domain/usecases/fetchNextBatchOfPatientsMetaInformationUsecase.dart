import 'dart:async';
import 'package:dentalApp/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentalApp/core/loggingWrapper.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class FetchNextBatchOfPatientsMetaUsecase extends CompletableUseCase<void> {
  final PatientManagementRepository _repository;

  FetchNextBatchOfPatientsMetaUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(params) async {
    final StreamController<void> streamController = StreamController();

    try {
      await _repository.fetchNextBatchOfPatientsData();
      LoggingWrapper.print(
        "Fetched Next Batch Of Patients Meta Successful",
        name: 'FetchNextBatchOfPatientsMetaUsecase',
      );
      streamController.close();
    } catch (error) {
      streamController.addError(error);
      LoggingWrapper.print(
          "Fetching Next Batch Of Patients Meta Unsuccessful: $error",
          name: 'FetchNextBatchOfPatientsMetaUsecase',
          isError: true);
    }
    return streamController.stream;
  }
}
