class PatientInformation {
  final PatientMetaInformation patientMetaInformation;
  final String address;
  final String phoneNo;
  final DateTime createdAt;
  final String additionalInformation;

  PatientInformation(
      {required this.patientMetaInformation,
      required this.address,
      required this.phoneNo,
      required this.createdAt,
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

enum Sex { MALE, FEMALE, OTHER }
