import 'package:dentalApp/app/patientManagement/domain/usecases/getPatientInformationUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/getUserImageRefUsecase.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientInformationPresenter extends Presenter {
  final GetPatientInformationUsecase _getPatientsInformationUsecase;
  final GetUserImageRefUsecase _getUserImageRefUsecase;

  PatientInformationPresenter(
      this._getPatientsInformationUsecase, this._getUserImageRefUsecase);

  @override
  void dispose() {
    _getPatientsInformationUsecase.dispose();
    _getUserImageRefUsecase.dispose();
  }

  void getPatientData(UseCaseObserver observer, String patientId) {
    _getPatientsInformationUsecase.execute(
        observer, GetPatientsInformationUsecaseParams(patientId: patientId));
  }

  void getUserImageRef(UseCaseObserver observer, String patientId) {
    _getUserImageRefUsecase.execute(
        observer, GetUserImageRefUsecaseParams(patientId: patientId));
  }
}
