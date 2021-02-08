import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:personal_trainer_client/core/models/package.dart';
import 'package:personal_trainer_client/core/viewmodels/purchases_viewmodel.dart';
import 'package:personal_trainer_client/ui/constants/colors.dart';
import 'package:personal_trainer_client/ui/constants/margins.dart';
import 'package:personal_trainer_client/ui/constants/text_sizes.dart';
import 'package:personal_trainer_client/ui/constants/ui_helpers.dart';
import 'package:personal_trainer_client/ui/widgets/loading_indicator.dart';
import 'package:stacked/stacked.dart';

class PurchasesView extends StatelessWidget {
  final int trainerIndex;
  PurchasesView({this.trainerIndex});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PurchasesViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundColor.withOpacity(0.99),
              body: model.isBusy
                  ? loadingIndicatorLight(loadingText: 'Loading packages..')
                  : Container(
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
                                  onPressed: model.navigateToPrevView),
                              Text(
                                'Choose a package',
                                style: largeTextFont.copyWith(
                                    fontSize: 22, color: primaryColor),
                              ),
                            ],
                          ),
                          model.packages.isEmpty
                              ? Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'No packages found.',
                                      style:
                                          mediumTextFont.copyWith(fontSize: 18),
                                    ),
                                  ),
                                )
                              : Flexible(
                                  child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return packageTile(model.packages[index],
                                        model.makePurchase);
                                  },
                                  itemCount: model.packages.length,
                                ))
                        ],
                      ),
                    ),
            ),
        viewModelBuilder: () => PurchasesViewModel(),
        onModelReady: (model) => model.initialise(trainerIndex));
  }
}

Widget packageTile(Package package, Function onTapCallback) {
  return GestureDetector(
    onTap: () => onTapCallback(package),
    child: Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 2.0,
          spreadRadius: 0.0,
          offset: Offset(2.0, 2.0), // shadow direction: bottom right
        )
      ], color: backgroundColor, borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            package.title,
            style: mediumTextFont.copyWith(
                fontWeight: FontWeight.bold, fontSize: 19, color: primaryColor),
            textAlign: TextAlign.left,
          ),
          smallSpace,
          Text(
            '${package.noSessions} sessions',
            style: mediumTextFont.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 16),
            textAlign: TextAlign.left,
          ),
          smallSpace,
          Text(
            package.description,
            style: mediumTextFont.copyWith(color: Colors.black54, fontSize: 15),
            textAlign: TextAlign.left,
          )
        ],
      ),
    ),
  );
}
