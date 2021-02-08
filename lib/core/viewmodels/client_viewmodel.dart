import 'package:flutter/cupertino.dart';
import 'package:personal_trainer_client/core/models/client.dart';
import 'package:personal_trainer_client/core/services/cloud_storage_service/cloud_storage_service.dart';
import 'package:personal_trainer_client/core/services/cloud_storage_service/cloud_storage_service_interface.dart';
import 'package:personal_trainer_client/core/services/firestore_service/firestore_service.dart';
import 'package:personal_trainer_client/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_client/core/services/image_selection_service/image_selection_service.dart';
import 'package:personal_trainer_client/core/services/image_selection_service/image_selection_service_interface.dart';
import 'package:personal_trainer_client/locator.dart';
import 'package:personal_trainer_client/ui/constants/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../utils.dart';

class ClientViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final DialogService _dialogService = locator<DialogService>();

  final ImageSelectionService _imageService =
      locator<ImageSelectionServiceInterface>();
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageServiceInterface>();

  Client client;
  int trainerIndex;
  var viewTitle;
  var viewSubTitle;
  var buttonTitle;
  var currentWeight;
  var localImage;

  void initialise(Client existingClient) {
    client = existingClient ?? Client();
    currentWeight = client.weight.length == 0 ? 0.0 : client.weight.last;
    viewTitle = 'My profile';
    viewSubTitle = 'View and update your profile details below';
    buttonTitle = 'Update profile';
  }

  void updateProfilePicture() async {
    localImage = await _imageService.chooseImageFromStorage();
    notifyListeners();
  }

  void updateName() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Name',
        customData: dialogCustomData(client.name));

    client.name = response?.responseData?.toString();
    notifyListeners();
  }

  void updateSurname() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Surname',
        customData: dialogCustomData(client.surname));

    client.surname = response?.responseData?.toString();
    notifyListeners();
  }

  void updateEmail() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Email',
        customData: dialogCustomData(client.name,
            inputType: TextInputType.emailAddress));

    client.email = response?.responseData?.toString();
    notifyListeners();
  }

  void updateWeight() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Current weight',
        customData:
            dialogCustomData(currentWeight, inputType: TextInputType.number));

    currentWeight = response?.responseData == null
        ? 0.0
        : double.tryParse(response.responseData);

    notifyListeners();
  }

  void updateHeight() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Height',
        customData:
            dialogCustomData(client.height, inputType: TextInputType.number));

    client.height = response?.responseData == null
        ? 0.0
        : double.tryParse(response.responseData);

    notifyListeners();
  }

  void updateHealthConditions() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Health conditions',
        customData: dialogCustomData(client.healthConditions));

    client.healthConditions = response?.responseData?.toString();
    notifyListeners();
  }

  void updatePhoneNo() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Phone number',
        customData:
            dialogCustomData(client.phoneNo, inputType: TextInputType.phone));

    client.phoneNo = response?.responseData?.toString();
    notifyListeners();
  }

  void navigateToPrevView() {
    _navigationService.back();
  }

  void showEmptyFieldSnackbar(String fieldTitle) {
    _snackbarService.showSnackbar(
        message: '$fieldTitle can not be empty',
        duration: Duration(seconds: 2));
  }

  Future saveClient() async {
    setBusy(true);
    client.weight.add(currentWeight);
    try {
      String imgUrl = await uploadImage(client.clientID);
      client.pictureUrl = imgUrl;
      bool success = await _firestoreService.updateClient(client);

      if (!success) throw Error();

      _snackbarService.showSnackbar(message: 'Profile successfully updated');
    } catch (e) {
      _snackbarService.showSnackbar(
          message:
              'Profile could not be updated'); //'Profile could not be updated'
    }
    setBusy(false);
  }

  Future<String> uploadImage(String clientID) async {
    if (localImage == null) return '';

    String imgExtension = localImage.path.split('.').last;
    String imagePath = clientID + '.' + imgExtension;
    String imgDownloadUrl =
        await _cloudStorageService.uploadClientPicture(localImage, imagePath);

    return imgDownloadUrl;
  }
}
