import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/addPatientDataUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/editPatientDataUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/getPatientInformationUsecase.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AddEditPatientPresenter extends Presenter {
  final AddPatientDataUsecase _addPatientDataUsecase;
  final GetPatientInformationUsecase _getPatientInformationUsecase;
  final EditPatientDataUsecase _editPatientDataUsecase;

  AddEditPatientPresenter(this._addPatientDataUsecase,
      this._getPatientInformationUsecase, this._editPatientDataUsecase);

  @override
  void dispose() {
    _addPatientDataUsecase.dispose();
    _getPatientInformationUsecase.dispose();
    _editPatientDataUsecase.dispose();
  }

  void getPatientInformation(UseCaseObserver observer,
      {required String patientId}) {
    _getPatientInformationUsecase.execute(
        observer, GetPatientsInformationUsecaseParams(patientId: patientId));
  }

  void editPatientData(UseCaseObserver observer,
      {required PatientInformation patientInformation,
      required String? localUserImagePath}) {
    _editPatientDataUsecase.execute(
        observer,
        EditPatientDataUsecaseParams(
            patientInformation: patientInformation,
            localUserImageFilePath: localUserImagePath));
  }

  void addPatientData(UseCaseObserver observer,
      {required PatientInformation patientInformation,
      required String? localUserImagePath}) {
    _addPatientDataUsecase.execute(
        observer,
        AddPatientDataUsecaseParams(
            patientInformation: patientInformation,
            localUserImageFilePath: localUserImagePath));
  }
}
