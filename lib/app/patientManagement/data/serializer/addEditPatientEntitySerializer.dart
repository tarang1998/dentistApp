import 'package:dentalApp/app/patientManagement/data/keys/patientManagementKeys.dart';
import 'package:dentalApp/app/patientManagement/domain/entities/patientInformation.dart';
import 'package:dentalApp/core/utilities/EnumStringConvertor.dart';

class AddEditPatientEntitySerializer {
  Map<String, dynamic> serialize(PatientInformation patientInformation) {
    Map<String, dynamic> _addPatientSerializedData = {};

    _addPatientSerializedData[PatientManagementKeys.keyName] =
        patientInformation.patientMetaInformation.name;
    _addPatientSerializedData[PatientManagementKeys.keyAddress] =
        patientInformation.address;
    _addPatientSerializedData[PatientManagementKeys.keyPhoneNo] =
        patientInformation.phoneNo;
    _addPatientSerializedData[PatientManagementKeys.keyEmailId] =
        patientInformation.patientMetaInformation.emailId;
    _addPatientSerializedData[PatientManagementKeys.keyCreatedAt] =
        patientInformation.createdAt;
    _addPatientSerializedData[PatientManagementKeys.keyDOB] =
        patientInformation.patientMetaInformation.dob;
    _addPatientSerializedData[PatientManagementKeys.keySex] =
        enumValueToString(patientInformation.patientMetaInformation.sex);
    _addPatientSerializedData[PatientManagementKeys.keyAdditionalInformation] =
        enumValueToString(patientInformation.additionalInformation);

    return _addPatientSerializedData;
  }
}
