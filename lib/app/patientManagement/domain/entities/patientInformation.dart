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
  final int age;
  final Sex sex;

  PatientMetaInformation(
      {required this.patientId,
      required this.name,
      required this.age,
      required this.sex});
}

enum Sex { male, female, other }
