import 'package:flutter_icons/flutter_icons.dart';
import 'package:personal_trainer_client/core/viewmodels/update_booking_viewmodel.dart';
import 'package:personal_trainer_client/locator.dart';
import 'package:personal_trainer_client/ui/constants/colors.dart';
import 'package:personal_trainer_client/ui/constants/enums.dart';
import 'package:personal_trainer_client/ui/constants/margins.dart';
import 'package:personal_trainer_client/ui/constants/text_sizes.dart';
import 'package:personal_trainer_client/ui/constants/ui_helpers.dart';
import 'package:personal_trainer_client/ui/shared/background_gradient.dart';
import 'package:personal_trainer_client/ui/shared/custom_text_button.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final builders = {
    DialogType.editInputField: (context, sheetRequest, completer) =>
        _EditInputDialog(completer: completer, request: sheetRequest),
    DialogType.updateBooking: (context, sheetRequest, completer) =>
        _UpdateTimeSlotDialog(
          completer: completer,
          request: sheetRequest,
        ),
    DialogType.drawer: (context, sheetRequest, completer) => _DrawerDialog(
          completer: completer,
          request: sheetRequest,
        ),
    DialogType.bookSlotDialog: (context, sheetRequest, completer) =>
        _BookSlotDialog(
          completer: completer,
          request: sheetRequest,
        )
  };

  dialogService.registerCustomDialogBuilders(builders);
}

class _BookSlotDialog extends StatelessWidget {
  final DialogRequest request;
  String day;
  String time;
  final Function(DialogResponse) completer;
  _BookSlotDialog({Key key, this.request, this.completer}) : super(key: key) {
    var arguments = request.customData['value'];
    day = arguments['day'].toString();
    time = arguments['time'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54.withOpacity(0.5),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: dialogHorizontalMargin,
              vertical: dialogHorizontalMargin + 100),
          width: double.infinity,
          height: 240,
          color: backgroundColor,
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              mediumSpace,
              Text(
                request.title,
                style: largeTextFont.copyWith(
                    color: primaryColorDark, fontSize: 20),
              ),
              largeSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day + ', ' + time,
                    style: mediumTextFont.copyWith(fontSize: 24),
                  )
                ],
              ),
              largeSpace,
              customTextButton(
                  buttonText: request.title,
                  onTapCallback: () =>
                      completer(DialogResponse(confirmed: true))),
              mediumSpace
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  _DrawerDialog({Key key, this.request, this.completer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54.withOpacity(0.5),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.only(right: 80),
        color: backgroundColor,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(gradient: backgroundGradient),
              child: Container(
                padding: EdgeInsets.all(20),
                height: 120,
                child: Row(
                  children: [
                    Text(
                      request.title,
                      style: largeTextFont.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            largeSpace,
            drawerListTile('Setup working days', 'setup'),
            smallSpace,
            drawerListTile('Help', 'help'),
            smallSpace,
            drawerListTile('Logout', 'logout')
          ],
        ),
      ),
    );
  }

  Widget drawerListTile(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: mediumTextFont.copyWith(fontSize: 20),
      ),
      onTap: () => completer(DialogResponse(responseData: value)),
    );
  }
}

class _UpdateTimeSlotDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  TextEditingController inputController;
  _UpdateTimeSlotDialog({Key key, this.request, this.completer})
      : super(key: key) {
    inputController =
        TextEditingController(text: request.customData['value'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateBookingViewModel>.reactive(
      onModelReady: (model) => model.initialise(),
      viewModelBuilder: () => UpdateBookingViewModel(),
      builder: (context, model, builder) => Container(
        margin: EdgeInsets.symmetric(
            horizontal: dialogHorizontalMargin - 30,
            vertical: dialogVerticalMargin - 70),
        padding: EdgeInsets.symmetric(
            horizontal: dialogHorizontalMargin, vertical: 20),
        color: backgroundColor,
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                mediumSpace,
                Text(
                  'Update booking',
                  style: largeTextFont.copyWith(
                      color: primaryColorDark, fontSize: 20),
                ),
                mediumSpace,
                Column(
                  children: model.updateOptions
                      .map((option) => checkboxRadioButton(
                          option,
                          option == model.selectedOption,
                          model.updateSelectedOption))
                      .toList(),
                ),
                largeSpace,
                TextFormField(
                  controller: inputController,
                  enabled: !model.disableKeyboard,
                ),
                largeSpace,
                customTextButton(
                    buttonText: 'Update booking',
                    onTapCallback: () => completer(DialogResponse(
                            responseData: {
                              'selectedOption': model.selectedOption,
                              'clientID': inputController.text
                            })))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget checkboxRadioButton(
      String value, bool isChecked, Function onTapCallback) {
    return CheckboxListTile(
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
      value: isChecked,
      onChanged: (_) => onTapCallback(value),
      title: Text(
        value,
        style: mediumTextFont,
      ),
    );
  }
}

class _EditInputDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  var inputController;
  _EditInputDialog({Key key, this.request, this.completer}) : super(key: key) {
    inputController =
        TextEditingController(text: request.customData['value'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: pageHorizontalMargin, vertical: pageVerticalMargin),
      color: backgroundColor,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mediumSpace,
            IconButton(
              padding: EdgeInsets.all(0),
              alignment: Alignment.topLeft,
              icon: Icon(
                Entypo.cross,
                color: Colors.black87,
              ),
              onPressed: null,
            ),
            extraLargeSpace,
            largeSpace,
            Text(
              request.title,
              style:
                  smallTextFont.copyWith(color: Colors.black87, fontSize: 14),
            ),
            TextFormField(
              keyboardType:
                  request.customData['inputType'] ?? TextInputType.text,
              controller: inputController,
              autofocus: true,
            ),
            Expanded(child: Text('')),
            customTextButton(
                buttonText: 'Update ${request.title}',
                onTapCallback: () => completer(
                    DialogResponse(responseData: inputController.text))),
            mediumSpace
          ],
        ),
      ),
    );
  }
}
