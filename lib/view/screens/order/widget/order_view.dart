import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/cart_model.dart';
import 'package:emarket_user/data/model/response/order_details_model.dart';
import 'package:emarket_user/data/model/response/order_model.dart';
import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/order_provider.dart';
import 'package:emarket_user/provider/theme_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/no_data_screen.dart';
import 'package:emarket_user/view/screens/checkout/checkout_screen.dart';
import 'package:emarket_user/view/screens/order/order_details_screen.dart';
import 'package:emarket_user/view/screens/order/widget/order_shimmer.dart';
import 'package:provider/provider.dart';

class OrderView extends StatelessWidget {
  final bool isRunning;
  OrderView({@required this.isRunning});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OrderProvider>(
        builder: (context, order, index) {
          List<OrderModel> orderList;
          if(order.runningOrderList != null) {
            orderList = isRunning ? order.runningOrderList.reversed.toList() : order.historyOrderList.reversed.toList();
          }

          return orderList != null ? orderList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: ListView.builder(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      itemCount: orderList.length,
                      physics: NeverScrollableScrollPhysics(),
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
                          child: Column(children: [

                            Row(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  Images.placeholder,
                                  height: 70, width: 80, fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(children: [
                                    Text('${getTranslated('order_id', context)}:', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    Text(orderList[index].id.toString(), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    Expanded(child: orderList[index].orderType == 'self_pickup' ? Text(
                                      '(${getTranslated('self_pickup', context)})',
                                      style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                                    ) : SizedBox()),
                                  ]),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(
                                    '${orderList[index].detailsCount} ${getTranslated( orderList[index].detailsCount > 1 ? 'items' : 'item', context)}',
                                    style: rubikRegular.copyWith(color: ColorResources.COLOR_GREY),
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Row(children: [
                                    Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 15),
                                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    Text(
                                      getTranslated(orderList[index].orderStatus, context),
                                      style: rubikRegular.copyWith(color: Theme.of(context).primaryColor),
                                    ),
                                  ]),
                                ]),
                              ),
                            ]),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            SizedBox(
                              height: 50,
                              child: Row(children: [
                                Expanded(child: TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color: ColorResources.DISABLE_COLOR)),
                                    minimumSize: Size(1, 50),
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.getOrderDetailsRoute(orderList[index].id),
                                      arguments: OrderDetailsScreen(orderModel: orderList[index], orderId: orderList[index].id),
                                    );
                                  },
                                  child: Text(getTranslated('details', context), style: Theme.of(context).textTheme.headline3.copyWith(
                                    color: ColorResources.DISABLE_COLOR,
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                  )),
                                )),
                                SizedBox(width: 20),
                                Expanded(child: CustomButton(
                                  btnTxt: getTranslated(isRunning ? 'track_order' : 'reorder', context),
                                  onTap: () async {
                                    if(isRunning) {
                                      Navigator.pushNamed(context, Routes.getOrderTrackingRoute(orderList[index].id));
                                    }else {
                                      List<OrderDetailsModel> orderDetails = await order.getOrderDetails(
                                        orderList[index].id.toString(), context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                                      );
                                      List<CartModel> _cartList = [];
                                      List<bool> _availableList = [];
                                      orderDetails.forEach((orderDetail) {
                                        _cartList.add(CartModel(
                                            orderDetail.price, PriceConverter.convertWithDiscount(context, orderDetail.price, orderDetail.discountOnProduct, 'amount'),
                                            orderDetail.variation.first, orderDetail.discountOnProduct, orderDetail.quantity,
                                            orderDetail.taxAmount, orderDetail.productDetails.totalStock, orderDetail.productDetails
                                        ));
                                      });
                                      if(_availableList.contains(false)) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(getTranslated('one_or_more_product_unavailable', context)),
                                          backgroundColor: Colors.red,
                                        ));
                                      }else {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.getCheckoutRoute(orderList[index].orderAmount, 'reorder', orderList[index].orderType),
                                          arguments: CheckoutScreen(
                                            cartList: _cartList,
                                            fromCart: false,
                                            amount: orderList[index].orderAmount,
                                            orderType: orderList[index].orderType,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                )),
                              ]),
                            ),

                          ]),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ) : NoDataScreen(isOrder: true) : OrderShimmer();
        },
      ),
    );
  }
}
