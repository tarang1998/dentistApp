import 'dart:async';
import 'package:dentalApp/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentalApp/core/loggingWrapper.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetUserImageRefUsecase
    extends CompletableUseCase<GetUserImageRefUsecaseParams> {
  final PatientManagementRepository _repository;

  GetUserImageRefUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(params) async {
    final StreamController<String> streamController = StreamController();

    try {
      String userImageRef =
          await _repository.getUserImageRef(patientId: params!.patientId);
      LoggingWrapper.print(
        "Fetched User Image Ref for patient : ${params.patientId} Successful",
        name: 'GetUserImageRefUsecase',
      );
      streamController.add(userImageRef);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
      LoggingWrapper.print("Failed to fetch the image Ref for patient , $error",
          name: 'GetUserImageRefUsecase', isError: true);
    }
    return streamController.stream;
  }
}

class GetUserImageRefUsecaseParams {
  final String patientId;

  GetUserImageRefUsecaseParams({
    required this.patientId,
  });
}
