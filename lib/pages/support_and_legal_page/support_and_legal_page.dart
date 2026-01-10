import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/signup_page/signup_app_bar.dart';
import 'package:utusan_sarawak/components/support_and_legal_page/support_and_legal_main.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class SupportAndLegalPage extends StatefulWidget {
  const SupportAndLegalPage({Key? key}) : super(key: key);

  @override
  State<SupportAndLegalPage> createState() => SupportAndLegalPageState();
}

class SupportAndLegalPageState extends State<SupportAndLegalPage> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return Scaffold(
      backgroundColor: themeOptions.secondaryBackgroundColor,
      appBar: SignupAppBar(width: MediaQuery.of(context).size.width, title: "Sokongan aplikasi",),
      body: const SupportAndLegalMain(),
    );
  }
}
