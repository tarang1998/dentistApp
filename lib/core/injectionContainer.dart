import 'package:dentist_app/app/home/presentation/homePresenter.dart';
import 'package:dentist_app/app/patientManagement/data/mapper/patientInformationEntityMapper.dart';
import 'package:dentist_app/app/patientManagement/data/repository/patientManagementRepositoryImpl.dart';
import 'package:dentist_app/app/patientManagement/data/serializer/addPatientEntitySerializer.dart';
import 'package:dentist_app/app/patientManagement/data/wrapper/patientManagementFirebaseWrapper.dart';
import 'package:dentist_app/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentist_app/app/patientManagement/domain/usecases/addPatientDataUsecase.dart';
import 'package:dentist_app/app/patientManagement/domain/usecases/fetchNextBatchOfPatientsMetaInformationUsecase.dart';
import 'package:dentist_app/app/patientManagement/domain/usecases/fetchPatientsMetaInformationUsecase.dart';
import 'package:dentist_app/app/patientManagement/domain/usecases/getPatientInformationUsecase.dart';
import 'package:dentist_app/app/patientManagement/domain/usecases/getPatientsMetaInformationUsecase.dart';
import 'package:dentist_app/app/patientManagement/presentation/addPatient/addPatientPresenter.dart';
import 'package:dentist_app/app/patientManagement/presentation/patientInformation/patientInformationPresenter.dart';
import 'package:dentist_app/app/patientManagement/presentation/patientManagementPresenter.dart';
import 'package:dentist_app/core/navigationService.dart';
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

  serviceLocator.registerFactory(() => AddPatientPresenter(serviceLocator()));

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

  ///Data

  ///Serializer
  serviceLocator.registerFactory(() => AddPatientEntitySerializer());

  ///Mapper
  serviceLocator.registerFactory(() => PatientInformationMapperEntity());

  ///Repository
  serviceLocator.registerLazySingleton<PatientManagementRepository>(() =>
      PatientManagementRepositoryImpl(
          serviceLocator(), serviceLocator(), serviceLocator()));

  ///Wrappers
  serviceLocator.registerFactory(() => PatientManagementFirebaseWrapper());
}

Future<void> reset() async {
  serviceLocator.resetLazySingleton<PatientManagementFirebaseWrapper>();
}
