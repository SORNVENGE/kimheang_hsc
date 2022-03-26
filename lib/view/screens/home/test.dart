import 'dart:math';

import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/cart_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/app_constants.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/screens/home/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class Test extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();

  final List<Tab> myTabs = List.generate(
    2,
    (index) => Tab(text: 'TAB $index'),
  );

  final items = List<String>.generate(100, (i) => "Item $i");

  final ScrollController _scrollController = ScrollController();

  Future<void> onRefresh() async {
    print("refreshing");
    await Future.delayed(
      Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return MatchFragment();
    return CustomSliverAppbar();
    // return SafeArea(
    //   child: NestedScrollView(
    //     controller: _scrollViewController,
    //     headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
    //       return <Widget>[
    //         SliverAppBar(
    //           title: Text("WhatsApp using Flutter"),
    //           floating: true,
    //           pinned: true,
    //           bottom: TabBar(
    //             tabs: <Widget>[
    //               Tab(
    //                 child: Text("Colors"),
    //               ),
    //               Tab(
    //                 child: Text("Chats"),
    //               ),
    //             ],
    //             controller: _tabController,
    //           ),
    //         ),
    //       ];
    //     },
    //     body: TabBarView(
    //       controller: _tabController,
    //       children: <Widget>[
    //         ListView.builder(
    //           itemBuilder: (BuildContext context, int index) {
    //             Color color = getRandomColor();
    //             return Container(
    //               height: 150.0,
    //               color: color,
    //               child: Text(
    //                 "Row $index",
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             );
    //           },
    //           //physics: NeverScrollableScrollPhysics(), //This may come in handy if you have issues with scrolling in the future
    //         ),
    //         ListView.builder(
    //           itemBuilder: (BuildContext context, int index) {
    //             return Material(
    //               child: ListTile(
    //                 leading: CircleAvatar(
    //                   backgroundColor: Colors.blueGrey,
    //                 ),
    //                 title: Text(items.elementAt(index)),
    //               ),
    //             );
    //           },
    //           //physics: NeverScrollableScrollPhysics(),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    // return DefaultTabController(
    //   length: _tabs.length,
    //   child: Scaffold(
    //     body: NestedScrollView(
    //       headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //         return <Widget>[
    //           SliverOverlapAbsorber(
    //             handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
    //             sliver: SliverAppBar(
    //               title: const Text('Books'),
    //               floating: true,
    //               pinned: true,
    //               snap: true,
    //               forceElevated: innerBoxIsScrolled,
    //               bottom: TabBar(
    //                 tabs: _tabs.map((String name) => Tab(text: name)).toList(),
    //               ),
    //             ),
    //           ),
    //         ];
    //       },
    //       body: TabBarView(
    //         children: _tabs.map((String name) {
    //           return SafeArea(
    //             top: false,
    //             bottom: false,
    //             child: Builder(
    //               builder: (BuildContext context) {
    //                 return CustomScrollView(
    //                   key: PageStorageKey<String>(name),
    //                   slivers: <Widget>[
    //                     SliverOverlapInjector(
    //                       handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
    //                     ),
    //                     SliverPadding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       sliver: SliverList(
    //                         delegate: SliverChildBuilderDelegate(
    //                           (BuildContext context, int index) {
    //                             return ListTile(
    //                               title: Text('Item $index'),
    //                             );
    //                           },
    //                           childCount: 30,
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 );
    //               },
    //             ),
    //           );
    //         }).toList(),
    //       ),
    //     ),
    //   ),
    // );

    // return Scaffold(
    //     body: DefaultTabController(
    //   length: 2,
    //   child: CustomScrollView(
    //     slivers: <Widget>[
    //       SliverAppBar(
    //         pinned: false,
    //         snap: false,
    //         floating: true,
    //         flexibleSpace: FlexibleSpaceBar(
    //           title: Text('Demo'),
    //         ),
    //       ),
    //       buildSliverHeader(context),
    //       SliverToBoxAdapter(
    //         child: TabBarView(
    //           children: [
    //             ListView(
    //               children: List.generate(
    //                 100,
    //                 (index) => Container(
    //                   child: Text("EEE $index"),
    //                 ),
    //               ),
    //             ),
    //             Container(
    //               child: Text("BBBB"),
    //             ),
    //           ],
    //         ),
    //       )
    //       // SliverGrid(
    //       //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    //       //     maxCrossAxisExtent: 200.0,
    //       //     mainAxisSpacing: 10.0,
    //       //     crossAxisSpacing: 10.0,
    //       //     childAspectRatio: 4.0,
    //       //   ),
    //       //   delegate: SliverChildBuilderDelegate(
    //       //     (BuildContext context, int index) {
    //       //       return Container(
    //       //         alignment: Alignment.center,
    //       //         color: Colors.teal[100 * (index % 9)],
    //       //         child: Text('grid item $index'),
    //       //       );
    //       //     },
    //       //     childCount: 50,
    //       //   ),
    //       // ),
    //     ],
    //   ),
    // ));

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [buildSliverAppBar(context), buildSliverHeader(context)];
          },
          body: TabBarView(
            children: [
              ListView.builder(
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: index % 2 == 0 ? Colors.blue : Colors.green,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 100.0,
                      child: Text(
                        'Flutter is awesome',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  );
                },
              ),
              ListView.builder(
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: index % 2 == 0 ? Colors.blue : Colors.green,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 100.0,
                      child: Text(
                        'Flutter is awesome',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
    // return Screen();
    // return SafeArea(
    //   child: RefreshIndicator(
    //     onRefresh: () => this.onRefresh(),
    //     child: DefaultTabController(
    //       length: this.myTabs.length,
    //       child: Scrollbar(
    //         controller: _scrollController,
    //         child: CustomScrollView(
    //           controller: _scrollController,
    //           slivers: [
    //             SliverAppBar(
    //               pinned: false,
    //               title: Text("TEST"),
    //             ),
    //             SliverPersistentHeader(
    //               pinned: true,
    //               delegate: SliverDelegate(
    //                 child: Column(
    //                   children: [
    //                     Center(
    //                       child: InkWell(
    //                         onTap: () => print("Hello :)"),
    //                         child: Container(
    //                           height: 60,
    //                           width: 1170,
    //                           color: Theme.of(context).accentColor,
    //                           padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 5),
    //                           child: Container(
    //                             // decoration: BoxDecoration(
    //                             //   color: ColorResources.getSearchBg(context),
    //                             //   borderRadius: BorderRadius.circular(10),
    //                             // ),
    //                             child: TabBar(
    //                               tabs: this.myTabs,
    //                               isScrollable: true,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     Center(
    //                       child: InkWell(
    //                         onTap: () => print("Hello :)"),
    //                         child: Container(
    //                           height: 60,
    //                           width: 1170,
    //                           color: Theme.of(context).accentColor,
    //                           padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 5),
    //                           child: Container(
    //                             decoration: BoxDecoration(
    //                               color: ColorResources.getSearchBg(context),
    //                               borderRadius: BorderRadius.circular(10),
    //                             ),
    //                             child: Row(
    //                               children: [
    //                                 Padding(
    //                                   padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
    //                                   child: Icon(Icons.search, size: 25),
    //                                 ),
    //                                 Expanded(
    //                                   child: Text(
    //                                     getTranslated('search_items_here', context),
    //                                     style: rubikRegular.copyWith(fontSize: 12),
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //
    //             SliverToBoxAdapter(
    //               child: TabBarView(
    //
    //                 physics: NeverScrollableScrollPhysics(),
    //                 children: [
    //                   Column(
    //
    //                     children: List.generate(
    //                       100,
    //                       (index) => Container(
    //                         child: Text("index $index"),
    //                       ),
    //                     ),
    //                   ),
    //                   Container(
    //                     child: Text("B"),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             // SliverToBoxAdapter(
    //             //   child: SingleChildScrollView(
    //             //     child: Column(
    //             //       children: List.generate(
    //             //         100,
    //             //         (index) => Container(
    //             //           child: Text("ABC ${index}"),
    //             //         ),
    //             //       ),
    //             //     ),
    //             //   ),
    //             // ),
    //             // SliverList(delegate: new SliverChildListDelegate(_buildList(50))),
    //             // SliverToBoxAdapter(child: Container(child: Text("asdasd"))),
    //             // SliverAppBar(
    //             //   pinned: true,
    //             //   floating: true,
    //             //   automaticallyImplyLeading: false,
    //             //   title: Center(
    //             //     child: InkWell(
    //             //       onTap: () => print("Hello :)"),
    //             //       child: Container(
    //             //         height: 60,
    //             //         width: 1170,
    //             //         color: Theme.of(context).accentColor,
    //             //         padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 5),
    //             //         child: Container(
    //             //           decoration: BoxDecoration(
    //             //             color: ColorResources.getSearchBg(context),
    //             //             borderRadius: BorderRadius.circular(10),
    //             //           ),
    //             //           child: Row(
    //             //             children: [
    //             //               Padding(
    //             //                 padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
    //             //                 child: Icon(Icons.search, size: 25),
    //             //               ),
    //             //               Expanded(
    //             //                 child: Text(
    //             //                   getTranslated('search_items_here', context),
    //             //                   style: rubikRegular.copyWith(fontSize: 12),
    //             //                 ),
    //             //               ),
    //             //             ],
    //             //           ),
    //             //         ),
    //             //       ),
    //             //     ),
    //             //   ),
    //             //   bottom: TabBar(
    //             //     tabs: this.myTabs,
    //             //     isScrollable: true,
    //             //   ),
    //             // ),
    //
    //             // SliverToBoxAdapter(
    //             //   child: Column(
    //             //     children: this
    //             //         .items
    //             //         .map(
    //             //           (e) => Text(e),
    //             //         )
    //             //         .toList(),
    //             //   ),
    //             // ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    // return SafeArea(
    //   child: RefreshIndicator(
    //     onRefresh: () => this.onRefresh(),
    //     child: DefaultTabController(
    //       length: this.myTabs.length,
    //       child: NestedScrollView(
    //         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //           return <Widget>[
    //             new SliverAppBar(
    //               pinned: true,
    //               floating: true,
    //               automaticallyImplyLeading: false,
    //               title: Center(
    //                 child: InkWell(
    //                   onTap: () => print("Hello :)"),
    //                   child: Container(
    //                     height: 60,
    //                     width: 1170,
    //                     color: Theme.of(context).accentColor,
    //                     padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 5),
    //                     child: Container(
    //                       decoration: BoxDecoration(
    //                         color: ColorResources.getSearchBg(context),
    //                         borderRadius: BorderRadius.circular(10),
    //                       ),
    //                       child: Row(
    //                         children: [
    //                           Padding(
    //                             padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
    //                             child: Icon(Icons.search, size: 25),
    //                           ),
    //                           Expanded(
    //                             child: Text(
    //                               getTranslated('search_items_here', context),
    //                               style: rubikRegular.copyWith(fontSize: 12),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               // flexibleSpace: FlexibleSpaceBar(
    //               //   title: Padding(
    //               //     padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    //               //     child: Container(
    //               //       color: Colors.black,
    //               //       child: Text("ASD"),
    //               //     ),
    //               //   ),
    //               // ),
    //               bottom: TabBar(
    //                 isScrollable: true,
    //                 tabs: this.myTabs,
    //               ),
    //             ),
    //           ];
    //         },
    //         body: Scrollbar(
    //           controller: _scrollController,
    //           child: CustomScrollView(
    //             slivers: [
    //               SliverToBoxAdapter(
    //                 child: Column(
    //                   children: this.items.map((e) => Text(e)).toList(),
    //                 ),
    //               )
    //               // ListView(
    //               //   controller: _scrollController,
    //               //   children: this.items.map((e) => Text(e)).toList(),
    //               // ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       // child: Scaffold(
    //       //   appBar: AppBar(
    //       //     flexibleSpace: Column(
    //       //       mainAxisAlignment: MainAxisAlignment.end,
    //       //       children: [
    //       //         TabBar(
    //       //           tabs: this.myTabs,
    //       //           isScrollable: true,
    //       //         )
    //       //       ],
    //       //     ),
    //       //   ),
    //       //   body: Container(
    //       //     // child: Icon(Icons.flight, size: 350),
    //       //     child: ListView(
    //       //       children: this.items.map((e) => Text(e)).toList(),
    //       //     ),
    //       //   ),
    //       // body: TabBarView(
    //       //   children: this.myTabs.map((e) => Text(e.text)).toList(),
    //       // ),
    //     ),
    //   ),
    // );

    // return SafeArea(
    //   child: DefaultTabController(
    //     length: 5,
    //     child: NestedScrollView(
    //       headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //         return <Widget>[
    //           new SliverAppBar(
    //             pinned: true,
    //             floating: true,
    //             flexibleSpace: Container(
    //               child: Padding(
    //                 padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    //                 child: Container(
    //                   color: Colors.black,
    //                   width: 100.0,
    //                   child: Text("ASD"),
    //                 ),
    //               ),
    //             ),
    //             bottom: TabBar(
    //               isScrollable: true,
    //               tabs: [
    //                 Tab(
    //                   child: Text('Flight'),
    //                 ),
    //                 Tab(
    //                   child: Text('Train'),
    //                 ),
    //                 Tab(
    //                   child: Text('Car'),
    //                 ),
    //                 Tab(
    //                   child: Text('Cycle'),
    //                 ),
    //                 Tab(
    //                   child: Text('Boat'),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ];
    //       },
    //       body: TabBarView(
    //         children: <Widget>[
    //           Icon(Icons.flight, size: 350),
    //           Icon(Icons.directions_transit, size: 350),
    //           Icon(Icons.directions_car, size: 350),
    //           Icon(Icons.directions_bike, size: 350),
    //           Icon(Icons.directions_boat, size: 350),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    // return DefaultTabController(
    //   length: myTabs.length,
    //   child: Scaffold(
    //     // appBar: AppBar(
    //     //   bottom: TabBar(
    //     //     isScrollable: true,
    //     //     tabs: myTabs,
    //     //   ),
    //     // ),
    //     body: TabBarView(
    //       children: myTabs.map((Tab tab) {
    //         return ListView.builder(
    //           itemCount: items.length,
    //           itemBuilder: (context, index) {
    //             return ListTile(
    //               title: Text(items[index]),
    //             );
    //           },
    //         );
    //       }).toList(),
    //     ),
    //   ),
    // );
  }

  List _buildList(int count) {
    List<Widget> listItems = List();

    for (int i = 0; i < count; i++) {
      listItems.add(new Padding(padding: new EdgeInsets.all(20.0), child: new Text('Item ${i.toString()}', style: new TextStyle(fontSize: 25.0))));
    }

    return listItems;
  }

  SliverPersistentHeader buildSliverHeader(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverDelegate(
        child: Column(
          children: [
            Center(
              child: InkWell(
                onTap: () => print("Hello :)"),
                child: Container(
                  height: 60,
                  width: 1170,
                  color: Theme.of(context).accentColor,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 5),
                  child: Container(
                    // decoration: BoxDecoration(
                    //   color: ColorResources.getSearchBg(context),
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    child: TabBar(
                      tabs: this.myTabs,
                      isScrollable: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
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
                          image: splash.baseUrls != null ? '${splash.baseUrls.ecommerceImageUrl}/${splash.configModel.ecommerceLogo}' : '',
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
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  double minMax = 60;
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => this.minMax;

  @override
  double get minExtent => this.minMax;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != this.minExtent || oldDelegate.minExtent != this.maxExtent || child != oldDelegate.child;
  }
}

class CustomSliverAppbar extends StatefulWidget {
  @override
  _CustomSliverAppbarState createState() => _CustomSliverAppbarState();
}

class _CustomSliverAppbarState extends State<CustomSliverAppbar> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            buildSliverAppBar(context),
            // buildSliverHeader(context),
            // SliverAppBar(
            //   title: Text(
            //     "WhatsApp type sliver appbar",
            //   ),
            //   centerTitle: true,
            //   pinned: true,
            //   floating: true,
            //   bottom: TabBar(
            //       indicatorColor: Colors.black,
            //       labelPadding: const EdgeInsets.only(
            //         bottom: 16,
            //       ),
            //       controller: _tabController,
            //       tabs: [
            //         Text("TAB A"),
            //         Text("TAB B"),
            //       ]),
            // ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            TabA(),
            const Center(
              child: Text('Display Tab 2', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      centerTitle: false,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).accentColor,
      pinned: true,
      leading: ResponsiveHelper.isTab(context)
          ? IconButton(
              onPressed: () => this.drawerGlobalKey.currentState.openDrawer(),
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
                          image: splash.baseUrls != null ? '${splash.baseUrls.ecommerceImageUrl}/${splash.configModel.ecommerceLogo}' : '',
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
      bottom: TabBar(
          indicatorColor: Colors.black,
          labelPadding: EdgeInsets.only(
            bottom: 16,
          ),
          controller: _tabController,
          tabs: [
            Text("TAB A"),
            Text("TAB B"),
          ]),
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
    );
  }

  SliverPersistentHeader buildSliverHeader(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverDelegate(
        child: Column(
          children: [
            Center(
              child: InkWell(
                onTap: () => print("Hello :)"),
                child: Container(
                  height: 60,
                  width: 1170,
                  color: Theme.of(context).accentColor,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 5),
                  child: Container(
                    // decoration: BoxDecoration(
                    //   color: ColorResources.getSearchBg(context),
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    child: TabBar(
                        indicatorColor: Colors.black,
                        labelPadding: const EdgeInsets.only(
                          bottom: 16,
                        ),
                        controller: _tabController,
                        tabs: [
                          Text("TAB A"),
                          Text("TAB B"),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (context, child) => Divider(
          height: 1,
        ),
        padding: EdgeInsets.all(0.0),
        itemCount: 30,
        itemBuilder: (context, i) {
          return Container(
            height: 100,
            width: double.infinity,
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          );
        },
      ),
    );
  }
}
