import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/cart_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Key key;
  DetailsAppBar({this.key});

  @override
  DetailsAppBarState createState() => DetailsAppBarState();

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}

class DetailsAppBarState extends State<DetailsAppBar> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
  }

  void shake() {
    controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<CartProvider>(context, listen: false).getCartData(context);
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 15.0).chain(CurveTween(curve: Curves.elasticIn)).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });

    return AppBar(
      leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyText1.color), onPressed: () => Navigator.pop(context)),
      backgroundColor: Theme.of(context).accentColor,
      elevation: 0,
      title: Text(
        getTranslated('product_details', context),
        style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).textTheme.bodyText1.color),
      ),
      centerTitle: true,
      actions: [AnimatedBuilder(
        animation: offsetAnimation,
        builder: (buildContext, child) {
          return Container(
            padding: EdgeInsets.only(left: offsetAnimation.value + 15.0, right: 15.0 - offsetAnimation.value),
            child: Stack(children: [
              IconButton(icon: Icon(Icons.shopping_cart, color: Theme.of(context).primaryColor), onPressed: () {
                Navigator.pushNamed(context, Routes.getDashboardRoute('cart'),arguments: CartScreen(fromDetails: true));
              }),
              Positioned(
                top: 5, right: 5,
                child: Container(
                  padding: EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child: Text(
                    Provider.of<CartProvider>(context).totalSize.toString(),
                    style: rubikMedium.copyWith(color: Colors.white, fontSize: 8),
                  ),
                ),
              ),

            ]),
          );
        },
      )],
    );
  }
}
