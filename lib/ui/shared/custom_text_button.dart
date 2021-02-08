import 'package:flutter/material.dart';
import 'package:personal_trainer_client/ui/constants/colors.dart';
import 'package:personal_trainer_client/ui/constants/text_sizes.dart';

Widget customTextButton({String buttonText, Function onTapCallback}) {
  return Row(children: [
    Expanded(
        child: TextButton(
      onPressed: onTapCallback,
      child: Text(
        buttonText,
        style: mediumTextFont.copyWith(color: Colors.white),
      ),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => primaryColor),
          padding: MaterialStateProperty.resolveWith(
              (states) => EdgeInsets.symmetric(vertical: 12, horizontal: 10)),
          shape: MaterialStateProperty.resolveWith((states) =>
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: primaryColorDark)))),
    ))
  ]);
}
