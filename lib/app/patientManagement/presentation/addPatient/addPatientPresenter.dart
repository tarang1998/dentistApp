import 'package:dentist_app/app/patientManagement/domain/entities/addPatientEntity.dart';
import 'package:dentist_app/app/patientManagement/domain/usecases/addPatientDataUsecase.dart';
import 'package:dentist_app/core/presentation/observer.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class AddPatientPresenter extends Presenter {
  final AddPatientDataUsecase _addPatientDataUsecase;

  AddPatientPresenter(this._addPatientDataUsecase);

  @override
  void dispose() {
    _addPatientDataUsecase.dispose();
  }

  void addPatientData(UseCaseObserver observer,
      {required AddPatientEntity addPatientEntity}) {
    _addPatientDataUsecase.execute(observer, addPatientEntity);
  }
}
