import 'dart:async';
import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentalApp/core/loggingWrapper.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class FetchAllProceduresForPatientUsecase
    extends CompletableUseCase<FetchAllProceduresForPatientUsecaseParams> {
  final PatientManagementRepository _repository;

  FetchAllProceduresForPatientUsecase(this._repository);

  @override
  Future<Stream<List<PatientProcedureEnity>>> buildUseCaseStream(params) async {
    final StreamController<List<PatientProcedureEnity>> streamController =
        StreamController();

    try {
      final List<PatientProcedureEnity> _patientProcedures =
          await _repository.getPatientProcedures(patientId: params!.patientId);
      LoggingWrapper.print(
        "Retrieved Patient Procedures Successful",
        name: 'FetchAllProceduresForPatientUsecase',
      );
      streamController.add(_patientProcedures);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
      LoggingWrapper.print("Retrieving Patient Procedures Unsuccessful: $error",
          name: 'FetchAllProceduresForPatientUsecase', isError: true);
    }
    return streamController.stream;
  }
}

class FetchAllProceduresForPatientUsecaseParams {
  final String patientId;

  FetchAllProceduresForPatientUsecaseParams({required this.patientId});
}
