import 'package:flutter/material.dart';
import 'package:personal_trainer_client/ui/constants/colors.dart';
import 'package:personal_trainer_client/ui/constants/text_sizes.dart';
import 'package:personal_trainer_client/ui/constants/ui_helpers.dart';

Widget displayInputField(String title, dynamic value, Function onTapCallback) {
  return GestureDetector(
    onTap: () async => await onTapCallback(),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                  bottom: BorderSide(color: Colors.black12, width: 1.0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    smallTextFont.copyWith(color: Colors.black54, fontSize: 14),
              ),
              smallSpace,
              Text(
                value.toString(),
                style: mediumTextFont.copyWith(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        largeSpace
      ],
    ),
  );
}
