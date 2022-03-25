import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class PatientManagementFirebaseStorageWrapper {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final String _storageBucket = "gs://dentalapp-20797.appspot.com/";

  Future<void> uploadUserImageFile(
      String userImageStorageLocation, String filePath) async {
    Reference _storageReference =
        _storage.refFromURL(_storageBucket + userImageStorageLocation);

    Uint8List fileBytes = await File(filePath).readAsBytes();

    await _storageReference.putData(fileBytes);
  }

  Future<String> getDownloadableUri(
      {required String userImageStorageLocation}) async {
    Reference _storgaeReference =
        _storage.refFromURL(_storageBucket + userImageStorageLocation);

    String downloadableUserImage = await _storgaeReference.getDownloadURL();

    return downloadableUserImage;
  }
}
