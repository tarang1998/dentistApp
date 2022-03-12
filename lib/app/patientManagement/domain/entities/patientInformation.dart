class PatientInformation {
  final PatientPersonalInformation patientPersonalInformation;
  final PatientMedicalInformation patientMedicalInformation;
  final PatientMedicationInformation patientMedicationInformation;
  final PatientDentalInformation patientDentalInformation;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String additionalInformation;

  PatientInformation(
      {required this.patientPersonalInformation,
      required this.patientMedicalInformation,
      required this.patientMedicationInformation,
      required this.patientDentalInformation,
      required this.createdAt,
      required this.updatedAt,
      required this.additionalInformation});
}

class PatientMetaInformation {
  final String patientId;
  final String name;
  final DateTime dob;
  final Sex sex;
  final String emailId;

  PatientMetaInformation({
    required this.patientId,
    required this.name,
    required this.dob,
    required this.sex,
    required this.emailId,
  });
}

class PatientPersonalInformation {
  final PatientMetaInformation patientMetaInformation;
  final String address;
  final MaritialStatus maritialStatus;
  final String profession;
  final int? telephoneNo;
  final int mobileNo;
  final BloodGroup bloodGroup;
  final String officeInformation;
  final String refferedBy;

  PatientPersonalInformation({
    required this.patientMetaInformation,
    required this.address,
    required this.maritialStatus,
    required this.profession,
    required this.telephoneNo,
    required this.mobileNo,
    required this.bloodGroup,
    required this.officeInformation,
    required this.refferedBy,
  });
}

class PatientMedicalInformation {
  final String familyDoctorsName;
  final String familyDoctorsAddressInformation;
  final List<Diseases> diseases;
  final PregnancyStatus pregnancyStatus;
  final ChildNursingStatus childNursingStatus;
  final List<Habits> habits;

  PatientMedicalInformation({
    required this.familyDoctorsName,
    required this.familyDoctorsAddressInformation,
    required this.diseases,
    required this.pregnancyStatus,
    required this.childNursingStatus,
    required this.habits,
  });
}

class PatientMedicationInformation {
  final String medicationInformation;
  final List<Allergies> allergies;
  final String allergiesInformation;

  PatientMedicationInformation(
      {required this.medicationInformation,
      required this.allergies,
      required this.allergiesInformation});
}

class PatientDentalInformation {
  final String mainComplain;
  final String pastDentalTreatmentInformation;

  PatientDentalInformation(
      {required this.mainComplain,
      required this.pastDentalTreatmentInformation});
}

enum Sex { MALE, FEMALE, OTHER }

enum MaritialStatus { MARRIED, SINGLE }

enum BloodGroup { AP, AN, BP, BN, OP, ON, ABP, ABN }

enum Diseases {
  AIDS,
  CANCER,
  JAUNDICE,
  RHEUMATIC_FEVER,
  ASTHMA,
  DIABETES,
  LIVER_DISEASE,
  TB,
  ARTHRITIS_RHEUMATISM,
  EPILEPSY,
  KIDNEY_DISEASE,
  THYROID_PROBLEMS,
  BLOOD_DISEASE,
  HEART_PROBLEMS,
  PSYCHIATRIC_TREATMENT,
  ULCER,
  HIGH_BLOOD_PRESSURE,
  LOW_BLOOD_PRESSURE,
  HEPATITIS,
  RADIATION_TREATMENT,
  VENEREAL_DISEASE,
  CORTICOSTEROID_TREATMENT,
  HERPES,
  RESPIRATORY_TREATMENT
}

enum PregnancyStatus { PREGNANT, NOT_PREGNANT, NOT_APPLICABLE }

enum ChildNursingStatus { NURSING_CHILD, NOT_NURSING_CHILD, NOT_APPLICABLE }

enum Habits { PAN_MASALA_CHEWING, PAN_CHEWING_TOBACCO, SMOKING }

enum Allergies {
  PENICILLIN,
  SULFA,
  ASPIRIN,
  IODINE,
  LOCAL_ANAESTHETIC,
  IBUPROFEN
}
