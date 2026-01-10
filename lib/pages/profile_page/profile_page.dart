import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/common/top_app_bar.dart';
import 'package:utusan_sarawak/components/common/bottom_nav_bar.dart';
import 'package:utusan_sarawak/components/profile_page/profile_main.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return Scaffold(
      backgroundColor: themeOptions.secondaryBackgroundColor,
      appBar: TopAppBar(width: MediaQuery.of(context).size.width, isMain: true),
      body: const ProfileMain(),
      bottomNavigationBar: const BottomNavBar(index: 3,),
    );
  }
}
