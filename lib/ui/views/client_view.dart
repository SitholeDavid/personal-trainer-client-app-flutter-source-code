import 'dart:io';

import 'package:flutter/material.dart';
import 'package:personal_trainer_client/core/models/client.dart';
import 'package:personal_trainer_client/core/viewmodels/client_viewmodel.dart';
import 'package:personal_trainer_client/ui/constants/colors.dart';
import 'package:personal_trainer_client/ui/constants/margins.dart';
import 'package:personal_trainer_client/ui/constants/text_sizes.dart';
import 'package:personal_trainer_client/ui/constants/ui_helpers.dart';
import 'package:personal_trainer_client/ui/shared/custom_text_button.dart';
import 'package:personal_trainer_client/ui/shared/display_input_field.dart';
import 'package:personal_trainer_client/ui/widgets/loading_indicator.dart';
import 'package:stacked/stacked.dart';

class ClientView extends StatelessWidget {
  final Client existingClient;
  ClientView({this.existingClient});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ClientViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
          backgroundColor: backgroundColor,
          body: Stack(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: pageHorizontalMargin,
                      vertical: pageVerticalMargin),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mediumSpace,
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                onPressed: model.navigateToPrevView),
                            Text(
                              model.viewTitle,
                              style: largeTextFont.copyWith(
                                  fontSize: 22, color: primaryColorDark),
                            ),
                          ],
                        ),
                        mediumSpace,
                        Text(
                          model.viewSubTitle,
                          style: mediumTextFont,
                        ),
                        largeSpace,
                        Flexible(
                            child: ListView(
                          padding: EdgeInsets.all(0),
                          children: [
                            displayProfilePicture(model.client.pictureUrl,
                                model.localImage, model.updateProfilePicture),
                            mediumSpace,
                            displayInputField(
                                'Name', model.client.name, model.updateName),
                            displayInputField('Surname', model.client.surname,
                                model.updateSurname),
                            displayInputField('Weight', model.currentWeight,
                                model.updateWeight),
                            displayInputField('Height', model.client.height,
                                model.updateHeight),
                            displayInputField(
                                'Health conditions',
                                model.client.healthConditions,
                                model.updateHealthConditions),
                            displayInputField('Phone number',
                                model.client.phoneNo, model.updatePhoneNo),
                            mediumSpace,
                            customTextButton(
                                buttonText: model.buttonTitle,
                                onTapCallback: model.saveClient)
                          ],
                        ))
                      ])),
              model.isBusy
                  ? loadingIndicator(loadingText: 'updating profile..')
                  : emptySpace
            ],
          )),
      viewModelBuilder: () => ClientViewModel(),
      onModelReady: (model) => model.initialise(existingClient),
    );
  }
}

Widget displayProfilePicture(
    String profilePicUrl, File localImage, Function onTapCallback) {
  const double imageHeight = 130;

  return FlatButton(
      onPressed: onTapCallback,
      child: Container(
        height: imageHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: profilePicUrl.isEmpty && localImage == null
                    ? AssetImage('assets/images/default_profile_picture.jpg')
                    : (localImage == null
                        ? NetworkImage(profilePicUrl)
                        : FileImage(localImage)))),
      ));
}
