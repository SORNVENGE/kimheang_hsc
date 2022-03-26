import 'package:carousel_slider/carousel_slider.dart';
import 'package:emarket_user/view/screens/category/category_screen.dart';
import 'package:emarket_user/view/screens/product/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/category_model.dart';
import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/provider/banner_provider.dart';
import 'package:emarket_user/provider/category_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/provider/theme_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MainSlider extends StatefulWidget {
  @override
  _MainSliderState createState() => _MainSliderState();
}

class _MainSliderState extends State<MainSlider> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Consumer<BannerProvider>(
      builder: (context, banner, child){
        return banner.bannerList != null? Center(
          child: Column(
            children: [
              CarouselSlider.builder(
                itemCount: banner.bannerList.length,
                options: CarouselOptions(
                    height: 400,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    autoPlay: true,
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }
                ),
                itemBuilder: (ctx, index, realIdx) {
                  return InkWell(
                    onTap: () {
                      if(banner.bannerList[index].productId != null) {
                        Product product;
                        for(Product prod in banner.productList) {
                          if(prod.id == banner.bannerList[index].productId) {
                            product = prod;
                            break;
                          }
                        }
                        Navigator.of(context).pushNamed(Routes.getProductDetailsRoute(product.id),
                            arguments: ProductDetailsScreen(product: product));

                      }else if(banner.bannerList[index].categoryId != null) {
                        CategoryModel category;
                        for(CategoryModel categoryModel in Provider.of<CategoryProvider>(context, listen: false).categoryList) {
                          if(categoryModel.id == banner.bannerList[index].categoryId) {
                            category = categoryModel;
                            break;
                          }
                        }
                        if(category != null) {
                          Navigator.pushNamed(
                            context, Routes.getCategoryRoute(category.id),
                            arguments: CategoryScreen(categoryModel: category),
                          );
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(
                          color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                          spreadRadius: 1, blurRadius: 5,
                        )],
                        color: ColorResources.COLOR_WHITE,
                        // borderRadius: BorderRadius.circular(10),
                      ),
                      child:  ClipRRect(
                        // borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder,
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl}/${ banner.bannerList[index].image}',
                          width: size.width, height: size.height, fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: banner.bannerList.map((b) {
                  int index = banner.bannerList.indexOf(b);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }

                ).toList(),
                ),

            ],
          ),
        ): MainSliderShimmer();
      },
    );
  }
}
class MainSliderShimmer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 400,
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: Provider.of<BannerProvider>(context).bannerList == null,
          child:  Container(
            height: 400,
            color: Colors.grey[300],

          ),
        ),
      ),
    );
  }
}