import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:personal_trainer_client/core/models/client.dart';
import 'package:personal_trainer_client/core/viewmodels/current_plan_viewmodel.dart';
import 'package:personal_trainer_client/ui/constants/colors.dart';
import 'package:personal_trainer_client/ui/constants/margins.dart';
import 'package:personal_trainer_client/ui/constants/text_sizes.dart';
import 'package:personal_trainer_client/ui/constants/ui_helpers.dart';
import 'package:personal_trainer_client/ui/shared/custom_text_button.dart';
import 'package:personal_trainer_client/ui/widgets/loading_indicator.dart';
import 'package:stacked/stacked.dart';

class CurrentPlanView extends StatelessWidget {
  final int selectedTrainer;
  final Client myProfile;
  CurrentPlanView({this.selectedTrainer, this.myProfile});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CurrentPlanViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundColor.withOpacity(0.99),
              body: model.isBusy
                  ? loadingIndicatorLight(loadingText: 'Loading current plan..')
                  : Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: pageHorizontalMargin,
                              vertical: pageVerticalMargin),
                          child: Column(
                            children: [
                              mediumSpace,
                              Row(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: primaryColor,
                                      ),
                                      onPressed: null),
                                  Text(
                                    'Current plan',
                                    style: largeTextFont.copyWith(
                                        fontSize: 22, color: primaryColor),
                                  ),
                                ],
                              ),
                              model.currentPlan == null
                                  ? Flexible(
                                      child: Center(
                                        child: Text(
                                          'No active packages found.',
                                          style: mediumTextFont,
                                        ),
                                      ),
                                    )
                                  : ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [
                                        currentPlanTile(
                                            'Plan',
                                            model.currentPackage?.title ??
                                                'Blank for now'),
                                        mediumSpace,
                                        currentPlanTile(
                                            'Sessions',
                                            model.currentPlan.sessions
                                                .toString()),
                                        mediumSpace,
                                        currentPlanTile(
                                            'Sessions Left',
                                            (model.currentPlan.sessions -
                                                    model.currentPlan
                                                        .sessionsCompleted)
                                                .toString()),
                                        mediumSpace,
                                        currentPlanTile(
                                            'Expiry Date',
                                            model.currentPlan.expiryDate
                                                .split(' ')
                                                .first)
                                      ],
                                    ),
                              model.currentPlan == null
                                  ? smallSpace
                                  : Expanded(
                                      child: Container(
                                      alignment: Alignment.bottomCenter,
                                      child: customTextButton(
                                          buttonText: 'Cancel plan',
                                          onTapCallback: model.cancelPlan),
                                    ))
                            ],
                          ),
                        ),
                        model.isCancelling
                            ? loadingIndicator(loadingText: 'Cancelling plan..')
                            : emptySpace
                      ],
                    ),
            ),
        viewModelBuilder: () => CurrentPlanViewModel(),
        onModelReady: (model) => model.initialise(myProfile, selectedTrainer));
  }
}

Widget currentPlanTile(String field, String value) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          field,
          style: mediumTextFont.copyWith(color: Colors.black54),
        ),
        Text(
          value,
          style: mediumTextFont,
        )
      ],
    ),
  );
}
