import 'package:emarket_user/data/model/response/category_model.dart';
import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/view/base/product_shimmer.dart';
import 'package:emarket_user/view/base/rating_bar.dart';
import 'package:emarket_user/view/base/title_widget.dart';
import 'package:emarket_user/view/component/product_info_component.dart';
import 'package:emarket_user/view/screens/product/widget/product_title_view.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/provider/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NewCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, category, child) {
      return category.subCategoryList != null && category.categoryProductList != null
          ? Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: buildWidgetList(category.subCategoryList, category.categoryProductList),
              ),
            )
          : CategoryShimmer();
    });
  }

  List<Widget> buildWidgetList(List<CategoryModel> subCategoryList, List<Product> products) {
    List<Widget> widgets = subCategoryList.fold([], (previousValue, subCategory) {
      previousValue.add(
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: TitleWidget(title: subCategory.name),
        ),
      );
      // Category Id type is string
      // CategoryModel id is int
      List<Product> productList =
          products.where((product) => product.categoryIds.map((categoryId) => categoryId.id).contains(subCategory.id.toString())).toList();
      previousValue.add(
        productList.length > 0
            ? Center(
                child: SizedBox(
                  width: 1170,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    // physics: NeverScrollableScrollPhysics(),
                    // padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: 1 / 1.3,
                      crossAxisCount: kIsWeb ? 6 : 3,
                    ),
                    itemBuilder: (context, index) {
                      return ProductInfoComponent(productList[index]);
                    },
                    itemCount: productList.length,
                  ),
                ),
              )
            : Text("There are no item to display"),
      );
      previousValue.add(
        SizedBox(
          height: 10.0,
        ),
      );
      return previousValue;
    });
    return widgets;
  }
}

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer(
            child: Container(
              height: 25,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Shimmer(
            // color: Colors.blue,
            direction: ShimmerDirection.fromLTRB(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
