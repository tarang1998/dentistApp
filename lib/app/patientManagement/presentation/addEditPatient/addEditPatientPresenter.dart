import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/addPatientDataUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/editPatientDataUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/getAdditionalImagesRefUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/getPatientInformationUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/getUserImageRefUsecase.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AddEditPatientPresenter extends Presenter {
  final AddPatientDataUsecase _addPatientDataUsecase;
  final GetPatientInformationUsecase _getPatientInformationUsecase;
  final EditPatientDataUsecase _editPatientDataUsecase;
  final GetUserImageRefUsecase _getImageRefUsecase;
  final GetAdditionalImagesRefUsecase _getAdditionalImagesRefUsecase;

  AddEditPatientPresenter(
      this._addPatientDataUsecase,
      this._getPatientInformationUsecase,
      this._editPatientDataUsecase,
      this._getAdditionalImagesRefUsecase,
      this._getImageRefUsecase);

  @override
  void dispose() {
    _addPatientDataUsecase.dispose();
    _getPatientInformationUsecase.dispose();
    _editPatientDataUsecase.dispose();
    _getImageRefUsecase.dispose();
    _getAdditionalImagesRefUsecase.dispose();
  }

  void getPatientInformation(UseCaseObserver observer,
      {required String patientId}) {
    _getPatientInformationUsecase.execute(
        observer, GetPatientsInformationUsecaseParams(patientId: patientId));
  }

  void editPatientData(UseCaseObserver observer,
      {required PatientInformation patientInformation,
      required String? localUserImagePath,
      required List<String> localImagesPath,
      required List<String> updatedUploadedImagesRef}) {
    _editPatientDataUsecase.execute(
        observer,
        EditPatientDataUsecaseParams(
            patientInformation: patientInformation,
            localUserImageFilePath: localUserImagePath,
            localImagesPath: localImagesPath,
            uploadedImagesRef: updatedUploadedImagesRef));
  }

  void addPatientData(UseCaseObserver observer,
      {required PatientInformation patientInformation,
      required String? localUserImagePath,
      required List<String> localImagesPath}) {
    _addPatientDataUsecase.execute(
        observer,
        AddPatientDataUsecaseParams(
            patientInformation: patientInformation,
            localUserImageFilePath: localUserImagePath,
            localImagesPath: localImagesPath));
  }

  void getuserImageRef(UseCaseObserver observer, {required String patientId}) {
    _getImageRefUsecase.execute(
        observer, GetUserImageRefUsecaseParams(patientId: patientId));
  }

  void getAdditionalImageRefs(UseCaseObserver observer,
      {required List<String> uploadedAdditionalImages}) {
    _getAdditionalImagesRefUsecase.execute(
        observer,
        GetAdditionalImagesRefUsecaseParams(
            uploadedImagePaths: uploadedAdditionalImages));
  }
}
