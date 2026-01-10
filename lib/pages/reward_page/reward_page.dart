import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/common/tab_generator.dart';
import 'package:utusan_sarawak/components/common/bottom_nav_bar.dart';
import 'package:utusan_sarawak/components/common/top_app_bar.dart';
import 'package:utusan_sarawak/components/common/top_app_bar_with_tab.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({Key? key}) : super(key: key);

  @override
  State<RewardPage> createState() => RewardPageState();
}

class RewardPageState extends State<RewardPage> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final tabs = getRewardTabs();
    final tabViews = getRewardTabViews();

    if (tabs.isEmpty) {
      return Scaffold(
        backgroundColor: themeOptions.backgroundColor,
        appBar: TopAppBar(width: MediaQuery.of(context).size.width, isMain: true, shadow: false,),
        body: const Center(child: Text("Tiada ganjaran tersedia")),
        bottomNavigationBar: const BottomNavBar(index: 2),
      );
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: themeOptions.backgroundColor,
        appBar: TopAppBarWithTab(width: MediaQuery.of(context).size.width, isReward: true),
        body: TabBarView(children: tabViews),
        bottomNavigationBar: const BottomNavBar(index: 2),
      ),
    );
  }
}
