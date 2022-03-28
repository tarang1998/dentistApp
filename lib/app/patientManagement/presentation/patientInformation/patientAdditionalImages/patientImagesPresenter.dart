import 'package:dentalApp/app/patientManagement/domain/usecases/getAdditionalImagesRefUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/getPatientInformationUsecase.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientImagePresenter extends Presenter {
  final GetAdditionalImagesRefUsecase _getAdditionalImagesRefUsecase;
  final GetPatientInformationUsecase _getPatientInformationUsecase;

  PatientImagePresenter(
      this._getAdditionalImagesRefUsecase, this._getPatientInformationUsecase);

  @override
  void dispose() {
    _getAdditionalImagesRefUsecase.dispose();
    _getPatientInformationUsecase.dispose();
  }

  void getAdditionImagesRef(
      UseCaseObserver observer, List<String> uploadedImagesPath) {
    _getAdditionalImagesRefUsecase.execute(
        observer,
        GetAdditionalImagesRefUsecaseParams(
            uploadedImagePaths: uploadedImagesPath));
  }

  void getPatientInformation(UseCaseObserver observer, String patientId) {
    _getPatientInformationUsecase.execute(
        observer, GetPatientsInformationUsecaseParams(patientId: patientId));
  }
}
