import 'dart:io';

abstract class ImageSelectionServiceInterface {
  Future<File> chooseImageFromStorage();
}
