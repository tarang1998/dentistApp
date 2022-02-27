import 'package:dentist_app/app/patientManagement/data/keys/patientManagementKeys.dart';
import 'package:dentist_app/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentist_app/core/utilities/EnumStringConvertor.dart';

class PatientInformationMapperEntity {
  PatientInformation map(Map<String, dynamic> rawPatientData) {
    return PatientInformation(
        patientMetaInformation: PatientMetaInformation(
            patientId: rawPatientData[PatientManagementKeys.keyPatientId],
            name: rawPatientData[PatientManagementKeys.keyName],
            dob: rawPatientData[PatientManagementKeys.keyDOB].toDate(),
            sex: convertStringToEnum(
                Sex.values, rawPatientData[PatientManagementKeys.keySex])),
        address: rawPatientData[PatientManagementKeys.keyAddress],
        emailId: rawPatientData[PatientManagementKeys.keyEmailId],
        phoneNo: rawPatientData[PatientManagementKeys.keyPhoneNo],
        createdAt: rawPatientData[PatientManagementKeys.keyCreatedAt].toDate(),
        additionalInformation:
            rawPatientData[PatientManagementKeys.keyAdditionalInformation]);
  }
}
