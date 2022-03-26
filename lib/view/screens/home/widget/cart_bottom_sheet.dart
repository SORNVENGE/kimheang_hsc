import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/cart_model.dart';
import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/cart_provider.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/provider/wishlist_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/rating_bar.dart';
import 'package:provider/provider.dart';

class CartBottomSheet extends StatelessWidget {
  final Product product;
  final bool fromOfferProduct;
  final Function callback;
  final CartModel cart;
  final int cartIndex;

  CartBottomSheet({@required this.product, this.fromOfferProduct = false, this.callback, this.cart, this.cartIndex});

  @override
  Widget build(BuildContext context) {
    bool fromCart = cart != null;
    Provider.of<ProductProvider>(context, listen: false).initData(product, cart);
    Variation _variation = Variation();

    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .accentColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          double _startingPrice;
          double _endingPrice;
          if (product.variations.length != 0) {
            List<double> _priceList = [];
            product.variations.forEach((variation) => _priceList.add(variation.price));
            _priceList.sort((a, b) => a.compareTo(b));
            _startingPrice = _priceList[0];
            if (_priceList[0] < _priceList[_priceList.length - 1]) {
              _endingPrice = _priceList[_priceList.length - 1];
            }
          } else {
            _startingPrice = product.price;
          }

          List<String> _variationList = [];
          for (int index = 0; index < product.choiceOptions.length; index++) {
            _variationList.add(product.choiceOptions[index].options[productProvider.variationIndex[index]].replaceAll(' ', ''));
          }
          String variationType = '';
          bool isFirst = true;
          _variationList.forEach((variation) {
            if (isFirst) {
              variationType = '$variationType$variation';
              isFirst = false;
            } else {
              variationType = '$variationType-$variation';
            }
          });

          double price = product.price;
          int _stock = product.totalStock;
          for (Variation variation in product.variations) {
            if (variation.type == variationType) {
              price = variation.price;
              _variation = variation;
              _stock = variation.stock;
              break;
            }
          }
          double priceWithDiscount = PriceConverter.convertWithDiscount(context, price, product.discount, product.discountType);
          double priceWithQuantity = priceWithDiscount * productProvider.quantity;

          CartModel _cartModel = CartModel(
            price,
            priceWithDiscount,
            _variation,
            (price - PriceConverter.convertWithDiscount(context, price, product.discount, product.discountType)),
            productProvider.quantity,
            price - PriceConverter.convertWithDiscount(context, price, product.tax, product.taxType),
            _stock,
            product,
          );
          bool isExistInCart = Provider.of<CartProvider>(context, listen: false).isExistInCart(_cartModel, fromCart, cartIndex);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Product
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.placeholder,
                        image: '${Provider
                            .of<SplashProvider>(context, listen: false)
                            .baseUrls
                            .productImageUrl}/${product.image[0]}',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                          ),
                          RatingBar(rating: product.rating.length > 0 ? double.parse(product.rating[0].average) : 0.0, size: 15),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${PriceConverter.convertPrice(
                                    context, _startingPrice, discount: product.discount, discountType: product.discountType)}'
                                    '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(
                                    context, _endingPrice, discount: product.discount, discountType: product.discountType)}' : ''}',
                                style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                              ),
                              price == priceWithDiscount
                                  ? Consumer<WishListProvider>(
                                builder: (context, wishList, child) {
                                  return InkWell(
                                    onTap: () {
                                      wishList.wishIdList.contains(product.id)
                                          ? wishList.removeFromWishList(product, (message) {})
                                          : wishList.addToWishList(product, (message) {});
                                    },
                                    child: Icon(
                                      wishList.wishIdList.contains(product.id) ? Icons.favorite : Icons.favorite_border,
                                      color:
                                      wishList.wishIdList.contains(product.id) ? Theme
                                          .of(context)
                                          .primaryColor : ColorResources.COLOR_GREY,
                                    ),
                                  );
                                },
                              )
                                  : SizedBox(),
                            ],
                          ),
                          price > priceWithDiscount
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${PriceConverter.convertPrice(context, _startingPrice)}'
                                    '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                                style: rubikMedium.copyWith(color: ColorResources.COLOR_GREY, decoration: TextDecoration.lineThrough),
                              ),
                              Consumer<WishListProvider>(
                                builder: (context, wishList, child) {
                                  return InkWell(
                                    onTap: () {
                                      wishList.wishIdList.contains(product.id)
                                          ? wishList.removeFromWishList(product, (message) {})
                                          : wishList.addToWishList(product, (message) {});
                                    },
                                    child: Icon(
                                      wishList.wishIdList.contains(product.id) ? Icons.favorite : Icons.favorite_border,
                                      color:
                                      wishList.wishIdList.contains(product.id) ? Theme
                                          .of(context)
                                          .primaryColor : ColorResources.COLOR_GREY,
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                // Quantity
                Row(
                  children: [
                    Text(
                      getTranslated('quantity', context),
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: ColorResources.getBackgroundColor(context),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (productProvider.quantity > 1) {
                                productProvider.setQuantity(false, _stock, context);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: Icon(Icons.remove, size: 20),
                            ),
                          ),
                          Text(
                            productProvider.quantity.toString(),
                            style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                          ),
                          InkWell(
                            onTap: () => productProvider.setQuantity(true, _stock, context),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              child: Icon(Icons.add, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                // Variation
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: product.choiceOptions.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.choiceOptions[index].title, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 10,
                            childAspectRatio: (1 / 0.25),
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: product.choiceOptions[index].options.length,
                          itemBuilder: (context, i) {
                            return InkWell(
                              onTap: () {
                                productProvider.setCartVariationIndex(index, i);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                decoration: BoxDecoration(
                                  color:
                                  productProvider.variationIndex[index] != i ? ColorResources.BACKGROUND_COLOR : Theme
                                      .of(context)
                                      .primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                  productProvider.variationIndex[index] != i ? Border.all(color: ColorResources.BORDER_COLOR, width: 2) : null,
                                ),
                                child: Text(
                                  product.choiceOptions[index].options[i].trim(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: rubikRegular.copyWith(
                                    color: productProvider.variationIndex[index] != i ? ColorResources.COLOR_BLACK : ColorResources.COLOR_WHITE,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: index != product.choiceOptions.length - 1 ? Dimensions.PADDING_SIZE_LARGE : 0),
                      ],
                    );
                  },
                ),
                product.choiceOptions.length > 0 ? SizedBox(height: Dimensions.PADDING_SIZE_LARGE) : SizedBox(),

                fromOfferProduct
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getTranslated('description', context),
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(product.description ?? '', style: rubikRegular),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  ],
                )
                    : SizedBox(),

                Row(
                  children: [
                    Text(
                      '${getTranslated('total_amount', context)}:',
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      PriceConverter.convertPrice(context, priceWithQuantity),
                      style: rubikBold.copyWith(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                CustomButton(
                  btnTxt: getButtonText( isExistInCart: isExistInCart, stock: _stock, fromCart: fromCart, variationIndexes: productProvider.variationIndex, context: context ),
                  backgroundColor: Theme
                      .of(context)
                      .primaryColor,
                  onTap: onTap(isExistInCart, _stock, context, _cartModel),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ORIGIN CODE
  // return getTranslated(
  // isExistInCart
  // ? 'already_added_in_cart'
  //     : _stock <= 0
  // ? 'out_of_stock'
  //     : fromCart
  // ? 'update_in_cart'
  //     : 'add_to_cart',
  // context);
  String getButtonText({bool isExistInCart, int stock, bool fromCart, List<int> variationIndexes, BuildContext context}) {
    String text;
    // TODO: Add one more condition for updating existing option
    if (isExistInCart) {
      text = 'already_added_in_cart';
      // text = 'update_in_cart';
    } else if (stock <= 0) {
      text = 'out_of_stock';
    } else {
      text = 'apply_change';
    }
    return getTranslated(text, context);
  }

  Function onTap(bool isExistInCart, int _stock, BuildContext context, CartModel _cartModel) {
    _cartModel.projectName = this.cart.projectName;
    if (!isExistInCart && _stock > 0)
      return () {
        if (!isExistInCart && _stock > 0) {
          Navigator.pop(context);
          // Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel, context, null);
          callback(_cartModel);
        }
      };
    else {
      return null;
    }
  }
}
