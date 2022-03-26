import 'package:carousel_slider/carousel_slider.dart';
import 'package:emarket_user/data/model/response/category_model.dart';
import 'package:emarket_user/data/repository/product_repo.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/brand_provider.dart';
import 'package:emarket_user/provider/cart_provider.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/provider/tab_provider.dart';
import 'package:emarket_user/utill/app_constants.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';
import 'package:emarket_user/view/component/custom_tab.dart';
import 'package:emarket_user/view/screens/category/category_screen_new.dart';
import 'package:emarket_user/view/screens/home/widget/brand_banner_view.dart';
import 'package:emarket_user/view/screens/home/widget/main_slider.dart';
import 'package:emarket_user/view/screens/menu/widget/options_view.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/helper/product_type.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/banner_provider.dart';
import 'package:emarket_user/provider/category_provider.dart';
import 'package:emarket_user/provider/profile_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/title_widget.dart';
import 'package:emarket_user/view/screens/home/widget/banner_view.dart';
import 'package:emarket_user/view/screens/home/widget/product_view.dart';
import 'package:emarket_user/view/screens/home/widget/offer_product_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;
  int _popularProductPageOffset = 1;
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  TabController _tabController;

  Future<void> _loadData(BuildContext context, bool reload) async {
    // TODO: Store Category List, and reduce loading cateegory list
    print("CURRENT INDEX IS $_tabIndex");
    await Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(context, true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode);
    if (this._tabIndex == 0) {
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
      Provider.of<BrandProvider>(context, listen: false).getBrands(context);
      if (reload) {
        this._popularProductPageOffset = 1;
      }
    } else {
      await Provider.of<CategoryProvider>(context, listen: false).getCategoryProductList(
        context,
        Provider.of<CategoryProvider>(context, listen: false).categoryList[this._tabIndex - 1].id.toString(),
        Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
      );
      await Provider.of<CategoryProvider>(context, listen: false).getSubCategoryList(
        context,
        Provider.of<CategoryProvider>(context, listen: false).categoryList[this._tabIndex - 1].id.toString(),
        Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
      );
    }
  }

  Future<void> initNecessaryData() async {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }
    await Provider.of<TabProvider>(context, listen: false)
        .getCategoryList(context, true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (this._tabIndex == 0) {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
            Provider.of<ProductProvider>(context, listen: false).popularProductList != null &&
            !Provider.of<ProductProvider>(context, listen: false).isLoading) {
          int pageSize;
          pageSize = (Provider.of<ProductProvider>(context, listen: false).popularPageSize / DEFAULT_LIMIT).ceil();
          if (_popularProductPageOffset < pageSize) {
            _popularProductPageOffset++;
            Provider.of<ProductProvider>(context, listen: false).showBottomLoader();
            Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
              context,
              _popularProductPageOffset.toString(),
              false,
              Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
            );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // no one should rebuild this widget
    this.initNecessaryData();
    _loadData(context, false);

    return Scaffold(
      key: drawerGlobalKey,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: ColorResources.getBackgroundColor(context),
      drawer: ResponsiveHelper.isTab(context) ? Drawer(child: OptionsView(onTap: null)) : SizedBox(),
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: MainAppBar(),
              preferredSize: Size.fromHeight(80),
            )
          : null,
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
                    ? SliverToBoxAdapter(
                        child: SizedBox(),
                      )
                    : SliverAppBar(
                        floating: true,
                        elevation: 0,
                        centerTitle: false,
                        automaticallyImplyLeading: false,
                        backgroundColor: Theme.of(context).accentColor,
                        pinned: false,
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
                                      image:
                                          splash.baseUrls != null ? '${splash.baseUrls.ecommerceImageUrl}/${splash.configModel.ecommerceLogo}' : '',
                                      height: 40,
                                      width: 40,
                                    )
                                  : Image.asset(Images.hsc_logo, width: 40, height: 40),
                              SizedBox(width: 10),
                              Text(
                                ResponsiveHelper.isWeb() ? splash.configModel.ecommerceName : AppConstants.APP_NAME,
                                style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          IconButton(
                            onPressed: () => Navigator.pushNamed(context, Routes.getSearchRoute()),
                            icon: Icon(Icons.search, color: Theme.of(context).textTheme.bodyText1.color),
                          ),
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

                // // Search Button
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(
                      child: Container(
                    height: 50.0,
                    color: Theme.of(context).accentColor,
                    child: Column(
                      children: [
                        Consumer<TabProvider>(builder: (context, tab, child) {
                          return tab.categoryList != null
                              ? CustomTabBar(
                                  controller: (controller) {
                                    _tabController = controller;
                                    _tabController.addListener(() {
                                      if (this._tabController != null &&
                                          this._tabController.index != null &&
                                          this._tabController.index != this._tabIndex) {
                                        this._tabIndex = this._tabController.index;
                                        this._loadData(context, false);
                                      }
                                    });
                                    // _tabController.
                                  },
                                  tabs: this._tabs(tab.categoryList))
                              : SizedBox();
                        }),
                        Divider(
                          height: 1,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ],
                    ),
                  )),
                ),

                SliverToBoxAdapter(
                  child: Center(
                    child: SizedBox(
                      width: 1170,
                      child: Consumer<CategoryProvider>(
                        builder: (context, category, child) {
                          // return Text("ASDA");
                          return this._tabIndex == 0 ? BodyContent() : NewCategoryScreen();
                        },
                      ),
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

  List<Tab> _tabs(List<CategoryModel> categoryList) {
    List<Tab> tabList = [];
    tabList.add(Tab(text: 'All'));
    categoryList.forEach((subCategory) => tabList.add(Tab(text: subCategory.name)));
    return tabList;
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

class BodyContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ResponsiveHelper.isDesktop(context)
        //     ? Padding(
        //         padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
        //         child: MainSlider(),
        //       )
        //     : SizedBox(),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: TitleWidget(
            title: getTranslated('brand', context),
          ),
        ),
        Consumer<BrandProvider>(
          builder: (context, brand, child) {
            return brand.brands == null
                ? BrandBannerView()
                : brand.brands.length == 0
                    ? SizedBox()
                    : BrandBannerView();
          },
        ),

        // TODO: Brand Branner
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
          child: TitleWidget(
            title: getTranslated('all_item', context),
          ),
        ),
        ProductView(productType: ProductType.POPULAR_PRODUCT),
      ],
    );
  }
}
