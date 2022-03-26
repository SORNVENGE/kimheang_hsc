import 'package:carousel_slider/carousel_slider.dart';
import 'package:emarket_user/data/model/response/brand_model.dart';
import 'package:emarket_user/provider/brand_provider.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/screens/brand/brand_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

const kCarouselHeight = 40.0;
const kCarouselDesktopHeight = 80.0;
const kCarouselViewport = 0.3;

class BrandBannerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Consumer<BrandProvider>(
        builder: (context, brand, child) {
          return brand.brands != null && brand.brands.length > 0
              ? CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    height: kIsWeb ? kCarouselDesktopHeight : kCarouselHeight,
                    viewportFraction: kCarouselViewport,
                  ),
                  items: brand.brands.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return InkWell(
                          onTap: () => this.onPressed(context, i),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder,
                                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.brandImageUrl}/${i.image}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              : BrandBannerShimmer();
        },
      ),
    );
  }

  void onPressed(BuildContext context, Brand brand) {
    Provider.of<BrandProvider>(context, listen: false).selectBrand(brand.id);
    Provider.of<ProductProvider>(context, listen: false)
        .getBrandProductList(brand.id.toString(), context, '1', Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode, true);
    Navigator.pushNamed(
      context,
      Routes.getBrandRoute(brand.id),
      arguments: BrandScreen(brand: brand),
    );
  }
}

class BrandBannerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: kIsWeb ? kCarouselDesktopHeight : kCarouselViewport,
        viewportFraction: kCarouselViewport,
      ),
      items: [
        1,
        2,
        3,
      ].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Shimmer(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[300],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
