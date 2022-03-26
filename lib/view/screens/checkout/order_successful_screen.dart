import 'package:flutter/material.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';

class OrderSuccessfulScreen extends StatelessWidget {
  final String orderID;
  final int status;
  OrderSuccessfulScreen({@required this.orderID, @required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)):null,
      body: Center(
        child: Container(
          width: 1170,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: 100, width: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                status == 0 ? Icons.check_circle : status == 1 ? Icons.sms_failed : Icons.cancel,
                color: Theme.of(context).primaryColor, size: 80,
              ),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            Text(
              getTranslated(status == 0 ? 'order_placed_successfully' : status == 1 ? 'payment_failed' : 'payment_cancelled', context),
              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${getTranslated('order_id', context)}:', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Text(orderID, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
            ]),
            SizedBox(height: 30),

            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: CustomButton(btnTxt: getTranslated(status == 0 ? 'track_order' : 'back_home', context), onTap: () {
                if(status == 0) {
                  Navigator.pushReplacementNamed(context, Routes.getOrderTrackingRoute(int.parse(orderID)));
                }else {
                  Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                }
              }),
            ),
          ]),
        ),
      ),
    );
  }
}
