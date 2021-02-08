import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:personal_trainer_client/ui/constants/colors.dart';
import 'package:personal_trainer_client/ui/constants/text_sizes.dart';
import 'package:personal_trainer_client/ui/constants/ui_helpers.dart';

Widget loadingIndicator({@required String loadingText}) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.black12.withOpacity(0.8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          child: LoadingIndicator(
              indicatorType: Indicator.circleStrokeSpin,
              color: primaryColorLight),
        ),
        mediumSpace,
        mediumSpace,
        Text(
          loadingText,
          style: mediumTextFont.copyWith(color: Colors.white),
        )
      ],
    ),
  );
}

Widget loadingIndicatorLight({@required String loadingText}) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.white38.withOpacity(0.8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          child: LoadingIndicator(
              indicatorType: Indicator.circleStrokeSpin,
              color: primaryColorLight),
        ),
        mediumSpace,
        mediumSpace,
        Text(
          loadingText,
          style: mediumTextFont.copyWith(color: primaryColor),
        )
      ],
    ),
  );
}
