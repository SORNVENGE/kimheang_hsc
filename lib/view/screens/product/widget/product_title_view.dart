import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/provider/wishlist_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:emarket_user/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductTitleView extends StatelessWidget {
  final Product productModel;
  ProductTitleView({@required this.productModel});

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    double _startingPrice;
    double _endingPrice;
    if(productModel.variations.length != 0) {
      List<double> _priceList = [];
      productModel.variations.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if(_priceList[0] < _priceList[_priceList.length-1]) {
        _endingPrice = _priceList[_priceList.length-1];
      }
    }else {
      _startingPrice = productModel.price;
    }

    return Container(
      color: Theme.of(context).accentColor,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: Consumer<ProductProvider>(
        builder: (context, product, child) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(children: [
              Expanded(child: Text(
                productModel.name ?? '',
                style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              )),

              Consumer<WishListProvider>(
                  builder: (context, wishList, child) {
                    return Row(
                      children: [
                        Text(
                          wishList.localWishes.contains(productModel.id) ? (productModel.wishlistCount+1).toString() : wishList.localRemovedWishes
                              .contains(productModel.id) ? (productModel.wishlistCount-1).toString() : productModel.wishlistCount.toString(),
                          style: rubikMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                        ),
                        SizedBox(width: 5),

                        InkWell(
                          onTap: () {
                            if(_isLoggedIn){
                              if(wishList.wishIdList.contains(productModel.id)) {
                                wishList.removeFromWishList(productModel, (message) {
                                  showCustomSnackBar(message, context, isError: false);
                                });
                              }else {
                                wishList.addToWishList(productModel, (message) {
                                  showCustomSnackBar(message, context, isError: false);
                                });
                              }
                            }else showCustomSnackBar(getTranslated('not_logged_in', context), context);
                          },
                          child: Icon(
                            wishList.wishIdList.contains(productModel.id) ? Icons.favorite : Icons.favorite_border, size: 25,
                            color: wishList.wishIdList.contains(productModel.id) ? Theme.of(context).primaryColor : ColorResources.getGreyColor(context),
                          ),
                        ),
                      ],
                    );
                  }
              ),
            ]),
            SizedBox(height: 5),

            Row(children: [
              Flexible(
                child: Text(
                  '${PriceConverter.convertPrice(context, _startingPrice, discount: productModel.discount, discountType: productModel.discountType)}'
                      '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: productModel.discount, discountType: productModel.discountType)}' : ''}',
                  style: rubikMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
              ),
              SizedBox(width: 10),

              productModel.discount > 0 ? Flexible(
                child: Text(
                  '${PriceConverter.convertPrice(context, _startingPrice)}'
                      '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                  style: rubikRegular.copyWith(color: Theme.of(context).hintColor, decoration: TextDecoration.lineThrough),
                ),
              ) : SizedBox(),
            ]),
            SizedBox(height: 5),

            Row(children: [

              Text(productModel.rating != null ? productModel.rating.length > 0 ? double.parse(productModel.rating[0].average).toStringAsFixed(1) : '0.0' : '0.0', style: rubikRegular.copyWith(
                color: Theme.of(context).hintColor,
                fontSize: Dimensions.FONT_SIZE_LARGE,
              )),
              SizedBox(width: 5),

              RatingBar(rating: productModel.rating != null ? productModel.rating.length > 0 ? double.parse(productModel.rating[0].average) : 0.0 : 0.0),

            ]),

          ]);
        },
      ),
    );
  }
}
