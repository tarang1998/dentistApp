import 'dart:async';
import 'package:dentalApp/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentalApp/core/loggingWrapper.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetAdditionalImagesRefUsecase
    extends CompletableUseCase<GetAdditionalImagesRefUsecaseParams> {
  final PatientManagementRepository _repository;

  GetAdditionalImagesRefUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(params) async {
    final StreamController<List<String>> streamController = StreamController();

    try {
      List<String> downloadableUris =
          await _repository.getUserAdditionalImagesRef(
              uploadedImagePaths: params!.uploadedImagePaths);
      LoggingWrapper.print(
        "Fetched User Additional Image Ref Successful",
        name: 'GetAdditionalImagesRefUsecase',
      );
      streamController.add(downloadableUris);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
      LoggingWrapper.print("Failed to fetch the image Ref for patient , $error",
          name: 'GetAdditionalImagesRefUsecase', isError: true);
    }
    return streamController.stream;
  }
}

class GetAdditionalImagesRefUsecaseParams {
  final List<String> uploadedImagePaths;

  GetAdditionalImagesRefUsecaseParams({required this.uploadedImagePaths});
}
