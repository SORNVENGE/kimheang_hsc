import 'package:flutter/material.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)) : null,
      body: Scrollbar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: SizedBox(
              width: 1170,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(30),
                    child: ResponsiveHelper.isWeb() ? Consumer<SplashProvider>(
                      builder:(context, splash, child) => FadeInImage.assetNetwork(
                        placeholder: Images.placeholder,
                        image: splash.baseUrls != null ? '${splash.baseUrls.ecommerceImageUrl}/${splash.configModel.ecommerceLogo}' : '',
                        height: 200,
                      ),
                    ) : Image.asset(Images.logo, height: 200),
                  ),
                  SizedBox(height: 30),
                  Text(
                    getTranslated('welcome', context),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3.copyWith(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 32),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    child: Text(
                      getTranslated('welcome_to_efood', context),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getGreyColor(context)),
                    ),
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    child: CustomButton(
                      btnTxt: getTranslated('login', context),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, Routes.getLoginRoute());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: Dimensions.PADDING_SIZE_DEFAULT,
                        right: Dimensions.PADDING_SIZE_DEFAULT,
                        bottom: Dimensions.PADDING_SIZE_DEFAULT,
                        top: 12),
                    child: CustomButton(
                      btnTxt: getTranslated('signup', context),
                      onTap: () {

                        Navigator.pushNamed(context, Routes.getSignUpRoute());
                      },
                      backgroundColor: Colors.black,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(1, 40),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Routes.getMainRoute());
                    },
                    child: RichText(text: TextSpan(children: [
                      TextSpan(text: '${getTranslated('login_as_a', context)} ', style: rubikRegular.copyWith(color: ColorResources.getGreyColor(context))),
                      TextSpan(text: getTranslated('guest', context), style: rubikMedium.copyWith(color: Theme.of(context).textTheme.bodyText1.color)),
                    ])),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
