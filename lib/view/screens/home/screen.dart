import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  Screen({
    Key key,
  }) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> with TickerProviderStateMixin {
  TabController _builderPageController;
  List<Widget> _tabs;
  List<Tab> _tabItems;
  int selectedtabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initTabController();
    _setUpTabComponents();
    _preprareTabItems();
  }

  Column _showWidgets() {
    return Column(
      children: [
        Container(
          // your non tab widgets goes here
          height: 300,
          color: Colors.blueAccent,
        ),
        SizedBox(
          height: 10,
        ),
        Material(
          elevation: 3,
          child: TabBar(
            tabs: _tabItems,
            controller: _builderPageController,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.blueAccent,
            indicatorColor: Colors.blueAccent,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
            ),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 12.0),
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Builder(
              builder: (context) {
                return _tabs[selectedtabIndex];
              },
            ))
      ],
    );
  }

  void _initTabController() {
    // inits Tabcontroller for Tabview
    _builderPageController = TabController(
      length: 3,
      vsync: this,
      initialIndex: selectedtabIndex,
    );
    _builderPageController.addListener(() {
      // updated index and calls the set state
      // to switch the content of the tab based on the index clicked
      selectedtabIndex = _builderPageController.index;
      setState(() {
        _builderPageController.index;
      });
    });
  }

  void _setUpTabComponents() {
    // sets up Tab headers
    _tabItems = [
      Tab(child: Text('Tab1')),
      Tab(child: Text('Tab2')),
      Tab(child: Text('Tab3')),
    ];
  }

  List<Widget> _preprareTabItems() {
    // views to show on each tab
    // remove height once you add your contents
    return _tabs = <Widget>[
      Container(
        // first tab content
        height: 400,
        color: Colors.white,
      ),
      Container(
        // second tab content
        height: 600,
        color: Colors.black,
      ),
      Container(
        // third  tab content
        height: 900,
        color: Colors.blue,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _showWidgets());
  }
}
