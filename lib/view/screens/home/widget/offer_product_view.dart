import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/screens/product/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/provider/theme_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/rating_bar.dart';
import 'package:emarket_user/view/base/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OfferProductView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, offerProduct, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TitleWidget(
                  title: getTranslated('offer_product', context),
                  onTap: () {
                    Navigator.pushNamed(context, Routes.getOfferRoute());
                  }),
            ),
            SizedBox(
              height: 195,
              child: offerProduct.offerProductList != null
                  ? offerProduct.offerProductList.length > 0
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                          itemCount: offerProduct.offerProductList.length > 5 ? 5 : offerProduct.offerProductList.length,
                          itemBuilder: (context, index) {
                            double _startingPrice;
                            double _endingPrice;
                            if (offerProduct.offerProductList[index].variations.length != 0) {
                              List<double> _priceList = [];
                              offerProduct.offerProductList[index].variations.forEach((variation) => _priceList.add(variation.price));
                              _priceList.sort((a, b) => a.compareTo(b));
                              _startingPrice = _priceList[0];
                              if (_priceList[0] < _priceList[_priceList.length - 1]) {
                                _endingPrice = _priceList[_priceList.length - 1];
                              }
                            } else {
                              _startingPrice = offerProduct.offerProductList[index].price;
                            }

                            double _discount = offerProduct.offerProductList[index].price -
                                PriceConverter.convertWithDiscount(
                                  context,
                                  offerProduct.offerProductList[index].price,
                                  offerProduct.offerProductList[index].discount,
                                  offerProduct.offerProductList[index].discountType,
                                );

                            return Padding(
                              padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(Routes.getProductDetailsRoute(offerProduct.offerProductList[index].id),
                                      arguments: ProductDetailsScreen(product: offerProduct.offerProductList[index]));
                                },
                                child: Container(
                                  height: 90,
                                  width: MediaQuery.of(context).size.width/3.3,
                                  decoration:
                                      BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(10), boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    )
                                  ]),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder,
                                        image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}'
                                            '/${offerProduct.offerProductList[index].image[0]}',
                                        height: 90,
                                        width: MediaQuery.of(context).size.width/3.3,
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
                                                offerProduct.offerProductList[index].name,
                                                style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              RatingBar(
                                                rating: offerProduct.offerProductList[index].rating.length > 0
                                                    ? double.parse(offerProduct.offerProductList[index].rating[0].average)
                                                    : 0.0,
                                                size: 12,
                                              ),
                                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      '${PriceConverter.convertPrice(context, _startingPrice, discount: offerProduct.offerProductList[index].discount, discountType: offerProduct.offerProductList[index].discountType, asFixed: 1)}'
                                                      '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: offerProduct.offerProductList[index].discount, discountType: offerProduct.offerProductList[index].discountType, asFixed: 1)}' : ''}',
                                                      style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                                    ),
                                                  ),
                                                  _discount > 0 ? SizedBox() : Icon(Icons.add, color: Theme.of(context).textTheme.bodyText1.color),
                                                ],
                                              ),
                                              _discount > 0
                                                  ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                                                    ])
                                                  : SizedBox(),
                                            ]),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(child: Text(getTranslated('no_offer_product_available', context)))
                  : OfferProductShimmer(),
            ),
          ],
        );
      },
    );
  }
}

class OfferProductShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 195,
          width: 120,
          margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          decoration: BoxDecoration(
            color: ColorResources.COLOR_WHITE,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.grey[300], blurRadius: 10, spreadRadius: 1),
            ],
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled: Provider.of<ProductProvider>(context).offerProductList == null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 110,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    color: Colors.grey[300],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(
                      Dimensions.PADDING_SIZE_SMALL,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 15,
                          width: 130,
                          color: Colors.grey[300],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: RatingBar(rating: 0.0, size: 12),
                        ),
                        SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Container(
                            height: 10,
                            width: 50,
                            color: Colors.grey[300],
                          ),
                          Icon(
                            Icons.add,
                            color: ColorResources.COLOR_BLACK,
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
