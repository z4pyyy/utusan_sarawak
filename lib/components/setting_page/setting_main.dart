import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/components/common/horizontal_white_space.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';

class SettingMain extends StatefulWidget {
  const SettingMain({Key? key}) : super(key: key);

  @override
  State<SettingMain> createState() => SettingMainState();
}

class SettingMainState extends State<SettingMain> {
  bool appData = false;

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final beamer = Beamer.of(context);
    final user = GetIt.I<User>();

    final MaterialStateProperty<Color?> trackColor =
    MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return themeOptions.primaryColor;
        }

        return null;
      },
    );

    final MaterialStateProperty<Color?> overlayColor =
    MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        // Material color when switch is selected.
        if (states.contains(MaterialState.selected)) {
          return themeOptions.primaryColor;
        }
        // Material color when switch is disabled.
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey.shade400;
        }
        // Otherwise return null to set default material color
        // for remaining states such as when the switch is
        // hovered, or focused.
        return null;
      },
    );

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0)
        ),
      ),
      height: MediaQuery.of(context).size.height*0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 60,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)
              ),
              color: themeOptions.primaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Blank",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0),
                  ),
                ),
                Text(
                  "Aturan",
                  style: TextStyle(
                    fontSize: user.textSizeScale * themeOptions.textSize1,
                    fontWeight: FontWeight.w500,
                    color: themeOptions.textColorOnPrimary
                  ),
                ),
                InkWell(
                  onTap: (){
                    beamer.popRoute();
                  },
                  child: Text(
                    "Tutup",
                    style: TextStyle(
                        fontSize: user.textSizeScale * themeOptions.textSize2,
                        color: themeOptions.textColorOnPrimary
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalWhiteSpace(height: 30),
          Container(
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
            child: Text(
              "Pemberitahuan",
              style: TextStyle(
                fontSize: user.textSizeScale * themeOptions.textSize2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "Pergi ke tetapan peranti anda untuk menghidupkan atau mematikan pemberitahuan",
              style: TextStyle(
                fontSize: user.textSizeScale * themeOptions.textSize4,
                color: themeOptions.iconColor,
                height: 1.2,
              ),
            ),
          ),
          const VerticalWhiteSpace(height: 30),
          Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                    color: themeOptions.secondaryColor,
                    width: 0.3),
              ),
              color: themeOptions.whiteBackground,
            ),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hantar statistic aplikasi",
                  style: TextStyle(
                    fontSize: user.textSizeScale * themeOptions.textSize2,
                  ),
                ),
                Switch(
                  value: appData,
                  trackColor: trackColor,
                  overlayColor: overlayColor,
                  thumbColor: const MaterialStatePropertyAll<Color>(Colors.black),
                  onChanged: (bool value){
                    setState(() {
                      appData = value;
                    });
                  },
                ),
              ],
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "Utusan Sarawak hanya akan menggunakan maklumat ini untuk menganalisis dan menambah baik "
                  "perkhidmatan yang ditawarkan melalui aplikasi ini. Untuk maklumat lanjut, "
                  "lihat dasar privasi kami",
              style: TextStyle(
                fontSize: user.textSizeScale * themeOptions.textSize4,
                color: themeOptions.iconColor,
                height: 1.2,
              ),
            ),
          ),
          // const VerticalWhiteSpace(height: 30),
          // Container(
          //     decoration: BoxDecoration(
          //       border: Border(
          //         bottom: BorderSide(
          //             color: themeOptions.secondaryColor,
          //             width: 0.3),
          //       ),
          //       color: themeOptions.whiteBackground,
          //     ),
          //     width: double.infinity,
          //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           "Contact us",
          //           style: TextStyle(
          //             fontSize: user.textSizeScale * themeOptions.textSize2,
          //           ),
          //         ),
          //         Icon(
          //           Icons.keyboard_arrow_right,
          //           color: themeOptions.iconColor,
          //           size: 30,
          //         ),
          //       ],
          //     )
          // ),

          const VerticalWhiteSpace(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: themeOptions.primaryColor,
                height: 55,
                width: 60,
                child: Center(
                  child: Text(
                    "Logo",
                    style: TextStyle(
                      fontSize: user.textSizeScale * themeOptions.textSize2,
                      fontWeight: FontWeight.w500,
                      color: themeOptions.textColorOnPrimary),
                  ),
                ),
              ),
              const HorizontalWhiteSpace(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Versi", style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize2, fontWeight: FontWeight.w500),),
                  const VerticalWhiteSpace(height: 5),
                  Text("2024.12.10 (1)", style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize3),),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
