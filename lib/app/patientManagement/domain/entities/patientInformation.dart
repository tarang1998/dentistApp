class PatientInformation {
  final PatientMetaInformation patientMetaInformation;
  final String address;
  final String emailId;
  final String phoneNo;
  final DateTime createdAt;
  final String additionalInformation;

  PatientInformation(
      {required this.patientMetaInformation,
      required this.address,
      required this.emailId,
      required this.phoneNo,
      required this.createdAt,
      required this.additionalInformation});
}

class PatientMetaInformation {
  final String patientId;
  final String name;
  final DateTime dob;
  final Sex sex;

  PatientMetaInformation(
      {required this.patientId,
      required this.name,
      required this.dob,
      required this.sex});
}

enum Sex { MALE, FEMALE, OTHER }
