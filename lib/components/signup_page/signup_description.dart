import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/components/common/horizontal_white_space.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';

class SignupDescription extends StatelessWidget {
  const SignupDescription({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(user.textSizeScale <= 1.2)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sudah mempunyai akaun? ",
                style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize2,),
              ),
              InkWell(
                onTap: (){
                  customBeamToNamed(context, 0.0, "/signin");
                },
                child: Text(
                  "Daftar Masuk",
                  style: TextStyle(
                    fontSize: user.textSizeScale * themeOptions.textSize2,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        if(user.textSizeScale > 1.2)
          Text(
            "Already have an account? ",
            style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize2,),
          ),
        if(user.textSizeScale > 1.2)
          InkWell(
            onTap: (){
              customBeamToNamed(context, 0.0, "/signin");
            },
            child: Text(
              "Daftar Masuk",
              style: TextStyle(
                fontSize: user.textSizeScale * themeOptions.textSize2,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        const VerticalWhiteSpace(height: 15),
        Text(
          "Berita Utusan Sarawak",
          style: TextStyle(
            fontSize: user.textSizeScale * themeOptions.textTitleSize1,
            fontWeight: FontWeight.w500,
          ),
        ),
        const VerticalWhiteSpace(height: 5),
        Text(
          "Akses tanpa had kepada berita yang tidak berat sebelah",
          style: TextStyle(
            fontSize: user.textSizeScale * themeOptions.textSize2,
            fontWeight: FontWeight.w500,
          ),
        ),
        const VerticalWhiteSpace(height: 10),
        Text(
          "Daftar percuma di aplikasi Utusan Sarawak memberi anda:",
          style: TextStyle(
            fontSize: user.textSizeScale * themeOptions.textSize2,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
        const VerticalWhiteSpace(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle_rounded, size: 28, color: themeOptions.successColor,),
            const HorizontalWhiteSpace(width: 20,),
            Expanded(
              child: Text(
                "Akses tanpa had kepada berita Utusan Sarawak",
                style: TextStyle(
                  fontSize: user.textSizeScale * themeOptions.textSize2,
                ),
              ),
            ),
          ],
        ),
        const VerticalWhiteSpace(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle_rounded, size: 28, color: themeOptions.successColor,),
            const HorizontalWhiteSpace(width: 20,),
            Expanded(
              child: Text(
                "Berita tertumpu industri, penghantaran ke peti masuk anda",
                style: TextStyle(
                  fontSize: user.textSizeScale * themeOptions.textSize2,
                ),
              ),
            ),
          ],
        ),
        const VerticalWhiteSpace(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle_rounded, size: 28, color: themeOptions.successColor,),
            const HorizontalWhiteSpace(width: 20,),
            Expanded(
              child: Text(
                "Berita di hujung jari anda, dengan aplikasi Utusan Sarawak",
                style: TextStyle(
                  fontSize: user.textSizeScale * themeOptions.textSize2,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
