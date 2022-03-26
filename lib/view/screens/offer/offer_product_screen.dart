import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';
import 'package:emarket_user/view/screens/product/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/no_data_screen.dart';
import 'package:emarket_user/view/base/rating_bar.dart';
import 'package:provider/provider.dart';

class OfferProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).getOfferProductList(
      context, true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)) : CustomAppBar(title: getTranslated('offer_product', context)),
      body: Consumer<ProductProvider>(
        builder: (context, offerProduct, child) {
          return offerProduct.offerProductList != null ? offerProduct.offerProductList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await offerProduct.getOfferProductList(
                context, true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
              );
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: offerProduct.offerProductList.length,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio:  1/1.5,
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 4 : 3),
                      itemBuilder: (context, index) {

                        double _startingPrice;
                        double _endingPrice;
                        if(offerProduct.offerProductList[index].choiceOptions.length != 0) {
                          List<double> _priceList = [];
                          offerProduct.offerProductList[index].variations.forEach((variation) => _priceList.add(variation.price));
                          _priceList.sort((a, b) => a.compareTo(b));
                          _startingPrice = _priceList[0];
                          if(_priceList[0] < _priceList[_priceList.length-1]) {
                            _endingPrice = _priceList[_priceList.length-1];
                          }
                        }else {
                          _startingPrice = offerProduct.offerProductList[index].price;
                        }

                        double _discount = offerProduct.offerProductList[index].price - PriceConverter.convertWithDiscount(context,
                            offerProduct.offerProductList[index].price, offerProduct.offerProductList[index].discount, offerProduct.offerProductList[index].discountType);

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.getProductDetailsRoute(offerProduct.offerProductList[index].id),
                                arguments: ProductDetailsScreen(product: offerProduct.offerProductList[index]));

                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)]
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder,
                                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${offerProduct.offerProductList[index].image[0]}',
                                  height: 70, width: MediaQuery.of(context).size.width/3, fit: BoxFit.cover,
                                ),
                              ),

                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Text(
                                      offerProduct.offerProductList[index].name,
                                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                      maxLines: 2, overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                    RatingBar(
                                      rating: offerProduct.offerProductList[index].rating.length > 0 ? double.parse(offerProduct.offerProductList[index].rating[0].average) : 0.0,
                                      size: 12,
                                    ),
                                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${PriceConverter.convertPrice(context, _startingPrice, discount: offerProduct.offerProductList[index].discount,
                                              discountType: offerProduct.offerProductList[index].discountType, asFixed: 1)}''${_endingPrice!= null
                                              ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: offerProduct.offerProductList[index].discount,
                                              discountType: offerProduct.offerProductList[index].discountType, asFixed: 1)}' : ''}',
                                          style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                        ),
                                        _discount > 0 ? SizedBox() : Icon(Icons.add, color: Theme.of(context).textTheme.bodyText1.color),
                                      ],
                                    ),
                                    _discount > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text(
                                        '${PriceConverter.convertPrice(context, _startingPrice, asFixed: 1)}'
                                            '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, asFixed: 1)}' : ''}',
                                        style: rubikBold.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                          color: ColorResources.getGreyColor(context),
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Icon(Icons.add, color: Theme.of(context).textTheme.bodyText1.color),
                                    ]) : SizedBox(),
                                  ]),
                                ),
                              ),
                            ]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ) : NoDataScreen() : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}
