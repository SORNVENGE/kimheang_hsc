import 'package:emarket_user/helper/product_type.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/banner_provider.dart';
import 'package:emarket_user/provider/cart_provider.dart';
import 'package:emarket_user/provider/category_provider.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/provider/profile_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/app_constants.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';
import 'package:emarket_user/view/base/title_widget.dart';
import 'package:emarket_user/view/screens/home/widget/banner_view.dart';
import 'package:emarket_user/view/screens/home/widget/category_view.dart';
import 'package:emarket_user/view/screens/home/widget/main_slider.dart';
import 'package:emarket_user/view/screens/home/widget/offer_product_view.dart';
import 'package:emarket_user/view/screens/home/widget/product_view.dart';
import 'package:emarket_user/view/screens/menu/widget/options_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenBB extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();

  final List<Tab> myTabs = List.generate(
    10,
    (index) => Tab(text: 'TAB $index'),
  );
  final items = List<String>.generate(100, (i) => "Item $i");

  Future<void> _loadData(BuildContext context, bool reload) async {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }
    await Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
      context,
      true,
      Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );
    await Provider.of<BannerProvider>(context, listen: false).getBannerList(context, reload);
    await Provider.of<ProductProvider>(context, listen: false).getOfferProductList(
      context,
      true,
      Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );
    Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
      context,
      '1',
      true,
      Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    _loadData(context, false);

    return Scaffold(
      key: drawerGlobalKey,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: ColorResources.getBackgroundColor(context),
      drawer: ResponsiveHelper.isTab(context) ? Drawer(child: OptionsView(onTap: null)) : SizedBox(),
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)) : null,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadData(context, true);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Scrollbar(
            controller: _scrollController,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // App Bar
                ResponsiveHelper.isDesktop(context)
                    ? SliverToBoxAdapter(child: SizedBox())
                    : SliverAppBar(
                        floating: true,
                        elevation: 0,
                        centerTitle: false,
                        backgroundColor: Theme.of(context).accentColor,
                        pinned: ResponsiveHelper.isTab(context) ? true : false,
                        leading: ResponsiveHelper.isTab(context)
                            ? IconButton(
                                onPressed: () => drawerGlobalKey.currentState.openDrawer(),
                                icon: Icon(Icons.menu, color: Colors.black),
                              )
                            : null,
                        title: Consumer<SplashProvider>(
                            builder: (context, splash, child) => Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ResponsiveHelper.isWeb()
                                        ? FadeInImage.assetNetwork(
                                            placeholder: Images.placeholder,
                                            image: splash.baseUrls != null
                                                ? '${splash.baseUrls.ecommerceImageUrl}/${splash.configModel.ecommerceLogo}'
                                                : '',
                                            height: 40,
                                            width: 40,
                                          )
                                        : Image.asset(Images.logo, width: 40, height: 40),
                                    SizedBox(width: 10),
                                    Text(
                                      ResponsiveHelper.isWeb() ? splash.configModel.ecommerceName : AppConstants.APP_NAME,
                                      style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
                                    ),
                                  ],
                                )),
                        actions: [
                          IconButton(
                            onPressed: () => Navigator.pushNamed(context, Routes.getNotificationRoute()),
                            icon: Icon(Icons.notifications, color: Theme.of(context).textTheme.bodyText1.color),
                          ),
                          ResponsiveHelper.isTab(context)
                              ? IconButton(
                                  onPressed: () => Navigator.pushNamed(context, Routes.getDashboardRoute('cart')),
                                  icon: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Icon(Icons.shopping_cart, color: Theme.of(context).textTheme.bodyText1.color),
                                      Positioned(
                                        top: -7,
                                        right: -7,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                          child: Center(
                                            child: Text(
                                              Provider.of<CartProvider>(context).cartList.length.toString(),
                                              style: rubikMedium.copyWith(color: Colors.white, fontSize: 8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),

                // Search Button
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(
                      child: Center(
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, Routes.getSearchRoute()),
                      child: Container(
                        height: 60,
                        width: 1170,
                        color: Theme.of(context).accentColor,
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(color: ColorResources.getSearchBg(context), borderRadius: BorderRadius.circular(10)),
                          child: Row(children: [
                            Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL), child: Icon(Icons.search, size: 25)),
                            Expanded(child: Text(getTranslated('search_items_here', context), style: rubikRegular.copyWith(fontSize: 12))),
                          ]),
                        ),
                      ),
                    ),
                  )),
                ),

                SliverToBoxAdapter(
                  child: Center(
                    child: SizedBox(
                      width: 1170,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        ResponsiveHelper.isDesktop(context)
                            ? Padding(
                                padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                                child: MainSlider(),
                              )
                            : SizedBox(),
                        Consumer<CategoryProvider>(
                          builder: (context, category, child) {
                            return category.categoryList == null
                                ? CategoryView()
                                : category.categoryList.length == 0
                                    ? SizedBox()
                                    : CategoryView();
                          },
                        ),
                        Consumer<ProductProvider>(
                          builder: (context, offerProduct, child) {
                            return offerProduct.offerProductList == null
                                ? OfferProductView()
                                : offerProduct.offerProductList.length == 0
                                    ? SizedBox()
                                    : OfferProductView();
                          },
                        ),
                        ResponsiveHelper.isDesktop(context)
                            ? SizedBox()
                            : Consumer<BannerProvider>(
                                builder: (context, banner, child) {
                                  return banner.bannerList == null
                                      ? BannerView()
                                      : banner.bannerList.length == 0
                                          ? SizedBox()
                                          : BannerView();
                                },
                              ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: TitleWidget(title: getTranslated('popular_item', context)),
                        ),
                        ProductView(productType: ProductType.POPULAR_PRODUCT),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}
