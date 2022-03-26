import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/profile_provider.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';
import 'package:emarket_user/view/base/not_logged_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:provider/provider.dart';

class ReferralCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)) : CustomAppBar(title: getTranslated('referral', context)),
      body: _isLoggedIn ? Consumer<ProfileProvider>(
        builder: (context, profile, child) {
//          return profile.userInfoModel != null ? profile.userInfoModel.refCode != null ? RefreshIndicator(
//            onRefresh: () async {
//              await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
//            },
//            backgroundColor: Theme.of(context).primaryColor,
            return Scrollbar(
              child: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_LARGE),
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: profile.userInfoModel.refCode));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('referral_code_copied', context)), backgroundColor: Colors.green));
                            },
                            child: Stack(children: [

                              Image.asset(Images.coupon_bg, height: 100, width: 1170, fit: BoxFit.fitWidth, color: Theme.of(context).primaryColor),

                              Container(
                                height: 100,
                                alignment: Alignment.center,
                                child: Row(children: [

                                  SizedBox(width: 50),
                                  Image.asset(Images.percentage, height: 50, width: 50),

                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
                                    child: Image.asset(Images.line, height: 100, width: 5),
                                  ),

                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                      SelectableText(
                                        profile.userInfoModel.refCode,
                                        style: rubikRegular.copyWith(color: ColorResources.COLOR_WHITE),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Text(
                                        'Share to friends',
                                        style: rubikMedium.copyWith(color: ColorResources.COLOR_WHITE, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                                      Text(
//                                        '${getTranslated('valid_until', context)} ${DateConverter.isoStringToLocalDateOnly(coupon.couponList[index].expireDate)}',
//                                        style: rubikRegular.copyWith(color: ColorResources.COLOR_WHITE, fontSize: Dimensions.FONT_SIZE_SMALL),
//                                      ),
                                    ]),
                                  ),

                                ]),
                              ),

                            ]),
                          ),
                        );
                      },
                    ),
                  ),
//                ),
              ),
            )
          );
        },
      ) : NotLoggedInScreen(),
    );
  }
}
