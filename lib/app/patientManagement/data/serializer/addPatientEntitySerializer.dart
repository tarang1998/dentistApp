import 'package:dentist_app/app/patientManagement/data/keys/patientManagementKeys.dart';
import 'package:dentist_app/app/patientManagement/domain/entities/addPatientEntity.dart';
import 'package:dentist_app/core/utilities/EnumStringConvertor.dart';

class AddPatientEntitySerializer {
  Map<String, dynamic> serialize(AddPatientEntity addPatientEntity) {
    Map<String, dynamic> _addPatientSerializedData = {};

    _addPatientSerializedData[PatientManagementKeys.keyName] =
        addPatientEntity.name;
    _addPatientSerializedData[PatientManagementKeys.keyAddress] =
        addPatientEntity.address;
    _addPatientSerializedData[PatientManagementKeys.keyPhoneNo] =
        addPatientEntity.phoneNo;
    _addPatientSerializedData[PatientManagementKeys.keyEmailId] =
        addPatientEntity.emailId;
    _addPatientSerializedData[PatientManagementKeys.keyCreatedAt] =
        addPatientEntity.createdAt;
    _addPatientSerializedData[PatientManagementKeys.keyDOB] =
        addPatientEntity.dob;
    _addPatientSerializedData[PatientManagementKeys.keySex] =
        enumValueToString(addPatientEntity.sex);
    _addPatientSerializedData[PatientManagementKeys.keyAdditionalInformation] =
        enumValueToString(addPatientEntity.sex);

    return _addPatientSerializedData;
  }
}
