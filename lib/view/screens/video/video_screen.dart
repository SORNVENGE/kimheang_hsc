import 'package:emarket_user/data/model/response/product_video_model.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/provider/localization_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/provider/video_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';
import 'package:emarket_user/view/screens/brand/brand_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Video'),
      body: SafeArea(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: 155,
          ),
          Text(
            "Stay tune, something great is coming :)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
        ]),
      ),
    );
  }*/

  // config youtube player controller to play based on video url
  YoutubePlayerController _getYoutubePlayerController(String videoUrl) {
    return YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl),
      flags: YoutubePlayerFlags(
          hideControls: true,
          mute: false,
          autoPlay: false,
          disableDragSeek: true,
          loop: false,
          enableCaption: false),
    );
  }

  Widget _getYoutubePlayer(ProductVideoModel productVideo) {
    print('----> product video : ${productVideo.id} ${productVideo.toJson()}');
    if (productVideo != null && productVideo.url != null) {
      return YoutubePlayer(
        controller: _getYoutubePlayerController(productVideo.url),
        showVideoProgressIndicator: false,
        // bottomActions: <Widget>[
        //   const SizedBox(width: 14.0),
        //   CurrentPosition(),
        //   const SizedBox(width: 8.0),
        //   ProgressBar(isExpanded: false),
        //   RemainingDuration(),
        // ],
        aspectRatio: 5 / 3,
        progressIndicatorColor: Colors.white,
        onReady: () {
          print('--------> Player is ready.');
          _getYoutubePlayerController(productVideo.url).addListener(() {});
        },
      );
    } else {
      return SizedBox(height: 0,);
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductVideoProvider>(context, listen: false)
        .getProductVideoList(
            context,
            Provider.of<LocalizationProvider>(context, listen: false)
                .locale
                .languageCode);

    return Scaffold(
        appBar: CustomAppBar(title: 'Video'),
        body: Consumer<ProductVideoProvider>(
            builder: (context, videoProvider, child) {
          return Container(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: videoProvider.productVideoList.length,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 1 / 1.2,
                          crossAxisCount: ResponsiveHelper.isDesktop(context)
                              ? 6
                              : ResponsiveHelper.isTab(context)
                                  ? 4
                                  : 2),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[300],
                                      blurRadius: 5,
                                      spreadRadius: 1)
                                ]),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    videoProvider.productVideoList[index].title,
                                    style: TextStyle(color: Colors.indigo),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      child: _getYoutubePlayer(videoProvider
                                          .productVideoList[index])),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.PADDING_SIZE_SMALL),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              videoProvider
                                                  .productVideoList[index]
                                                  .title,
                                              style: TextStyle(
                                                  color: Colors.indigo),
                                              // maxLines: 2,
                                              // overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                                height: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL),
                                          ]),
                                    ),
                                  ),
                                ]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
