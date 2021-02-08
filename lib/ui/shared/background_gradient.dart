import 'package:flutter/material.dart';
import 'package:personal_trainer_client/ui/constants/colors.dart';

var backgroundGradient = LinearGradient(
    colors: [primaryColorDark, primaryColor],
    begin: FractionalOffset(0.0, 0.0),
    end: FractionalOffset(1.0, 1.0),
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp);
