import 'package:dentalApp/app/patientManagement/data/keys/patientManagementKeys.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';

class AddEditPatientEntitySerializer {
  Map<String, dynamic> serialize(
      PatientInformation patientInformation, String? userImageStorageLocation) {
    Map<String, dynamic> _addPatientSerializedData = {};

    ///PatientPersonalInforamtion
    ////PatientMetaInformation
    _addPatientSerializedData[PatientManagementKeys.keyName] =
        patientInformation
            .patientPersonalInformation.patientMetaInformation.name;
    _addPatientSerializedData[PatientManagementKeys.keyEmailId] =
        patientInformation
            .patientPersonalInformation.patientMetaInformation.emailId;
    _addPatientSerializedData[PatientManagementKeys.keyDOB] = patientInformation
        .patientPersonalInformation.patientMetaInformation.dob;
    _addPatientSerializedData[PatientManagementKeys.keySex] = enumValueToString(
        patientInformation
            .patientPersonalInformation.patientMetaInformation.sex);

    _addPatientSerializedData[PatientManagementKeys.keyAddress] =
        patientInformation.patientPersonalInformation.address;
    _addPatientSerializedData[PatientManagementKeys.keyMobileNo] =
        patientInformation.patientPersonalInformation.mobileNo;
    _addPatientSerializedData[PatientManagementKeys.keyTelephoneNo] =
        patientInformation.patientPersonalInformation.telephoneNo;
    _addPatientSerializedData[PatientManagementKeys.keyProfession] =
        patientInformation.patientPersonalInformation.profession;
    _addPatientSerializedData[PatientManagementKeys.keyMaritialStatus] =
        enumValueToString(
            patientInformation.patientPersonalInformation.maritialStatus);
    _addPatientSerializedData[PatientManagementKeys.keyBloodGroup] =
        enumValueToString(
            patientInformation.patientPersonalInformation.bloodGroup);
    _addPatientSerializedData[PatientManagementKeys.keyRefferedBy] =
        patientInformation.patientPersonalInformation.refferedBy;
    _addPatientSerializedData[PatientManagementKeys.keyOfficeInformation] =
        patientInformation.patientPersonalInformation.officeInformation;

    ///Patient Medical Information
    _addPatientSerializedData[PatientManagementKeys.keyFamilyDoctorsName] =
        patientInformation.patientMedicalInformation.familyDoctorsName;
    _addPatientSerializedData[
            PatientManagementKeys.keyFamilyDoctorAddressInformation] =
        patientInformation
            .patientMedicalInformation.familyDoctorsAddressInformation;

    List<String> rawDiseasesData = [];
    patientInformation.patientMedicalInformation.diseases.forEach((element) {
      rawDiseasesData.add(enumValueToString(element));
    });
    _addPatientSerializedData[PatientManagementKeys.keyDiseases] =
        rawDiseasesData;

    _addPatientSerializedData[PatientManagementKeys.keyPregnancyStatus] =
        enumValueToString(
            patientInformation.patientMedicalInformation.pregnancyStatus);
    _addPatientSerializedData[PatientManagementKeys.keyChildNursingStatus] =
        enumValueToString(
            patientInformation.patientMedicalInformation.childNursingStatus);

    List<String> rawHabitsData = [];
    patientInformation.patientMedicalInformation.habits.forEach((element) {
      rawHabitsData.add(enumValueToString(element));
    });
    _addPatientSerializedData[PatientManagementKeys.keyHabits] = rawHabitsData;

    ///Patient Medication Information
    _addPatientSerializedData[PatientManagementKeys.keyMedicationInformation] =
        patientInformation.patientMedicationInformation.medicationInformation;

    List<String> rawAllergiesData = [];
    patientInformation.patientMedicationInformation.allergies
        .forEach((element) {
      rawAllergiesData.add(enumValueToString(element));
    });

    _addPatientSerializedData[PatientManagementKeys.keyAllergies] =
        rawAllergiesData;
    _addPatientSerializedData[PatientManagementKeys.keyAllergiesInformation] =
        patientInformation.patientMedicationInformation.allergiesInformation;

    ///Patient Dental Information
    _addPatientSerializedData[PatientManagementKeys.keyMainComplain] =
        patientInformation.patientDentalInformation.mainComplain;
    _addPatientSerializedData[
            PatientManagementKeys.keyPastDentalTreatmentInformation] =
        patientInformation
            .patientDentalInformation.pastDentalTreatmentInformation;

    _addPatientSerializedData[PatientManagementKeys.keyCreatedAt] =
        patientInformation.createdAt;
    _addPatientSerializedData[PatientManagementKeys.keyUpdatedAt] =
        patientInformation.updatedAt;
    _addPatientSerializedData[PatientManagementKeys.keyAdditionalInformation] =
        enumValueToString(patientInformation.additionalInformation);

    if (userImageStorageLocation != null) {
      _addPatientSerializedData[PatientManagementKeys.keyUserImage] =
          userImageStorageLocation;
    }

    return _addPatientSerializedData;
  }
}
