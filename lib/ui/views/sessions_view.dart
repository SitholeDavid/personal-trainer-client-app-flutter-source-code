import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:personal_trainer_client/core/models/session.dart';
import 'package:personal_trainer_client/core/utils.dart';
import 'package:personal_trainer_client/core/viewmodels/sessions_viewmodel.dart';
import 'package:personal_trainer_client/ui/constants/colors.dart';
import 'package:personal_trainer_client/ui/constants/text_sizes.dart';
import 'package:personal_trainer_client/ui/constants/ui_helpers.dart';
import 'package:personal_trainer_client/ui/shared/background_gradient.dart';
import 'package:personal_trainer_client/ui/widgets/loading_indicator.dart';
import 'package:stacked/stacked.dart';

class SessionsView extends StatelessWidget {
  final int trainerIndex;

  SessionsView({this.trainerIndex});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SessionsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: model.isBusy
            ? loadingIndicatorLight(loadingText: 'Fetching booking slots')
            : Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      topDashboard(
                          model.days, model.selectedDay, model.changeDay),
                      model.sessions.length == 0
                          ? Flexible(
                              child: Center(
                                child: Text(
                                  'Trainer is not working on this day',
                                  style: mediumTextFont.copyWith(
                                      color: Colors.black87, fontSize: 19),
                                ),
                              ),
                            )
                          : Flexible(
                              child: ListView(
                                children: model.sessions
                                    .map((session) => sessionTile(
                                        session,
                                        model.client.clientID,
                                        model.requestUpdateSession))
                                    .toList(),
                              ),
                            ),
                      mediumSpace
                    ],
                  ),
                  model.isUpdating
                      ? loadingIndicator(loadingText: 'Updating booking')
                      : emptySpace
                ],
              ),
      ),
      viewModelBuilder: () => SessionsViewModel(),
      onModelReady: (model) async =>
          await model.initialise('day', trainerIndex),
    );
  }
}

Widget topDashboard(
    List<DateTime> days, DateTime currentDay, Function onTapCallback) {
  return Container(
    height: 160,
    width: double.infinity,
    decoration: BoxDecoration(gradient: backgroundGradient),
    child: Column(
      children: [
        largeSpace,
        Text(
          getMonth(currentDay.month),
          style: mediumTextFont.copyWith(fontSize: 20, color: Colors.white),
        ),
        largeSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: days
              .map((day) =>
                  dateTile(day, currentDay.day == day.day, onTapCallback))
              .toList(),
        )
      ],
    ),
  );
}

Widget dateTile(DateTime date, bool currentDay, Function onTapCallback) {
  return GestureDetector(
    onTap: () => onTapCallback(date),
    child: Container(
      height: 60,
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            date.day.toString(),
            style: mediumTextFont.copyWith(color: Colors.white),
          ),
          smallSpace,
          Container(
            padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                border: currentDay
                    ? Border(bottom: BorderSide(color: Colors.white, width: 2))
                    : Border()),
            child: Text(getWeekday(date.weekday),
                style:
                    mediumTextFont.copyWith(color: Colors.white, fontSize: 13)),
          ),
        ],
      ),
    ),
  );
}

Widget sessionTile(Session session, String clientID, Function onTapCallback) {
  bool myBooking = session.clientID == clientID;

  bool isReserved = session.client != 'Available' && !myBooking;

  return GestureDetector(
    onTap: () => isReserved ? null : onTapCallback(session),
    child: Container(
      height: 60,
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 0),
      decoration: BoxDecoration(
          color: isReserved
              ? Colors.redAccent.withOpacity(0.7)
              : (myBooking ? Colors.greenAccent : primaryColorDark),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ]),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(width: 0.5, color: Colors.black45))),
            child: Text(
              '${DateTime.parse(session.startTime).hour.toString().padLeft(2, '0')} : ${DateTime.parse(session.startTime).minute.toString().padLeft(2, '0')}',
              style: mediumTextFont.copyWith(color: Colors.white),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                isReserved
                    ? 'Unavailable'
                    : (myBooking ? 'Booked' : session.client),
                style: mediumTextFont.copyWith(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
