import 'package:emarket_user/utill/routes.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_button.dart';

class NotLoggedInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          Image.asset(
            Images.guest_login,
            width: MediaQuery.of(context).size.height*0.25,
            height: MediaQuery.of(context).size.height*0.25,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.03),

          Text(
            getTranslated('guest_mode', context),
            style: rubikBold.copyWith(fontSize: MediaQuery.of(context).size.height*0.023),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.02),

          Text(
            getTranslated('now_you_are_in_guest_mode', context),
            style: rubikRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.03),

          SizedBox(
            height: 40,
            width: 100,
            child: CustomButton(btnTxt: getTranslated('login', context), onTap: () {
              Navigator.pushNamed(context, Routes.getLoginRoute());
            }),
          ),

        ]),
      ),
    );
  }
}
