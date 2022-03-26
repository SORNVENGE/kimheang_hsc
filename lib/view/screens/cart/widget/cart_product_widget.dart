import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/coupon_provider.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/cart_model.dart';
import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/cart_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/provider/theme_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/rating_bar.dart';
import 'package:emarket_user/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class CartProductWidgetState extends StatefulWidget {
  final CartItems cartItems;
  final int cartIndex;

  CartProductWidgetState({@required this.cartItems, @required this.cartIndex});

  @override
  CartProductWidget createState() =>
      new CartProductWidget(cartItems: cartItems, cartIndex: cartIndex);
}

class CartProductWidget extends State<CartProductWidgetState> {
  final CartItems cartItems;
  final int cartIndex;
  String selectedProjectName = "";

  CartProductWidget({@required this.cartItems, @required this.cartIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final oldCheckboxTheme = theme.checkboxTheme;

    final newCheckBoxTheme = oldCheckboxTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    );
    return Column(
      children: [
        Text(cartItems.project),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: cartItems.items.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  ResponsiveHelper.isMobile(context)
                      ? showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (con) => CartBottomSheet(
                            cart: this.cartItems.items[index],
                            cartIndex: index,
                            product: this.cartItems.items[index].product,
                            callback: (CartModel cartModel) {
                              bool isExisted = false;
                              if (cartItems.items[index].variation.type != cartModel.variation.type) {
                                print("not the same variation");
                                for (var i = 0; i < cartItems.items.length; i++) {
                                  if (cartModel.variation.type == cartItems.items[i].variation.type) {
                                    print("same variation as the existing");
                                    isExisted = true;
                                    // add to existing cart
                                    if (cartItems.items[i].variation.stock >= (cartModel.quantity + cartItems.items[i].quantity)) {
                                      int updatedQuantity = cartModel.quantity + cartItems.items[i].quantity;
                                      Provider.of<CartProvider>(context, listen: false).addToCart(cartItems.items[i], context, cartModel.quantity);
                                      setState(() {
                                        print("cart qqq => $updatedQuantity");
                                        cartItems.items[i].quantity = updatedQuantity;
                                      });
                                      break;
                                    } else {
                                      // show out of stock
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                              'not enough stock',
                                            ),
                                            backgroundColor: Colors.red),
                                      );
                                      break;
                                    }
                                  }
                                }
                              }
                              if ((cartItems.items[index].variation.type == cartModel.variation.type) && (cartItems.items[index].quantity != cartModel.quantity) && !isExisted) {
                                print("new");
                                // just update cart quantity
                                // call to add api
                                int updatedQuantity = cartModel.quantity - cartItems.items[index].quantity;
                                Provider.of<CartProvider>(context, listen: false).addToCart(cartItems.items[index], context, updatedQuantity);
                                setState(() {
                                  cartItems.items[index].quantity = cartModel.quantity;
                                });
                              } else if ((cartItems.items[index].variation.type != cartModel.variation.type) && !isExisted) {
                                print("new update");
                                // cartItems.items[index] = cartModel;
                                setState(() {
                                  cartItems.items[index] = cartModel;
                                });
                                // update cart variation and quantity
                              }
                              if (isExisted) {
                                // remove cart
                                Provider.of<CartProvider>(context, listen: false).addToCart(cartItems.items[index], context, -(cartItems.items[index].quantity));
                                cartItems.items.remove(cartItems.items[index]);
                              }
                            },
                          ),
                        )
                      : showDialog(
                          context: context,
                          builder: (con) => Dialog(
                            child: SizedBox(
                              width: 500,
                              child: CartBottomSheet(
                                cart: this.cartItems.items[this.cartIndex],
                                cartIndex: this.cartIndex,
                                product: this
                                    .cartItems
                                    .items[this.cartIndex]
                                    .product,
                                callback: (CartModel cartModel) {
                                  cartItems.items[index] = cartModel;
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //       content: Text(
                                  //         getTranslated('added_to_cart', context),
                                  //       ),
                                  //       backgroundColor: Colors.green),
                                  // );
                                },
                              ),
                            ),
                          ),
                        );
                },
                child: Container(
                  margin:
                      EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Icon(Icons.delete,
                            color: ColorResources.COLOR_WHITE, size: 50),
                      ),
                      Dismissible(
                        key: UniqueKey(),
                        onDismissed: (DismissDirection direction) {
                          // make the current quantity to negative so we can remove it (WTF!!!!)
                          // cartItems.items[index].quantity = -(cartItems.items[index].quantity);
                          Provider.of<CartProvider>(context, listen: false)
                              .addToCart(cartItems.items[index], context,
                                  -(cartItems.items[index].quantity))
                              .then((value) {
                            // cartItems.project = "";
                          });
                          cartItems.items.remove(cartItems.items[index]);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                              horizontal: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[
                                    Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? 700
                                        : 300],
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder,
                                      image:
                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${cartItems.items[index].product.image[0]}',
                                      height: 70,
                                      width: 85,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dimensions.PADDING_SIZE_SMALL,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Theme(
                                          data: theme.copyWith(
                                              checkboxTheme: newCheckBoxTheme),
                                          child: CheckboxListTile(
                                              value: cartItems.project ==
                                                  selectedProjectName,
                                              checkColor: Theme.of(context)
                                                  .primaryColor,
                                              tileColor: Theme.of(context)
                                                  .primaryColorLight,
                                              activeColor: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedProjectName =
                                                      cartItems.project;
                                                });
                                              }),
                                        ),
                                        // ListView.builder(
                                        //   physics: NeverScrollableScrollPhysics(),
                                        //   shrinkWrap: true,
                                        //   itemCount: cart.items.length,
                                        //   itemBuilder: (context, index) {
                                        //     return CartProductWidgetState(cart: cart.cartItemsList[index], cartIndex: index);
                                        //   },
                                        // ),
                                        Text(
                                            cartItems.items[index].product.name,
                                            style: rubikMedium,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                        SizedBox(height: 5),
                                        Container(
                                          // decoration: BoxDecoration(
                                          // color: ColorResources.getBackgroundColor(context),
                                          // borderRadius: BorderRadius.circular(5),
                                          // ),
                                          child: Row(
                                            children: [
                                              Text(
                                                PriceConverter.convertPrice(
                                                    context,
                                                    cartItems.items[index]
                                                        .discountedPrice),
                                                style: rubikBold,
                                              ),
                                              Spacer(),
                                              InkWell(
                                                onTap: () {
                                                  print("Hello - clicj");
                                                  cartItems.items[index].quantity = cartItems.items[index].quantity - 1;
                                                  // if (cartItems.items[index].quantity == 0) {
                                                  //   cartItems.items.remove(cartItems.items[index]);
                                                  // }
                                                  Provider.of<CartProvider>(context, listen: false).addToCart(cartItems.items[index], context, -1).then((value) {
                                                    print("value response ---> $value");
                                                    if (value < 1) {
                                                      print("cart removed!");
                                                      cartItems.items.remove(cartItems.items[index]);
                                                    } else {
                                                      cartItems.items[index].quantity = value;
                                                    }
                                                  });
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .PADDING_SIZE_SMALL,
                                                      vertical: Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                  child: Icon(Icons.remove,
                                                      size: 20),
                                                ),
                                              ),
                                              Text(
                                                cartItems.items[index].quantity
                                                    .toString(),
                                                style: rubikMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_EXTRA_LARGE),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  cartItems.items[index].quantity = cartItems.items[index].quantity + 1;
                                                  if (cartItems.items[index].variation.stock >= cartItems.items[index].quantity) {
                                                    Provider.of<CartProvider>(context, listen: false).addToCart(cartItems.items[index], context, 1).then((value) {
                                                      cartItems.items[index].quantity = value;
                                                    });
                                                  } else {
                                                    // showCustomSnackBar('product out of stock', context);
                                                    cartItems.items[index].quantity = cartItems.items[index].quantity - 1;
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      content: Text('not enough stock'),
                                                      backgroundColor: Colors.red,
                                                    ));
                                                  }
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .PADDING_SIZE_SMALL,
                                                      vertical: Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                  child:
                                                      Icon(Icons.add, size: 20),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        cartItems.items[index].discountAmount >
                                                0
                                            ? Text(
                                                PriceConverter.convertPrice(
                                                    context,
                                                    cartItems.items[index]
                                                            .discountedPrice +
                                                        cartItems.items[index]
                                                            .discountAmount),
                                                style: rubikBold.copyWith(
                                                  color:
                                                      ColorResources.COLOR_GREY,
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              )
                                            : SizedBox(),
                                        Text(cartItems
                                            .items[index].variation.type),
                                      ],
                                    ),
                                  ),
                                  // cart.discountAmount > 0 ? Text(PriceConverter.convertPrice(context, cart.discountedPrice+cart.discountAmount), style: rubikBold.copyWith(
                                  //   color: ColorResources.COLOR_GREY,
                                  //   fontSize: Dimensions.FONT_SIZE_SMALL,
                                  //   decoration: TextDecoration.lineThrough,
                                  // )) : SizedBox(),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              !ResponsiveHelper.isMobile(context)
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.PADDING_SIZE_SMALL),
                                      child: IconButton(
                                        onPressed: () {
                                          // make the current quantity to negative so we can remove it (WTF!!!!)
                                          cartItems.items[index].quantity = -(cartItems.items[index].quantity);
                                          Provider.of<CartProvider>(context, listen: false).addToCart(cartItems.items[index], context, null);
                                        },
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          // ],),
                        ),
                      ),
                    ],
                  ),
                ));
          },
        ),
      ],
    );
  }
}
