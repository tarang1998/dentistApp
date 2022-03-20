import 'dart:async';
import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentalApp/core/loggingWrapper.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class EditPatientProcedureUsecase
    extends CompletableUseCase<EditPatientProcedureUsecaseParams> {
  final PatientManagementRepository _repository;

  EditPatientProcedureUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(params) async {
    final StreamController<void> streamController = StreamController();

    try {
      await _repository.editPatientProcedure(
          patientId: params!.patientId,
          procedureId: params.procedureId,
          patientProcedureEntity: params.patientProcedureEntity);
      LoggingWrapper.print(
        "Edited procedure : ${params.procedureId},  Patient : ${params.patientId} Data Successful",
        name: 'EditPatientProcedureUsecase',
      );
      streamController.close();
    } catch (error) {
      streamController.addError(error);
      LoggingWrapper.print(
          "Failed to Edit procedure : ${params!.procedureId} for Patient : ${params.patientId} : $error",
          name: 'EditPatientProcedureUsecase',
          isError: true);
    }
    return streamController.stream;
  }
}

class EditPatientProcedureUsecaseParams {
  final String patientId;
  final String procedureId;
  final PatientProcedureEnity patientProcedureEntity;

  EditPatientProcedureUsecaseParams(
      {required this.patientId,
      required this.procedureId,
      required this.patientProcedureEntity});
}
