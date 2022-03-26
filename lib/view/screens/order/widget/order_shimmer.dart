import 'package:flutter/material.dart';
import 'package:emarket_user/provider/order_provider.dart';
import 'package:emarket_user/provider/theme_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OrderShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 1170,
        child: ListView.builder(
          itemCount: 10,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                boxShadow: [BoxShadow(
                  color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                  spreadRadius: 1, blurRadius: 5,
                )],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Shimmer(
                duration: Duration(seconds: 2),
                enabled: Provider.of<OrderProvider>(context).runningOrderList == null,
                child: Column(children: [

                  Row(children: [
                    Container(
                      height: 70, width: 80,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(height: 15, width: 150, color: Colors.grey[300]),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Container(height: 15, width: 100, color: Colors.grey[300]),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Container(height: 15, width: 130, color: Colors.grey[300]),
                    ]),
                  ]),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                  Row(children: [
                    Expanded(child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: ColorResources.DISABLE_COLOR),
                      ),
                    )),
                    SizedBox(width: 20),
                    Expanded(child: Container(
                      height: 50,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    )),
                  ]),

                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
