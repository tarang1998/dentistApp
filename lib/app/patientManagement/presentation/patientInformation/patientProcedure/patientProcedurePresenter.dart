import 'package:dentalApp/app/patientManagement/domain/usecases/fetchAllProceduresForPatientUsecase.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientProcedurePresenter extends Presenter {
  final FetchAllProceduresForPatientUsecase
      _fetchAllProceduresForPatientsUsecase;

  PatientProcedurePresenter(this._fetchAllProceduresForPatientsUsecase);

  @override
  void dispose() {
    _fetchAllProceduresForPatientsUsecase.dispose();
  }

  void fetchAllProceduresForPatients(UseCaseObserver observer,
      {required String patientId}) {
    _fetchAllProceduresForPatientsUsecase.execute(observer,
        FetchAllProceduresForPatientUsecaseParams(patientId: patientId));
  }
}
