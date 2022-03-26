import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/cart_provider.dart';
import 'package:emarket_user/provider/coupon_provider.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/order_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/custom_divider.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:emarket_user/view/base/no_data_screen.dart';
import 'package:emarket_user/view/screens/cart/widget/cart_product_widget.dart';
import 'package:emarket_user/view/screens/cart/widget/delivery_option_button.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  final bool fromDetails;
  CartScreen({this.fromDetails = false});

  @override
  Widget build(BuildContext context) {
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false).setOrderType('delivery', notify: false);
    final TextEditingController _couponController = TextEditingController();
    bool _isSelfPickupActive = Provider.of<SplashProvider>(context, listen: false).configModel.selfPickup == 1;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)) :  CustomAppBar(title: getTranslated('my_cart', context), isBackButtonExist: fromDetails),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          double deliveryCharge = 0;
          Provider.of<OrderProvider>(context).orderType == 'delivery'
              ? deliveryCharge = double.parse(Provider.of<SplashProvider>(context, listen: false).configModel.deliveryCharge) : deliveryCharge = 0;
          double _itemPrice = 0;
          double _discount = 0;
          double _tax = 0;
          // cart.cartList.forEach((cartModel) {
          //   _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
          //   _discount = _discount + (cartModel.discountAmount * cartModel.quantity);
          //   _tax = _tax + (cartModel.taxAmount * cartModel.quantity);
          // });
          double _subTotal = _itemPrice + _tax;
          double _total = _subTotal - _discount - Provider.of<CouponProvider>(context).discount + deliveryCharge;
          print("here is calling cart list ===> ${cart.projectNames}");
          return cart.cartList.length > 0 ? Column(
            children: [

              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL), physics: BouncingScrollPhysics(),
                    child: Center(
                      child: SizedBox(
                        width: 1170,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                          // Product
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cart.cartList.length,
                            itemBuilder: (context, index) {
                              return CartProductWidgetState(cartItems: cart.cartList[index], cartIndex: index);
                            },
                          ),

                          // Coupon
                          // Consumer<CouponProvider>(
                          //   builder: (context, coupon, child) {
                          //     return Row(children: [
                          //       Expanded(
                          //         child: TextField(
                          //           controller: _couponController,
                          //           style: rubikRegular,
                          //           decoration: InputDecoration(
                          //               hintText: getTranslated('enter_promo_code', context),
                          //               hintStyle: rubikRegular.copyWith(color: ColorResources.getHintColor(context)),
                          //               isDense: true,
                          //               filled: true,
                          //               enabled: coupon.discount == 0,
                          //               fillColor: Theme.of(context).accentColor,
                          //               border: OutlineInputBorder(
                          //                 borderRadius: BorderRadius.horizontal(
                          //                   left: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 10 : 0),
                          //                   right: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 0 : 10),
                          //                 ),
                          //                 borderSide: BorderSide.none,
                          //               ),
                          //           ),
                          //         ),
                          //       ),
                          //       InkWell(
                          //         onTap: () {
                          //           if(_couponController.text.isNotEmpty && !coupon.isLoading) {
                          //             if(coupon.discount < 1) {
                          //               coupon.applyCoupon(_couponController.text, _total).then((discount) {
                          //                 if (discount > 0) {
                          //                   showCustomSnackBar('You got ${Provider.of<SplashProvider>(context, listen: false)
                          //                       .configModel.currencySymbol}$discount discount', context);
                          //
                          //                 } else {
                          //                   showCustomSnackBar(getTranslated('invalid_code_or', context), context);
                          //
                          //                 }
                          //               });
                          //             } else {
                          //               coupon.removeCouponData(true);
                          //             }
                          //           } else if(_couponController.text.isEmpty) {
                          //             showCustomSnackBar(getTranslated('enter_a_Coupon_code', context), context);
                          //           }
                          //         },
                          //         child: Container(
                          //           height: 50, width: 100,
                          //           alignment: Alignment.center,
                          //           decoration: BoxDecoration(
                          //             color: Theme.of(context).primaryColor,
                          //             borderRadius: BorderRadius.horizontal(
                          //               left: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 0 : 10),
                          //               right: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 10 : 0),
                          //             ),
                          //           ),
                          //           child: coupon.discount <= 0 ? !coupon.isLoading ? Text(
                          //             getTranslated('apply', context),
                          //             style: rubikMedium.copyWith(color: Colors.white),
                          //           ) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)) : Icon(Icons.clear, color: Colors.white),
                          //         ),
                          //       ),
                          //     ]);
                          //   },
                          // ),
                          // SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          // // Order type
                          // _isSelfPickupActive ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          //   Text(getTranslated('delivery_option', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          //   DeliveryOptionButton(value: 'delivery', title: getTranslated('delivery', context)),
                          //   DeliveryOptionButton(value: 'self_pickup', title: getTranslated('self_pickup', context)),
                          //   SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          // ]) : SizedBox(),

                          // // Total
                          // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          //   Text(getTranslated('items_price', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          //   Text(PriceConverter.convertPrice(context, _itemPrice), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          // ]),
                          // SizedBox(height: 10),
                          //
                          // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          //   Text(getTranslated('tax', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          //   Text('(+) ${PriceConverter.convertPrice(context, _tax)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          // ]),
                          // SizedBox(height: 10),
                          //
                          // Padding(
                          //   padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                          //   child: CustomDivider(),
                          // ),
                          //
                          // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          //   Text(getTranslated('subtotal', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          //   Text(PriceConverter.convertPrice(context, _subTotal), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          // ]),
                          // SizedBox(height: 10),
                          //
                          // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          //   Text(getTranslated('discount', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          //   Text('(-) ${PriceConverter.convertPrice(context, _discount)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          // ]),
                          // SizedBox(height: 10),
                          //
                          // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          //   Text(getTranslated('coupon_discount', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          //   Text(
                          //     '(-) ${PriceConverter.convertPrice(context, Provider.of<CouponProvider>(context).discount)}',
                          //     style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                          //   ),
                          // ]),
                          // SizedBox(height: 10),
                          //
                          // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          //   Text(getTranslated('delivery_fee', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          //   Text('(+) ${PriceConverter.convertPrice(context, deliveryCharge)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          // ]),
                          //
                          // Padding(
                          //   padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                          //   child: CustomDivider(),
                          // ),
                          //
                          // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          //   Text(getTranslated('total_amount', context), style: rubikMedium.copyWith(
                          //     fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor,
                          //   )),
                          //   Text(
                          //     PriceConverter.convertPrice(context, _total),
                          //     style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
                          //   ),
                          // ]),

                        ]),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                width: 1170,
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: CustomButton(btnTxt: getTranslated('place_order', context), onTap: () {
                  if(_itemPrice < Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                      'Minimum order amount is ${PriceConverter.convertPrice(context, Provider.of<SplashProvider>(context, listen: false).configModel
                          .minimumOrderValue)}, you have ${PriceConverter.convertPrice(context, _itemPrice)} in your cart, please add more item.',
                    ), backgroundColor: Colors.red));
                  } else {
                    Navigator.pushNamed(context, Routes.getCheckoutRoute(_total, 'cart', Provider.of<OrderProvider>(context, listen: false).orderType));
                  }
                }),
              ),

            ],
          ) : NoDataScreen(isCart: true);
        },
      ),
    );
  }
}
