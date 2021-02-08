import 'dart:io';

abstract class CloudStorageServiceInterface {
  Future<String> uploadClientPicture(File file, String fileName);
}
