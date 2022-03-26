import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/provider/theme_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/rating_bar.dart';
import 'package:emarket_user/view/screens/product/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInfoComponent extends StatelessWidget {
  final Product _product;

  ProductInfoComponent(this._product);

  @override
  Widget build(BuildContext context) {
    double _startingPrice;
    double _endingPrice;
    if (_product.variations.length != 0) {
      List<double> _priceList = [];
      _product.variations.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if (_priceList[0] < _priceList[_priceList.length - 1]) {
        _endingPrice = _priceList[_priceList.length - 1];
      }
    } else {
      _startingPrice = _product.price;
    }

    double _discount = _product.price -
        PriceConverter.convertWithDiscount(
          context,
          _product.price,
          _product.discount,
          _product.discountType,
        );
    return Padding(
      padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_EXTRA_SMALL, bottom: 5),
      // padding: EdgeInsets.only(bottom: 5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(Routes.getProductDetailsRoute(_product.id), arguments: ProductDetailsScreen(product: _product));
        },
        child: Container(
          // Original
          // height: 10000,
          width: 170,
          height: 270,
          // width: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            // color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                blurRadius: 1,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholder,
                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}'
                      '/${_product.image[0]}',
                  height: 70,
                  width: 170,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _product.name,
                        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      RatingBar(
                        rating: _product.rating.length > 0 ? double.parse(_product.rating[0].average) : 0.0,
                        size: 12,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '${PriceConverter.convertPrice(context, _startingPrice, discount: _product.discount, discountType: _product.discountType, asFixed: 1)}'
                              '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: _product.discount, discountType: _product.discountType, asFixed: 1)}' : ''}',
                              style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                            ),
                          ),
                          _discount > 0 ? SizedBox() : Icon(Icons.add, color: Theme.of(context).textTheme.bodyText1.color),
                        ],
                      ),
                      _discount > 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${PriceConverter.convertPrice(context, _startingPrice, asFixed: 1)}'
                                    '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, asFixed: 1)}' : ''}',
                                    style: rubikBold.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                      color: ColorResources.COLOR_GREY,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                                Icon(Icons.add, color: Theme.of(context).textTheme.bodyText1.color),
                              ],
                            )
                          : SizedBox(
                              // height: 10,
                              ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
