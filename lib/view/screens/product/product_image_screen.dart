import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/product_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class ProductImageScreen extends StatefulWidget {
  final List<String> imageList;
  ProductImageScreen({@required this.imageList});

  @override
  _ProductImageScreenState createState() => _ProductImageScreenState();
}

class _ProductImageScreenState extends State<ProductImageScreen> {
  int pageIndex;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    pageIndex = Provider.of<ProductProvider>(context, listen: false).imageSliderIndex;
    _pageController = PageController(initialPage: pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80))
          : CustomAppBar(title: getTranslated('product_images', context)),
      body: Column(children: [

        Expanded(
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage('${Provider.of<SplashProvider>(context,listen: false).baseUrls.productImageUrl}/${widget.imageList[index]}'),
                    initialScale: PhotoViewComputedScale.contained,
                    heroAttributes: PhotoViewHeroAttributes(tag: index.toString()),
                  );
                },
                backgroundDecoration: BoxDecoration(color: Theme.of(context).accentColor),
                itemCount: widget.imageList.length,
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                    ),
                  ),
                ),
                pageController: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
              ),

              pageIndex != 0 ? Positioned(
                left: 5, top: 0, bottom: 0,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: () {
                      if(pageIndex > 0) {
                        _pageController.animateToPage(pageIndex-1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                      }
                    },
                    child: Icon(Icons.chevron_left_outlined, size: 40),
                  ),
                ),
              ) : SizedBox.shrink(),

              pageIndex != widget.imageList.length-1 ? Positioned(
                right: 5, top: 0, bottom: 0,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: () {
                      if(pageIndex < widget.imageList.length) {
                        _pageController.animateToPage(pageIndex+1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                      }
                    },
                    child: Icon(Icons.chevron_right_outlined, size: 40),
                  ),
                ),
              ) : SizedBox.shrink(),
            ],
          ),
        ),

      ]),
    );
  }
}

