import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/signin_page/signin_app_bar.dart';
import 'package:utusan_sarawak/components/signin_page/signin_main.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => SigninPageState();
}

class SigninPageState extends State<SigninPage> {

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return Scaffold(
      backgroundColor: _themeOptions.backgroundColor,
      appBar: SigninAppBar(width: MediaQuery.of(context).size.width),
      body: const SigninMain(),
    );
  }
}
