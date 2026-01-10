import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';

class BlockContainer extends StatelessWidget {
  const BlockContainer({Key? key, required this.child,}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
              color: themeOptions.secondaryColor,
              width: 0.3),
        ),
        color: themeOptions.whiteBackground,
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: child,
    );
  }
}
