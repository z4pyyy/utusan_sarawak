import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/common/bottom_nav_bar.dart';
import 'package:utusan_sarawak/components/common/tab_generator.dart';
import 'package:utusan_sarawak/components/common/top_app_bar_with_tab.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:utusan_sarawak/utils/custom_upgrader_messages.dart';

class TopStoryPage extends StatefulWidget {
  const TopStoryPage({Key? key}) : super(key: key);

  @override
  State<TopStoryPage> createState() => _TopStoryPageState();
}

class _TopStoryPageState extends State<TopStoryPage> {

  // Future<void> initializeUpgrader() async{
  //   Upgrader upgrader = Upgrader();
  //   await upgrader.initialize();
  //
  //   print("Current Installed version: ${upgrader.currentInstalledVersion}");
  //   print("Current App Store version: ${upgrader.currentAppStoreVersion}");
  // }
  //
  // @override
  // void initState(){
  //   super.initState();
  //   initializeUpgrader();
  // }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    int tabLength = getTabs().length;
    return DefaultTabController(
      length: tabLength,
      child: UpgradeAlert(
        upgrader: Upgrader(
          languageCode: 'en',
          durationUntilAlertAgain: const Duration(hours: 48),
          messages: CustomUpgradeMessages(),
        ),
        showIgnore: false,
        showReleaseNotes: false,
        child: Scaffold(
          backgroundColor: themeOptions.backgroundColor,
          appBar: TopAppBarWithTab(width: MediaQuery.of(context).size.width,),
          body: TabBarView(
            children: getTabViews(),
          ),
          bottomNavigationBar: const BottomNavBar(index: 0,),
        ),
      ),
    );
  }
}
