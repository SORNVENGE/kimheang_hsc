import 'package:flutter/material.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)): CustomAppBar(title: getTranslated('help_and_support', context)),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          physics: BouncingScrollPhysics(),
          child: Center(
            child: SizedBox(
              width: 1170,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Image.asset(Images.support,height: 300,width: 300,),
                SizedBox(height: 20),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 25),
                  Text(getTranslated('restaurant_address', context), style: rubikMedium),
                ]),
                SizedBox(height: 10),

                Text(
                  Provider.of<SplashProvider>(context, listen: false).configModel.ecommerceAddress,
                  style: rubikRegular, textAlign: TextAlign.center,
                ),
                Divider(thickness: 2),
                SizedBox(height: 50),

                Row(children: [
                  Expanded(child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                      minimumSize: Size(1, 50),
                    ),
                    onPressed: () {
                      launch('tel:${Provider.of<SplashProvider>(context, listen: false).configModel.ecommercePhone}');
                    },
                    child: Text(getTranslated('call_now', context), style: Theme.of(context).textTheme.headline3.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                    )),
                  )),
                  SizedBox(width: 10),
                  Expanded(child: SizedBox(
                    height: 50,
                    child: CustomButton(
                      btnTxt: getTranslated('send_a_message', context),
                      onTap: () async {
                        Navigator.pushNamed(context, Routes.getChatRoute());
                      },
                    ),
                  )),
                ]),

              ]),
            ),
          ),
        ),
      ),
    );
  }
}
