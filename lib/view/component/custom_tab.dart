import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  CustomTabBar({
    this.controller,
    this.tabs,
  });
  final Function(TabController) controller;
  final List<Tab> tabs;

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.tabs.length, vsync: this);
    if (widget.controller != null) {
      widget.controller(tabController);
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("This also rebuild??");
    return TabBar(
      tabs: widget?.tabs ?? [],
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: Theme.of(context).primaryColor,
      labelColor: Theme.of(context).textTheme.bodyText1.color,
      isScrollable: true,
      controller: tabController,
    );
  }
}
