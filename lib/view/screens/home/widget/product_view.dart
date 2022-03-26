import 'package:emarket_user/provider/localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/helper/product_type.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/view/base/no_data_screen.dart';
import 'package:emarket_user/view/base/product_shimmer.dart';
import 'package:emarket_user/view/base/product_widget.dart';
import 'package:provider/provider.dart';

class ProductView extends StatelessWidget {
  final ProductType productType;
  ProductView({@required this.productType});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product> productList;
        if (productType == ProductType.POPULAR_PRODUCT) {
          productList = prodProvider.popularProductList;
        }

        return Column(children: [
          productList != null
              ? productList.length > 0
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 1/1.6,
                          crossAxisCount: ResponsiveHelper.isDesktop(context)
                              ? 6
                              : ResponsiveHelper.isTab(context)
                                  ? 4
                                  : 3),
                      itemCount: productList.length,
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductWidget(product: productList[index]);
                      },
                    )
                  : NoDataScreen()
              : GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 1/1.6,
                      crossAxisCount: ResponsiveHelper.isDesktop(context)
                          ? 6
                          : ResponsiveHelper.isTab(context)
                              ? 4
                              : 3),
                  itemCount: 12,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductShimmer(isEnabled: productList == null);
                  },
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL)),
          prodProvider.isLoading
              ? Center(
                  child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).errorColor)),
                ))
              : SizedBox(),
        ]);
      },
    );
  }
}
