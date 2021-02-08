import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:personal_trainer_client/core/services/cloud_storage_service/cloud_storage_service_interface.dart';

class CloudStorageService extends CloudStorageServiceInterface {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<String> uploadClientPicture(File file, String fileName) async {
    try {
      fileName = 'clients/$fileName';
      var uploadRef = _storage.ref().child(fileName);

      await uploadRef.putFile(file).onComplete;
      var downloadUrl = await uploadRef.getDownloadURL();

      return downloadUrl.toString();
    } catch (e) {
      return '';
    }
  }
}
