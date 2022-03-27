import 'dart:async';
import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentalApp/core/loggingWrapper.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AddPatientDataUsecase
    extends CompletableUseCase<AddPatientDataUsecaseParams> {
  final PatientManagementRepository _repository;

  AddPatientDataUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(params) async {
    final StreamController<void> streamController = StreamController();

    try {
      String patientId = await _repository.addPatientData(
          patientInformation: params!.patientInformation,
          localUserImageFilePath: params.localUserImageFilePath,
          localImagesPath: params.localImagesPath);
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

class AddPatientDataUsecaseParams {
  final PatientInformation patientInformation;
  final String? localUserImageFilePath;
  final List<String> localImagesPath;

  AddPatientDataUsecaseParams(
      {required this.patientInformation,
      required this.localUserImageFilePath,
      required this.localImagesPath});
}
