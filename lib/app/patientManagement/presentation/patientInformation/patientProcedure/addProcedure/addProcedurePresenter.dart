import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/addPatientProcedureDataUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/getPatientInformationUsecase.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AddProcedurePresenter extends Presenter {
  final GetPatientInformationUsecase _getPatientInformationUsecase;
  final AddPatientProcedureDataUsecase _addPatientProcedureDataUsecase;

  AddProcedurePresenter(
      this._getPatientInformationUsecase, this._addPatientProcedureDataUsecase);

  @override
  void dispose() {
    _getPatientInformationUsecase.dispose();
  }

  void getPatientInformation(UseCaseObserver observer,
      {required String patientId}) {
    _getPatientInformationUsecase.execute(
        observer, GetPatientsInformationUsecaseParams(patientId: patientId));
  }

  void addPatientProcedure(UseCaseObserver observer,
      {required String patientId,
      required PatientProcedureEnity patientProcedureEntity}) {
    _addPatientProcedureDataUsecase.execute(
        observer,
        AddPatientProcedureDataUsecaseParams(
            patientId: patientId,
            patientProcedureEntity: patientProcedureEntity));
  }
}
