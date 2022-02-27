import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';

class AddPatientEntity {
  final String name;
  final DateTime dob;
  final Sex sex;
  final String address;
  final String emailId;
  final String phoneNo;
  final String additionalInformation;
  final DateTime createdAt;

  AddPatientEntity(
      {required this.name,
      required this.dob,
      required this.sex,
      required this.address,
      required this.emailId,
      required this.phoneNo,
      required this.additionalInformation,
      required this.createdAt});
}
