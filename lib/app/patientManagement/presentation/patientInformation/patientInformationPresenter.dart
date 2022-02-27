import 'package:dentalApp/app/patientManagement/domain/usecases/getPatientInformationUsecase.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientInformationPresenter extends Presenter {
  final GetPatientInformationUsecase _getPatientsInformationUsecase;

  PatientInformationPresenter(this._getPatientsInformationUsecase);

  @override
  void dispose() {
    _getPatientsInformationUsecase.dispose();
  }

  void getPatientData(UseCaseObserver observer, String patientId) {
    _getPatientsInformationUsecase.execute(
        observer, GetPatientsInformationUsecaseParams(patientId: patientId));
  }
}
