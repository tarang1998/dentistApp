import 'dart:async';
import 'package:dentist_app/app/patientManagement/domain/entities/addPatientEntity.dart';
import 'package:dentist_app/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentist_app/core/loggingWrapper.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AddPatientDataUsecase extends CompletableUseCase<AddPatientEntity> {
  final PatientManagementRepository _repository;

  AddPatientDataUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(params) async {
    final StreamController<void> streamController = StreamController();

    try {
      String patientId =
          await _repository.addPatientData(patientEntity: params!);
      LoggingWrapper.print(
        "Added Patient : $patientId Data Successful",
        name: 'AddPatientDataUsecase',
      );
      streamController.close();
    } catch (error) {
      streamController.addError(error);
      LoggingWrapper.print("Failed to add Patient Data: $error",
          name: 'AddPatientDataUsecase', isError: true);
    }
    return streamController.stream;
  }
}
