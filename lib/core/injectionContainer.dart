import 'package:dentist_app/app/home/presentation/homePresenter.dart';
import 'package:dentist_app/app/patientManagement/data/mapper/patientInformationEntityMapper.dart';
import 'package:dentist_app/app/patientManagement/data/repository/patientManagementRepositoryImpl.dart';
import 'package:dentist_app/app/patientManagement/data/wrapper/patientManagementFirebaseWrapper.dart';
import 'package:dentist_app/app/patientManagement/domain/repository/patientManagementRepository.dart';
import 'package:dentist_app/app/patientManagement/domain/usecases/fetchNextBatchOfPatientsMetaInformationUsecase.dart';
import 'package:dentist_app/app/patientManagement/domain/usecases/fetchPatientsMetaInformationUsecase.dart';
import 'package:dentist_app/app/patientManagement/domain/usecases/getPatientsMetaInformationUsecase.dart';
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

  ///Domain - usecases
  serviceLocator.registerFactory(
      () => FetchNextBatchOfPatientsMetaUsecase(serviceLocator()));
  serviceLocator
      .registerFactory(() => FetchPatientsMetaUsecase(serviceLocator()));
  serviceLocator.registerFactory(
      () => GetPatientsMetaInformationUsecase(serviceLocator()));

  ///Data
  serviceLocator.registerFactory(() => PatientInformationMapperEntity());

  serviceLocator.registerLazySingleton<PatientManagementRepository>(() =>
      PatientManagementRepositoryImpl(serviceLocator(), serviceLocator()));

  serviceLocator.registerFactory(() => PatientManagementFirebaseWrapper());
}

Future<void> reset() async {
  serviceLocator.resetLazySingleton<PatientManagementFirebaseWrapper>();
}
