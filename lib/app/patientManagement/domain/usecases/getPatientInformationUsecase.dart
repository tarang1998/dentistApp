import 'dart:async';
import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentalApp/core/loggingWrapper.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetPatientInformationUsecase
    extends CompletableUseCase<GetPatientsInformationUsecaseParams> {
  final PatientManagementRepository _repository;

  GetPatientInformationUsecase(this._repository);

  @override
  Future<Stream<PatientInformation>> buildUseCaseStream(params) async {
    final StreamController<PatientInformation> streamController =
        StreamController();

    try {
      final PatientInformation _patientInformation =
          _repository.getPatientInformation(patientId: params!.patientId);
      LoggingWrapper.print(
        "Retrieved Patient Information Successful",
        name: 'GetPatientsInformationUsecase',
      );
      streamController.add(_patientInformation);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
      LoggingWrapper.print(
          "Retrieving Patient Information Unsuccessful: $error",
          name: 'GetPatientsInformationUsecase',
          isError: true);
    }
    return streamController.stream;
  }
}

class GetPatientsInformationUsecaseParams {
  final String patientId;

  GetPatientsInformationUsecaseParams({required this.patientId});
}
