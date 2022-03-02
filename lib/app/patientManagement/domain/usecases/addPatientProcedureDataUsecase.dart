import 'dart:async';
import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentalApp/core/loggingWrapper.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AddPatientProcedureDataUsecase
    extends CompletableUseCase<AddPatientProcedureDataUsecaseParams> {
  final PatientManagementRepository _repository;

  AddPatientProcedureDataUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(params) async {
    final StreamController<void> streamController = StreamController();

    try {
      String procedureId = await _repository.addPatientPrcedure(
          patientId: params!.patientId,
          patientProcedureEnity: params.patientProcedureEntity);
      LoggingWrapper.print(
        "Added procedure : $procedureId,  Patient : ${params.patientId} Data Successful",
        name: 'AddPatientProcedureDataUsecase',
      );
      streamController.close();
    } catch (error) {
      streamController.addError(error);
      LoggingWrapper.print(
          "Failed to add procedure for Patient : ${params!.patientId} : $error",
          name: 'AddPatientProcedureDataUsecase',
          isError: true);
    }
    return streamController.stream;
  }
}

class AddPatientProcedureDataUsecaseParams {
  final String patientId;
  final PatientProcedureEnity patientProcedureEntity;

  AddPatientProcedureDataUsecaseParams(
      {required this.patientId, required this.patientProcedureEntity});
}
