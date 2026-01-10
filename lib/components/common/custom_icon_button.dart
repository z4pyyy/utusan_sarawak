import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';

class CustomIconButton extends StatelessWidget {
  final double size;
  final IconData icon;
  final VoidCallback onPressed;
  final bool hide;

  const CustomIconButton({
    Key? key,
    required this.size,
    required this.icon,
    required this.onPressed,
    this.hide = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return SizedBox(
      child: IconButton(
        color: hide
            ? Colors.white.withOpacity(0)
            : themeOptions.iconColor,
        icon: Icon(
          icon,
          size: size,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
