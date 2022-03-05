import 'dart:async';
import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentalApp/core/loggingWrapper.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetPatientProcedureInformationUsecase
    extends CompletableUseCase<GetPatientProcedureInformationUsecaseParams> {
  final PatientManagementRepository _repository;

  GetPatientProcedureInformationUsecase(this._repository);

  @override
  Future<Stream<PatientProcedureEnity>> buildUseCaseStream(params) async {
    final StreamController<PatientProcedureEnity> streamController =
        StreamController();

    try {
      final PatientProcedureEnity _patientProcedureEntity =
          _repository.getPatientProcedureInformation(
              patientId: params!.patientId,
              patientProcedureId: params.patientProcedureId);
      LoggingWrapper.print(
        "Retrieved Patient Procedure Information Successful",
        name: 'GetPatientProcedureUsecase',
      );
      streamController.add(_patientProcedureEntity);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
      LoggingWrapper.print(
          "Retrieving Patient Procedure Information Unsuccessful: $error",
          name: 'GetPatientProcedureUsecase',
          isError: true);
    }
    return streamController.stream;
  }
}

class GetPatientProcedureInformationUsecaseParams {
  final String patientId;
  final String patientProcedureId;

  GetPatientProcedureInformationUsecaseParams(
      {required this.patientId, required this.patientProcedureId});
}
