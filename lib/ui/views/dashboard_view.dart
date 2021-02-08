import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:personal_trainer_client/core/viewmodels/dashboard_viewmodel.dart';
import 'package:personal_trainer_client/ui/constants/colors.dart';
import 'package:personal_trainer_client/ui/constants/text_sizes.dart';
import 'package:personal_trainer_client/ui/constants/ui_helpers.dart';
import 'package:personal_trainer_client/ui/shared/background_gradient.dart';
import 'package:personal_trainer_client/ui/widgets/loading_indicator.dart';
import 'package:stacked/stacked.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
            backgroundColor: backgroundColor,
            body: model.isBusy
                ? loadingIndicatorLight(loadingText: 'loading dashboard..')
                : Container(
                    child: Column(
                      children: [
                        mediumSpace,
                        Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            height: 180,
                            decoration: BoxDecoration(
                              gradient: backgroundGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(3.0,
                                      4.0), // shadow direction: bottom right
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 0, top: 15, bottom: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: CircularPercentIndicator(
                                    backgroundColor: Colors.white10,
                                    progressColor: Colors.white,
                                    radius: 130,
                                    lineWidth: 7.0,
                                    percent: model.percentageSessionsCompleted,
                                    center: Text(
                                      '${model.sessionsCompleted} sessions completed',
                                      style: mediumTextFont.copyWith(
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      largeSpace,
                                      mediumSpace,
                                      Text(
                                        '${model.sessionsLeft} sessions left',
                                        style: mediumTextFont.copyWith(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      smallSpace,
                                      Text(
                                        'next session: ${model.nextBooking}',
                                        style: mediumTextFont.copyWith(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      smallSpace,
                                      Text(
                                        'last session: ${model.prevBooking}',
                                        style: mediumTextFont.copyWith(
                                            color: Colors.white, fontSize: 14),
                                      )
                                    ],
                                  ))
                                ],
                              ),
                            )),
                        mediumSpace,
                        Flexible(
                          child: GridView.count(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                            childAspectRatio: 115 / 100,
                            crossAxisCount: 2,
                            children: [
                              navigationOption('Book session', Icons.schedule,
                                  model.navigateToSessions),
                              navigationOption('Purchase package',
                                  Icons.credit_card, model.navigateToPurchases),
                              navigationOption('My profile', Icons.person,
                                  model.navigateToClientView),
                              navigationOption(
                                  'Current plan',
                                  FontAwesome5Solid.running,
                                  model.navigateToCurrentPlan)
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
        onModelReady: (model) => model.initialise(),
        viewModelBuilder: () => DashboardViewModel());
  }
}

Widget navigationOption(String title, IconData icon, Function onTapCallback) {
  return Container(
    margin: EdgeInsets.only(top: 0, bottom: 15, left: 10, right: 10),
    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
    decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: Offset(3.0, 4.0), // shadow direction: bottom right
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: primaryColor, width: 1)),
    width: 80,
    child: InkWell(
      onTap: onTapCallback,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: Icon(
                icon,
                color: Colors.white,
                size: 70,
              ),
            ),
            mediumSpace,
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: mediumTextFont.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
