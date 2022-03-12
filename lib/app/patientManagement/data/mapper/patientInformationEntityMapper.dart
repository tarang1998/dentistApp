import 'package:dentalApp/app/patientManagement/data/keys/patientManagementKeys.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';

class PatientInformationMapperEntity {
  PatientInformation map(Map<String, dynamic> rawPatientData) {
    return PatientInformation(
        patientPersonalInformation:
            mapPatientPersonalInformation(rawPatientData),
        patientMedicalInformation: mapPatientMedicalInformation(rawPatientData),
        patientMedicationInformation:
            mapPatientMedicationInformation(rawPatientData),
        patientDentalInformation: mapPatientDentalInformation(rawPatientData),
        updatedAt: rawPatientData[PatientManagementKeys.keyUpdatedAt].toDate(),
        createdAt: rawPatientData[PatientManagementKeys.keyCreatedAt].toDate(),
        additionalInformation:
            rawPatientData[PatientManagementKeys.keyAdditionalInformation]);
  }
}

PatientDentalInformation mapPatientDentalInformation(
    Map<String, dynamic> rawPatientData) {
  return PatientDentalInformation(
      mainComplain: rawPatientData[PatientManagementKeys.keyMainComplain],
      pastDentalTreatmentInformation: rawPatientData[
          PatientManagementKeys.keyPastDentalTreatmentInformation]);
}

PatientMedicationInformation mapPatientMedicationInformation(
    Map<String, dynamic> rawPatientData) {
  List<Allergies> allergies = [];

  List<String> rawAllergiesData =
      List<String>.from(rawPatientData[PatientManagementKeys.keyAllergies]);

  rawAllergiesData.forEach((element) =>
      {allergies.add(convertStringToEnum(Allergies.values, element))});

  return PatientMedicationInformation(
      medicationInformation:
          rawPatientData[PatientManagementKeys.keyMedicationInformation],
      allergies: allergies,
      allergiesInformation:
          rawPatientData[PatientManagementKeys.keyAllergiesInformation]);
}

PatientMedicalInformation mapPatientMedicalInformation(
    Map<String, dynamic> rawPatientData) {
  List<Diseases> diseases = [];

  List<String> rawDiseasesData =
      List<String>.from(rawPatientData[PatientManagementKeys.keyDiseases]);

  rawDiseasesData.forEach((element) =>
      {diseases.add(convertStringToEnum(Diseases.values, element))});

  List<Habits> habits = [];

  List<String> rawHabitsData =
      List<String>.from(rawPatientData[PatientManagementKeys.keyHabits]);

  rawHabitsData.forEach(
      (element) => {habits.add(convertStringToEnum(Habits.values, element))});

  return PatientMedicalInformation(
    familyDoctorsName:
        rawPatientData[PatientManagementKeys.keyFamilyDoctorsName],
    familyDoctorsAddressInformation:
        rawPatientData[PatientManagementKeys.keyFamilyDoctorAddressInformation],
    diseases: diseases,
    habits: habits,
    pregnancyStatus: convertStringToEnum(PregnancyStatus.values,
        rawPatientData[PatientManagementKeys.keyPregnancyStatus]),
    childNursingStatus: convertStringToEnum(ChildNursingStatus.values,
        rawPatientData[PatientManagementKeys.keyChildNursingStatus]),
  );
}

PatientPersonalInformation mapPatientPersonalInformation(
    Map<String, dynamic> rawPatientData) {
  return PatientPersonalInformation(
      address: rawPatientData[PatientManagementKeys.keyAddress],
      bloodGroup: convertStringToEnum(BloodGroup.values,
          rawPatientData[PatientManagementKeys.keyBloodGroup]),
      maritialStatus: convertStringToEnum(MaritialStatus.values,
          rawPatientData[PatientManagementKeys.keyMaritialStatus]),
      mobileNo: rawPatientData[PatientManagementKeys.keyMobileNo],
      officeInformation:
          rawPatientData[PatientManagementKeys.keyOfficeInformation],
      patientMetaInformation: mapPatientMetaInformation(rawPatientData),
      profession: rawPatientData[PatientManagementKeys.keyProfession],
      refferedBy: rawPatientData[PatientManagementKeys.keyRefferedBy],
      telephoneNo: rawPatientData[PatientManagementKeys.keyTelephoneNo]);
}

PatientMetaInformation mapPatientMetaInformation(
    Map<String, dynamic> rawPatientData) {
  return PatientMetaInformation(
      patientId: rawPatientData[PatientManagementKeys.keyPatientId],
      emailId: rawPatientData[PatientManagementKeys.keyEmailId],
      name: rawPatientData[PatientManagementKeys.keyName],
      dob: rawPatientData[PatientManagementKeys.keyDOB].toDate(),
      sex: convertStringToEnum(
          Sex.values, rawPatientData[PatientManagementKeys.keySex]));
}
