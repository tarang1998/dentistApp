import 'package:dentalApp/app/patientManagement/data/keys/patientManagementKeys.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';

class PatientInformationMapperEntity {
  PatientInformation map(Map<String, dynamic> rawPatientData) {
    return PatientInformation(
        patientMetaInformation: PatientMetaInformation(
            patientId: rawPatientData[PatientManagementKeys.keyPatientId],
            emailId: rawPatientData[PatientManagementKeys.keyEmailId],
            name: rawPatientData[PatientManagementKeys.keyName],
            dob: rawPatientData[PatientManagementKeys.keyDOB].toDate(),
            sex: convertStringToEnum(
                Sex.values, rawPatientData[PatientManagementKeys.keySex])),
        address: rawPatientData[PatientManagementKeys.keyAddress],
        phoneNo: rawPatientData[PatientManagementKeys.keyPhoneNo],
        createdAt: rawPatientData[PatientManagementKeys.keyCreatedAt].toDate(),
        additionalInformation:
            rawPatientData[PatientManagementKeys.keyAdditionalInformation]);
  }
}
