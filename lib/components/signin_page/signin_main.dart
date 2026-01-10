import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/components/common/custom_divider.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/components/signin_page/signin_card.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';

class SigninMain extends StatefulWidget {
  const SigninMain({Key? key}) : super(key: key);

  @override
  State<SigninMain> createState() => SigninMainState();
}

class SigninMainState extends State<SigninMain> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selamat datang",
            style: TextStyle(
              fontSize: user.textSizeScale * themeOptions.textTitleSize1,
              fontWeight: FontWeight.w500,
            ),
          ),
          const VerticalWhiteSpace(height: 5),
          Text(
            "Masukkan alamat e-mel dan kata laluan anda untuk daftar masuk ke aplikasi Utusan Sarawak anda.",
            style: TextStyle(
              fontSize: user.textSizeScale * themeOptions.textSize2,
              height: 1.3,
            ),
          ),
          const VerticalWhiteSpace(height: 5),
          const CustomDivider(),
          const VerticalWhiteSpace(height: 5),
          Text(
            "Belum mempunyai akaun?",
            style: TextStyle(
              fontSize: user.textSizeScale * themeOptions.textSize2,
            ),
          ),
          const VerticalWhiteSpace(height: 10),
          InkWell(
            onTap: (){
              customBeamToNamed(context, 0.0, "/signup");
            },
            child: Text(
              "Daftar di sini",
              style: TextStyle(
                fontSize: user.textSizeScale * themeOptions.textSize2,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const VerticalWhiteSpace(height: 30),
          const SigninCard(),
          const VerticalWhiteSpace(height: 60),
        ],
      )
    );
  }
}
