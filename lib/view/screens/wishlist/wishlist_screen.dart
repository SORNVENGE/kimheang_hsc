import 'package:emarket_user/provider/localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/wishlist_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/no_data_screen.dart';
import 'package:emarket_user/view/base/not_logged_in_screen.dart';
import 'package:emarket_user/view/base/product_widget.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('my_favourite', context), isBackButtonExist: !ResponsiveHelper.isMobile(context)),
      body: _isLoggedIn ? Consumer<WishListProvider>(
        builder: (context, wishlistProvider, child) {
          return wishlistProvider.wishList != null ? wishlistProvider.wishIdList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<WishListProvider>(context, listen: false).initWishList(
                context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
              );
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Column(
              children: [
                SizedBox(height: 10),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 1/1.6,
                      crossAxisCount: ResponsiveHelper.isDesktop(context)
                          ? 6
                          : ResponsiveHelper.isTab(context)
                          ? 4
                          : 3),
                  itemCount: wishlistProvider.wishList.length,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductWidget(product: wishlistProvider.wishList[index]);
                  },
                )
              ],
            )

            // Scrollbar(
            //   child: SingleChildScrollView(
            //     child: Center(
            //       child: SizedBox(
            //         width: 1170,
            //         child: ListView.builder(
            //           physics: NeverScrollableScrollPhysics(),
            //           shrinkWrap: true,
            //           itemCount: wishlistProvider.wishList.length,
            //           padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            //           itemBuilder: (context, index) {
            //             return ProductWidget(product: wishlistProvider.wishList[index]);
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ): NoDataScreen()
              : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : NotLoggedInScreen(),
    );
  }
}
