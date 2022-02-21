import 'package:dentist_app/app/patientManagement/domain/usecases/fetchNextBatchOfPatientsMetaInformationUsecase.dart';
import 'package:dentist_app/app/patientManagement/domain/usecases/fetchPatientsMetaInformationUsecase.dart';
import 'package:dentist_app/app/patientManagement/domain/usecases/getPatientsMetaInformationUsecase.dart';
import 'package:dentist_app/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class PatientManagementPresenter extends Presenter {
  final FetchNextBatchOfPatientsMetaUsecase
      _fetchNextBatchOfPatientsMetaUsecase;
  final FetchPatientsMetaUsecase _fetchPatientsMetaUsecase;
  final GetPatientsMetaInformationUsecase _getListOfPatientsMetaUsecase;

  PatientManagementPresenter(
      this._getListOfPatientsMetaUsecase,
      this._fetchPatientsMetaUsecase,
      this._fetchNextBatchOfPatientsMetaUsecase);

  @override
  void dispose() {
    _fetchNextBatchOfPatientsMetaUsecase.dispose();
    _fetchPatientsMetaUsecase.dispose();
    _getListOfPatientsMetaUsecase.dispose();
  }

  void getPatientsMetaInformation(UseCaseObserver observer) {
    _getListOfPatientsMetaUsecase.execute(observer);
  }

  void fetchPatientsMetaInformation(UseCaseObserver observer) {
    _fetchPatientsMetaUsecase.execute(observer);
  }

  void fetchNextBatchOfPatientsMetaInformation(UseCaseObserver observer) {
    _fetchNextBatchOfPatientsMetaUsecase.execute(observer);
  }
}
