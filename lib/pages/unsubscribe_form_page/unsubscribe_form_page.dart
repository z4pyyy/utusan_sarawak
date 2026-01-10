import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/common/top_app_bar.dart';
import 'package:utusan_sarawak/components/common/bottom_nav_bar.dart';
import 'package:utusan_sarawak/components/unsubscribe_form_page/unsubscribe_main.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class UnsubscribeFormPage extends StatefulWidget {
  const UnsubscribeFormPage({Key? key}) : super(key: key);

  @override
  State<UnsubscribeFormPage> createState() => _UnsubscribeFormPageState();
}

class _UnsubscribeFormPageState extends State<UnsubscribeFormPage> {
  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return Scaffold(
      backgroundColor: themeOptions.backgroundColor,
      appBar: TopAppBar(width: MediaQuery.of(context).size.width, isMain: true),
      body: const UnsubscribeFormMain(),
      bottomNavigationBar: const BottomNavBar(index: 3,),
    );
  }
}
