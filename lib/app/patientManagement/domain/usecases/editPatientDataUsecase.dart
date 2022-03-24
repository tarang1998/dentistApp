import 'dart:async';
import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentalApp/core/loggingWrapper.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class EditPatientDataUsecase
    extends CompletableUseCase<EditPatientDataUsecaseParams> {
  final PatientManagementRepository _repository;

  EditPatientDataUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(params) async {
    final StreamController<void> streamController = StreamController();

    try {
      await _repository.editPatientData(
          patientInformation: params!.patientInformation,
          localUserImageFilePath: params.localUserImageFilePath);
      LoggingWrapper.print(
        "Editted Patient Data Successful",
        name: 'EditPatientDataUsecase',
      );
      streamController.close();
    } catch (error) {
      streamController.addError(error);
      LoggingWrapper.print("Failed to edit Patient Data: $error",
          name: 'EditPatientDataUsecase', isError: true);
    }
    return streamController.stream;
  }
}

class EditPatientDataUsecaseParams {
  final PatientInformation patientInformation;
  final String? localUserImageFilePath;

  EditPatientDataUsecaseParams(
      {required this.patientInformation, required this.localUserImageFilePath});
}
