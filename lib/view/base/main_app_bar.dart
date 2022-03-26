import 'package:flutter/material.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/menu_bar.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Theme.of(context).accentColor,
        width: 1170,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, Routes.getMainRoute()),
                child:  Consumer<SplashProvider>(builder:(context, splash, child) => splash.configModel.ecommerceLogo != null? FadeInImage.assetNetwork(
                        placeholder: Images.placeholder,
                        image:  '${splash.baseUrls.ecommerceImageUrl}/${splash.configModel.ecommerceLogo}',width: 70, height: 50) : SizedBox(),
                ),
              ),
            ),
            MenuBar(),
          ],
        )
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}
