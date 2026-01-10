import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/signup_page/signup_app_bar.dart';
import 'package:utusan_sarawak/components/signup_page/signup_main.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeOptions.backgroundColor,
      appBar: SignupAppBar(width: MediaQuery.of(context).size.width,),
      body: const SignupMain(),
    );
  }
}
