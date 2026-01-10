import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/common/custom_icon_button.dart';
import 'package:utusan_sarawak/components/common/logo_image.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class SigninAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SigninAppBar({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double height = 70;
  final double width;

  @override
  State<SigninAppBar> createState() => SigninAppBarState();

  @override
  Size get preferredSize => Size(width, height);
}

class SigninAppBarState extends State<SigninAppBar> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final beamer = Beamer.of(context);
    return SafeArea(
      child: PreferredSize(
        preferredSize: Size.fromHeight(widget.height),
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: themeOptions.whiteBackground,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconButton(
                icon: Icons.close,
                size: 30,
                onPressed: (){},
                hide: true,
              ),
              LogoImage(
                  width: widget.width*0.5
              ),
              CustomIconButton(
                icon: Icons.close,
                size: 30,
                onPressed: (){
                  beamer.beamBack();
                },
              ),
            ]
          ),
        ),
      ),
    );
  }
}
