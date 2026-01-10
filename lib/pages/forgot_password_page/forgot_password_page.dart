import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/forgot_password_page/forgot_password_app_bar.dart';
import 'package:utusan_sarawak/components/forgot_password_page/forgot_password_main.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return Scaffold(
      backgroundColor: themeOptions.backgroundColor,
      appBar: ForgotPasswordAppBar(width: MediaQuery.of(context).size.width),
      body: const ForgotPasswordMain(),
    );
  }
}
