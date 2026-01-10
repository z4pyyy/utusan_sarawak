import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/signup_page/signup_app_bar.dart';
import 'package:utusan_sarawak/components/test_size_page/text_size_main.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class TextSizePage extends StatefulWidget {
  const TextSizePage({Key? key}) : super(key: key);

  @override
  State<TextSizePage> createState() => TextSizePageState();
}

class TextSizePageState extends State<TextSizePage> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return Scaffold(
      backgroundColor: themeOptions.secondaryBackgroundColor,
      appBar: SignupAppBar(width: MediaQuery.of(context).size.width, title: "Saiz Teks",),
      body: const TextSizeMain(),
    );
  }
}
