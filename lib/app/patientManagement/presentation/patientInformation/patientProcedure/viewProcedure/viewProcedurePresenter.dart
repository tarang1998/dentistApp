import 'package:dentalApp/app/patientManagement/domain/usecases/getPatientProcedureInformationUsecase.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class ViewProcedurePresenter extends Presenter {
  final GetPatientProcedureInformationUsecase
      _getPatientProcedureInformationUsecase;

  ViewProcedurePresenter(this._getPatientProcedureInformationUsecase);

  @override
  void dispose() {
    _getPatientProcedureInformationUsecase.dispose();
  }

  void getPatientProcedureInformation(UseCaseObserver observer,
      {required String patientId, required String patientProcedureId}) {
    _getPatientProcedureInformationUsecase.execute(
        observer,
        GetPatientProcedureInformationUsecaseParams(
            patientId: patientId, patientProcedureId: patientProcedureId));
  }
}
