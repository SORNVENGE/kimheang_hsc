import 'package:emarket_user/data/model/response/cart_model.dart';
import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/data/model/response/product_video_model.dart';
import 'package:emarket_user/helper/price_converter.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/cart_provider.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';
import 'package:emarket_user/view/base/not_logged_in_screen.dart';
import 'package:emarket_user/view/base/title_widget.dart';
import 'package:emarket_user/view/component/dialog/cart_project_diaog.dart';
import 'package:emarket_user/view/component/product_info_component.dart';
import 'package:emarket_user/view/screens/home/home_screen.dart';
import 'package:emarket_user/view/screens/product/details_app_bar.dart';
import 'package:emarket_user/view/screens/product/widget/product_image_view.dart';
import 'package:emarket_user/view/screens/product/widget/product_title_view.dart';
import 'package:emarket_user/view/screens/product/widget/review_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  final CartModel cart;

  // YoutubePlayerController _youtubeController = YoutubePlayerController(
  //   initialVideoId: YoutubePlayer.convertUrlToId(
  //       'https://www.youtube.com/watch?v=gQ1eb82JREE&list=RDgQ1eb82JREE&start_radio=1'),
  //   // 'https://youtu.be/-zsdMqe1txs'),
  //   // initialVideoId: "-zsdMqe1txs",
  //   // initialVideoId: "-zsdMqe1txs",
  //   flags: YoutubePlayerFlags(
  //       mute: false,
  //       autoPlay: false,
  //       disableDragSeek: true,
  //       loop: false,
  //       enableCaption: false),
  // );

  ProductDetailsScreen({@required this.product, this.cart});

  final GlobalKey<DetailsAppBarState> _key = GlobalKey();

  // config youtube player controller to play based on video url
  YoutubePlayerController _getYoutubePlayerController(String videoUrl) {
    return YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl),
      flags: YoutubePlayerFlags(
          mute: false,
          autoPlay: false,
          disableDragSeek: true,
          loop: false,
          enableCaption: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    Variation _variation = Variation();
    GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
    Provider.of<ProductProvider>(context, listen: false).getProductDetails(
      context,
      product,
      cart,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .languageCode,
    );
    Provider.of<ProductProvider>(context, listen: false)
        .getProductReviews(context, product.id);

    // get product video
    Provider.of<ProductProvider>(context, listen: false).getProductVideo(
        context,
        product.videoId,
        Provider.of<LocalizationProvider>(context, listen: false)
            .locale
            .languageCode);

    Provider.of<ProductProvider>(context, listen: false).getRelatedProduct(
        context,
        product,
        Provider.of<LocalizationProvider>(context, listen: false)
            .locale
            .languageCode);

    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        int _stock;
        List _tabChildren;
        double priceWithQuantity;
        // bool isExistInCart;
        CartModel _cartModel;
        List _variationList;
        if (productProvider.product != null ||
            productProvider.relatedProductList != null) {
          _tabChildren = [
            (productProvider.product.description == null ||
                    productProvider.product.description.isEmpty)
                ? Center(
                    child: Text(getTranslated('no_description_found', context)))
                : HtmlWidget(productProvider.product.description ?? ''),
            (productProvider.productReviewList != null &&
                    productProvider.productReviewList.length == 0)
                ? Center(child: Text(getTranslated('no_review_found', context)))
                : ListView.builder(
                    itemCount: productProvider.productReviewList != null
                        ? productProvider.productReviewList.length
                        : 3,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_SMALL),
                    itemBuilder: (context, index) {
                      return productProvider.productReviewList != null
                          ? ReviewWidget(
                              reviewModel:
                                  productProvider.productReviewList[index])
                          : ReviewShimmer();
                    },
                  ),
          ];

          _variationList = [];
          for (int index = 0;
              index < productProvider.product.choiceOptions.length;
              index++) {
            _variationList.add(productProvider.product.choiceOptions[index]
                .options[productProvider.variationIndex[index]]
                .replaceAll(' ', ''));
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

          double price = productProvider.product.price;
          _stock = productProvider.product.totalStock;
          for (Variation variation in productProvider.product.variations) {
            if (variation.type == variationType) {
              price = variation.price;
              _variation = variation;
              _stock = variation.stock;
              break;
            }
          }
          double priceWithDiscount = PriceConverter.convertWithDiscount(
              context,
              price,
              productProvider.product.discount,
              productProvider.product.discountType);
          priceWithQuantity = priceWithDiscount * productProvider.quantity;

          _cartModel = CartModel(
            price,
            priceWithDiscount,
            _variation,
            (price -
                PriceConverter.convertWithDiscount(
                    context,
                    price,
                    productProvider.product.discount,
                    productProvider.product.discountType)),
            productProvider.quantity,
            price -
                PriceConverter.convertWithDiscount(
                    context,
                    price,
                    productProvider.product.tax,
                    productProvider.product.taxType),
            _stock,
            productProvider.product,
          );
          // isExistInCart = Provider.of<CartProvider>(context)
          //     .isExistInCart(_cartModel, false, null);
        }

        return Scaffold(
          key: _globalKey,
          backgroundColor: Theme.of(context).accentColor,
          appBar: ResponsiveHelper.isDesktop(context)
              ? PreferredSize(
                  child: MainAppBar(),
                  preferredSize: Size.fromHeight(80),
                )
              : DetailsAppBar(key: _key),
          body: productProvider.product != null
              ? Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          physics: BouncingScrollPhysics(),
                          child: Center(
                            child: SizedBox(
                              width: 1170,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProductImageView(
                                      productModel: productProvider.product),
                                  SizedBox(height: 20),

                                  ProductTitleView(
                                      productModel: productProvider.product),
                                  Divider(height: 20, thickness: 2),

                                  // Variation
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: productProvider
                                        .product.choiceOptions.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              productProvider.product
                                                  .choiceOptions[index].title,
                                              style: rubikMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 10,
                                              childAspectRatio: (1 / 0.25),
                                            ),
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: productProvider
                                                .product
                                                .choiceOptions[index]
                                                .options
                                                .length,
                                            itemBuilder: (context, i) {
                                              return InkWell(
                                                onTap: () {
                                                  productProvider
                                                      .setCartVariationIndex(
                                                          index, i);
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                  decoration: BoxDecoration(
                                                    color: productProvider
                                                                    .variationIndex[
                                                                index] !=
                                                            i
                                                        ? ColorResources
                                                            .BACKGROUND_COLOR
                                                        : Theme.of(context)
                                                            .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: productProvider
                                                                    .variationIndex[
                                                                index] !=
                                                            i
                                                        ? Border.all(
                                                            color: ColorResources
                                                                .BORDER_COLOR,
                                                            width: 2)
                                                        : null,
                                                  ),
                                                  child: Text(
                                                    productProvider
                                                        .product
                                                        .choiceOptions[index]
                                                        .options[i]
                                                        .trim(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        rubikRegular.copyWith(
                                                      color:
                                                          productProvider.variationIndex[
                                                                      index] !=
                                                                  i
                                                              ? ColorResources
                                                                  .COLOR_BLACK
                                                              : ColorResources
                                                                  .COLOR_WHITE,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                              height: index !=
                                                      productProvider
                                                              .product
                                                              .choiceOptions
                                                              .length -
                                                          1
                                                  ? Dimensions
                                                      .PADDING_SIZE_LARGE
                                                  : 0),
                                        ],
                                      );
                                    },
                                  ),
                                  productProvider.product.choiceOptions.length >
                                          0
                                      ? SizedBox(
                                          height: Dimensions.PADDING_SIZE_LARGE)
                                      : SizedBox(),

                                  // Quantity
                                  Row(
                                    children: [
                                      Text(
                                        getTranslated('quantity', context),
                                        style: rubikMedium.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_LARGE),
                                      ),
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color:
                                              ColorResources.getBackgroundColor(
                                                  context),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (productProvider.quantity >
                                                    1) {
                                                  productProvider.setQuantity(
                                                      false, _stock, context);
                                                }
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
                                              productProvider.quantity
                                                  .toString(),
                                              style: rubikMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_EXTRA_LARGE),
                                            ),
                                            InkWell(
                                              onTap: () =>
                                                  productProvider.setQuantity(
                                                      true, _stock, context),
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
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions.PADDING_SIZE_LARGE),

                                  Row(
                                    children: [
                                      Text(
                                          '${getTranslated('total_amount', context)}:',
                                          style: rubikMedium.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE)),
                                      SizedBox(
                                          width: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      Text(
                                          PriceConverter.convertPrice(
                                              context, priceWithQuantity),
                                          style: rubikBold.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize:
                                                Dimensions.FONT_SIZE_LARGE,
                                          )),
                                    ],
                                  ),

                                  SizedBox(
                                      height: Dimensions.PADDING_SIZE_LARGE),

                                  // Tab Bar
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () =>
                                              productProvider.setTabIndex(0),
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Text(
                                                    getTranslated(
                                                        'description', context),
                                                    style: productProvider
                                                                .tabIndex ==
                                                            0
                                                        ? rubikMedium
                                                        : rubikRegular),
                                              ),
                                              Divider(
                                                thickness: 3,
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(productProvider
                                                                .tabIndex ==
                                                            0
                                                        ? 1
                                                        : 0.2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () =>
                                              productProvider.setTabIndex(1),
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Text(
                                                    getTranslated(
                                                        'review', context),
                                                    style: productProvider
                                                                .tabIndex ==
                                                            1
                                                        ? rubikMedium
                                                        : rubikRegular),
                                              ),
                                              Divider(
                                                thickness: 3,
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(productProvider
                                                                .tabIndex ==
                                                            1
                                                        ? 1
                                                        : 0.2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  _tabChildren[productProvider.tabIndex],

                                  // youtube player section
                                  SizedBox(
                                      height: Dimensions.PADDING_SIZE_LARGE),

                                  Column(
                                    children: [
                                      _getYoutubePlayer(
                                          productProvider.productVideo)
                                    ],
                                  ),

                                  // end of youtube player section

                                  SizedBox(
                                      height: Dimensions.PADDING_SIZE_LARGE),
                                  // productProvider.relatedProductList.length > 0 ? TitleWidget(title: '${getTranslated('related_products', context)}') : SizedBox()
                                  productProvider.relatedProductList != null &&
                                          productProvider
                                                  .relatedProductList.length >
                                              0
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          child: TitleWidget(
                                              title:
                                                  '${getTranslated('related_products', context)}'),
                                        )
                                      : SizedBox(),
                                  productProvider.relatedProductList != null &&
                                          productProvider
                                                  .relatedProductList.length >
                                              0
                                      ? GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          // padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisSpacing: 5,
                                            crossAxisSpacing: 5,
                                            childAspectRatio: 1 / 1.3,
                                            crossAxisCount: kIsWeb ? 6 : 3,
                                          ),
                                          itemBuilder: (context, index) {
                                            return ProductInfoComponent(
                                                productProvider
                                                    .relatedProductList[index]);
                                          },
                                          itemCount: productProvider
                                                      .relatedProductList
                                                      .length >
                                                  6
                                              ? 6
                                              : productProvider
                                                  .relatedProductList.length,
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1170,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: CustomButton(
                        btnTxt: getTranslated(_stock <= 0 ? 'out_of_stock' : 'add_to_cart', context),
                        backgroundColor: Theme.of(context).primaryColor,
                        onTap: _stock > 0
                            ? () {
                                if (_stock > 0) {
                                  // pop up to choose project here
                                  if(_isLoggedIn) {
                                    showDialog(context: context,builder: (_) => CustomEventDialog() ).then((selectedProject) {
                                      if (selectedProject != null) {
                                        _cartModel.projectName = selectedProject;
                                        Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel, context, null);
                                        _key.currentState.shake();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(getTranslated(
                                                'added_to_cart', context)),
                                            backgroundColor: Colors.green,
                                          )
                                        );
                                      }
                                    });
                                  } else {
                                    // go to login screen
                                    Navigator.pushNamed(context, '/login');
                                    // return NotLoggedInScreen();
                                  }
                                }
                              }
                            : null,
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
        );
      },
    );
  }

  Widget _getYoutubePlayer(ProductVideoModel productVideo) {
    if (productVideo != null && productVideo.url != null) {
      return YoutubePlayer(
        controller: _getYoutubePlayerController(productVideo.url),
        showVideoProgressIndicator: true,
        bottomActions: <Widget>[
          const SizedBox(width: 14.0),
          CurrentPosition(),
          const SizedBox(width: 8.0),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
        ],
        aspectRatio: 4 / 3,
        progressIndicatorColor: Colors.white,
        onReady: () {
          print('--------> Player is ready.');
          _getYoutubePlayerController(productVideo.url).addListener(() {});
        },
      );
    } else {
      return SizedBox();
    }
  }
}
