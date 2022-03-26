import 'package:emarket_user/data/model/response/brand_model.dart';
import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/data/repository/product_repo.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/brand_provider.dart';
import 'package:emarket_user/provider/category_provider.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';
import 'package:emarket_user/view/base/no_data_screen.dart';
import 'package:emarket_user/view/base/product_shimmer.dart';
import 'package:emarket_user/view/base/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandScreen extends StatefulWidget {
  final Brand brand;

  BrandScreen({@required this.brand});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  int _pageOffset = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    this._scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          Provider.of<ProductProvider>(context, listen: false).isBrandProductLoading != null &&
          !Provider.of<ProductProvider>(context, listen: false).isBrandProductLoading) {
        int pageSize;
        // if (productType == ProductType.POPULAR_PRODUCT) {
        pageSize = (Provider.of<ProductProvider>(context, listen: false).brandProductPageSize / DEFAULT_LIMIT).ceil();
        // }
        if (_pageOffset < pageSize) {
          _pageOffset++;
          print('end of the page');
          Provider.of<ProductProvider>(context, listen: false).showBottomLoaderBrand();
          Provider.of<ProductProvider>(context, listen: false).getBrandProductList(
            widget.brand.id.toString(),
            context,
            _pageOffset.toString(),
            Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
            false,
          );
        }
      }
    });
    loadData();
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    super.dispose();
  }

  loadData() async {
    Provider.of<ProductProvider>(context, listen: false).getBrandProductList(
        widget.brand.id.toString(), context, '1', Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode, true);
    this._pageOffset = 1;
  }

  @override
  Widget build(BuildContext context) {
    var top = 0.0;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: MainAppBar(),
              preferredSize: Size.fromHeight(80),
            )
          : null,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => await this.loadData(),
          child: Scrollbar(
            controller: _scrollController,
            child: Container(
              width: 1170,
              child: CustomScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    toolbarHeight: 20 + MediaQuery.of(context).padding.top,
                    // collapsedHeight: 70,
                    pinned: true,
                    floating: false,
                    automaticallyImplyLeading: true,
                    backgroundColor: Theme.of(context).accentColor,
                    leading: IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),

                    flexibleSpace: LayoutBuilder(
                      builder: (BuildContext ctx, BoxConstraints constraints) {
                        top = constraints.biggest.height;
                        return FlexibleSpaceBar(
                          title: (20 + MediaQuery.of(context).padding.top == top) // Display title only when appBar is collapse
                              ? Text(
                                  widget.brand.name,
                                  style: rubikMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                    color: Theme.of(context).textTheme.bodyText1.color,
                                  ),
                                )
                              : null,
                          titlePadding: EdgeInsets.only(
                            bottom: (MediaQuery.of(context).padding.top / 2),
                            left: 50,
                            right: 50,
                          ),
                          background: Container(
                            // margin: EdgeInsets.only(bottom: 50),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholder,
                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.brandImageUrl}/${widget.brand.image}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Consumer<ProductProvider>(builder: (contetxt, product, child) {
                    return SliverToBoxAdapter(
                      child: product.brandProductList != null
                          ? product.brandProductList.length > 0
                              ? GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: 4,
                                      crossAxisCount: ResponsiveHelper.isDesktop(context)
                                          ? 3
                                          : ResponsiveHelper.isTab(context)
                                              ? 2
                                              : 1),
                                  itemCount: product.brandProductList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                  itemBuilder: (context, index) {
                                    // print(
                                    //     "Product is ${product.brandProductList.length}");
                                    return ProductWidget(
                                      product: product.brandProductList[index],
                                    );
                                    // return Text("A");
                                  },
                                )
                              : NoDataScreen()
                          : GridView.builder(
                              shrinkWrap: true,
                              itemCount: 10,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 4,
                                crossAxisCount: ResponsiveHelper.isDesktop(context)
                                    ? 3
                                    : ResponsiveHelper.isTab(context)
                                        ? 2
                                        : 1,
                              ),
                              itemBuilder: (context, index) {
                                // return Text("A");
                                return ProductShimmer(isEnabled: true);
                              },
                            ),
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
