import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/components/common/custom_icon_button.dart';
import 'package:utusan_sarawak/components/common/logo_image.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class SignupAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SignupAppBar({
    Key? key,
    required this.width,
    this.title,
    this.shadow = true,
  }) : super(key: key);

  final double height = 70;
  final double width;
  final String? title;
  final bool? shadow;

  @override
  State<SignupAppBar> createState() => SignupAppBarState();

  @override
  Size get preferredSize => Size(width, height);
}

class SignupAppBarState extends State<SignupAppBar> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final beamer = Beamer.of(context);
    final user = GetIt.I<User>();
    return SafeArea(
      child: PreferredSize(
        preferredSize: Size.fromHeight(widget.height),
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            boxShadow: widget.shadow!
                ? const [
                    BoxShadow(
                        color: Color.fromRGBO(210, 210, 210, 1.0),
                        spreadRadius: 0,
                        blurRadius: 10),
                  ]
                : null,
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
                if(widget.title != null)
                  Text(
                    widget.title!,
                    style: TextStyle(
                        fontSize: user.textSizeScale * themeOptions.appBarTextSize,
                        fontWeight: FontWeight.w500),
                  ),
                if(widget.title == null)
                  LogoImage(
                      width: widget.width*0.5
                  ),
                CustomIconButton(
                  icon: Icons.arrow_back_ios_new,
                  size: 30,
                  onPressed: (){},
                  hide: true,
                ),
              ]
          ),
        ),
      ),
    );
  }
}
