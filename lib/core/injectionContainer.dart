import 'package:dentalApp/app/home/presentation/homePresenter.dart';
import 'package:dentalApp/app/patientManagement/data/mapper/patientInformationEntityMapper.dart';
import 'package:dentalApp/app/patientManagement/data/mapper/patientProcedureEntityMapper.dart';
import 'package:dentalApp/app/patientManagement/data/repository/patientManagementRepositoryImpl.dart';
import 'package:dentalApp/app/patientManagement/data/serializer/addEditPatientEntitySerializer.dart';
import 'package:dentalApp/app/patientManagement/data/serializer/addPatientProcedureSerializer.dart';
import 'package:dentalApp/app/patientManagement/data/wrapper/patientManagementFirebaseWrapper.dart';
import 'package:dentalApp/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/addPatientDataUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/addPatientProcedureDataUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/editPatientDataUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/fetchAllProceduresForPatientUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/fetchNextBatchOfPatientsMetaInformationUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/fetchPatientsMetaInformationUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/getPatientInformationUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/getPatientProcedureInformationUsecase.dart';
import 'package:dentalApp/app/patientManagement/domain/usecases/getPatientsMetaInformationUsecase.dart';
import 'package:dentalApp/app/patientManagement/presentation/addEditPatient/addEditPatientPresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientInformationPresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/addEditProcedure/addEditProcedurePresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/patientProcedurePresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientInformation/patientProcedure/viewProcedure/viewProcedurePresenter.dart';
import 'package:dentalApp/app/patientManagement/presentation/patientManagementPresenter.dart';
import 'package:dentalApp/core/navigationService.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  serviceLocator
      .registerLazySingleton<NavigationService>(() => AppNavigationService());

  //Home
  serviceLocator.registerFactory(() => HomePagePresenter());

  //Patient Management

  serviceLocator.registerFactory(() => PatientManagementPresenter(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => PatientInformationPresenter(
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => AddEditPatientPresenter(
      serviceLocator(), serviceLocator(), serviceLocator()));

  serviceLocator
      .registerFactory(() => ViewProcedurePresenter(serviceLocator()));

  serviceLocator
      .registerFactory(() => PatientProcedurePresenter(serviceLocator()));

  serviceLocator.registerFactory(
      () => AddEditProcedurePresenter(serviceLocator(), serviceLocator()));

  ///Domain - usecases
  serviceLocator.registerFactory(
      () => FetchNextBatchOfPatientsMetaUsecase(serviceLocator()));
  serviceLocator
      .registerFactory(() => FetchPatientsMetaUsecase(serviceLocator()));
  serviceLocator.registerFactory(
      () => GetPatientsMetaInformationUsecase(serviceLocator()));
  serviceLocator
      .registerFactory(() => GetPatientInformationUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => AddPatientDataUsecase(serviceLocator()));
  serviceLocator.registerFactory(
      () => FetchAllProceduresForPatientUsecase(serviceLocator()));
  serviceLocator
      .registerFactory(() => AddPatientProcedureDataUsecase(serviceLocator()));
  serviceLocator.registerFactory(
      () => GetPatientProcedureInformationUsecase(serviceLocator()));
  serviceLocator
      .registerFactory(() => EditPatientDataUsecase(serviceLocator()));

  ///Data

  ///Serializer
  serviceLocator.registerFactory(() => AddEditPatientEntitySerializer());
  serviceLocator.registerFactory(() => AddPatientProcedureSerializer());

  ///Mapper
  serviceLocator.registerFactory(() => PatientInformationMapperEntity());
  serviceLocator.registerFactory(() => PatientProcedureEntityMapper());

  ///Repository
  serviceLocator.registerLazySingleton<PatientManagementRepository>(() =>
      PatientManagementRepositoryImpl(serviceLocator(), serviceLocator(),
          serviceLocator(), serviceLocator(), serviceLocator()));

  ///Wrappers
  serviceLocator.registerFactory(() => PatientManagementFirebaseWrapper());
}

Future<void> reset() async {
  serviceLocator.resetLazySingleton<PatientManagementFirebaseWrapper>();
}
