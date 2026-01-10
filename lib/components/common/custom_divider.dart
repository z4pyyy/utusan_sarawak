import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return Divider(
      thickness: 0.5,
      color: themeOptions.secondaryColor,
    );
  }
}
