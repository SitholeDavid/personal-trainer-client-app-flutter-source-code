import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:personal_trainer_client/core/viewmodels/forgot_password_viewmodel.dart';
import 'package:personal_trainer_client/ui/constants/colors.dart';
import 'package:personal_trainer_client/ui/constants/margins.dart';
import 'package:personal_trainer_client/ui/constants/text_sizes.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordView extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundColor,
              body: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: pageHorizontalMargin,
                    vertical: pageVerticalMargin),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      Text(
                        'Reset password',
                        style: largeTextFont,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Enter the email associated with your account and we\'ll send an email with instructions to reset your password.',
                        style: mediumTextFont,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Email address',
                        style: smallTextFont,
                      ),
                      Container(
                        child: TextFormField(
                          controller: _emailController,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp("[ ]"))
                          ],
                          validator: EmailValidator(
                              errorText: 'Enter a valid email address'),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7.5),
                            hintText: 'personal@trainer.com',
                          ),
                        ),
                      ),
                      Expanded(child: Text('')),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: TextButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    model.sendResetPasswordEmail(
                                        _emailController.text);
                                  }
                                },
                                child: Text(
                                  'Send reset email',
                                  style: mediumTextFont.copyWith(
                                      color: Colors.white),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => primaryColorDark),
                                    padding: MaterialStateProperty.resolveWith(
                                        (states) => EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 10)),
                                    shape: MaterialStateProperty.resolveWith(
                                        (states) => RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: BorderSide(
                                                color: primaryColorDark)))),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => ForgotPasswordViewModel());
  }
}
