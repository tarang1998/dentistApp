import 'package:dentalApp/app/patientManagement/domain/entities/patientProcedureEntity.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/addPatientProcedureDataUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/editPatientProcedureUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/getPatientInformationUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/getPatientProcedureInformationUsecase.dart';
import 'package:dentalApp/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AddEditProcedurePresenter extends Presenter {
  final GetPatientInformationUsecase _getPatientInformationUsecase;
  final AddPatientProcedureDataUsecase _addPatientProcedureDataUsecase;
  final GetPatientProcedureInformationUsecase
      _getPatientProcedureInformationUsecase;
  final EditPatientProcedureUsecase _editPatientProcedureUsecase;

  AddEditProcedurePresenter(
      this._getPatientInformationUsecase,
      this._addPatientProcedureDataUsecase,
      this._getPatientProcedureInformationUsecase,
      this._editPatientProcedureUsecase);

  @override
  void dispose() {
    _getPatientInformationUsecase.dispose();
    _addPatientProcedureDataUsecase.dispose();
    _getPatientProcedureInformationUsecase.dispose();
    _editPatientProcedureUsecase.dispose();
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

  void getPatientProcedureInformationUsecase(UseCaseObserver observer,
      {required String patientId, required String procedureId}) {
    _getPatientProcedureInformationUsecase.execute(
        observer,
        GetPatientProcedureInformationUsecaseParams(
            patientId: patientId, patientProcedureId: procedureId));
  }

  void editPatientProcedure(UseCaseObserver observer,
      {required String patientId,
      required String procedureId,
      required PatientProcedureEnity patientProcedureEntity}) {
    _editPatientProcedureUsecase.execute(
        observer,
        EditPatientProcedureUsecaseParams(
            patientId: patientId,
            procedureId: procedureId,
            patientProcedureEntity: patientProcedureEntity));
  }
}
