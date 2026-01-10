import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/common/custom_icon_button.dart';
import 'package:utusan_sarawak/components/common/logo_image.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class ForgotPasswordAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ForgotPasswordAppBar({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double height = 70;
  final double width;

  @override
  State<ForgotPasswordAppBar> createState() => ForgotPasswordAppBarState();

  @override
  Size get preferredSize => Size(width, height);
}

class ForgotPasswordAppBarState extends State<ForgotPasswordAppBar> {

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
                  icon: Icons.arrow_back_ios_new,
                  size: 30,
                  onPressed: (){
                    beamer.beamBack();
                  },
                ),
                LogoImage(
                    width: widget.width*0.5
                ),
                CustomIconButton(
                  icon: Icons.arrow_back_ios,
                  size: 30,
                  onPressed: () {},
                  hide: true,
                ),
              ]
          ),
        ),
      ),
    );
  }
}
