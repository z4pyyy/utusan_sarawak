import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/common/top_app_bar.dart';
import 'package:utusan_sarawak/components/common/bottom_nav_bar.dart';
import 'package:utusan_sarawak/components/profile_page/profile_main.dart';
import 'package:utusan_sarawak/components/reward_detail_page/reward_detail_main.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class RewardDetailPage extends StatefulWidget {
  const RewardDetailPage({
    Key? key,
    required this.rewardId,
  }) : super(key: key);

  final int rewardId;

  @override
  State<RewardDetailPage> createState() => RewardDetailPageState();
}

class RewardDetailPageState extends State<RewardDetailPage> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return Scaffold(
      backgroundColor: themeOptions.backgroundColor,
      appBar: TopAppBar(width: MediaQuery.of(context).size.width,),
      body: RewardDetailMain(rewardId: widget.rewardId,),
      bottomNavigationBar: const BottomNavBar(index: 2,),
    );
  }
}
