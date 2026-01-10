import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';

class AccountDetailRow extends StatelessWidget {
  const AccountDetailRow({Key? key, required this.label, required this.value,}) : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: user.textSizeScale * themeOptions.textSize2,
            color: themeOptions.secondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize2,),
        ),
      ],
    );
  }
}
