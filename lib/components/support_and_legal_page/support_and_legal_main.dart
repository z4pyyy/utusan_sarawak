import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utusan_sarawak/components/common/block_container.dart';
import 'package:utusan_sarawak/components/common/custom_divider.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class SupportAndLegalMain extends StatefulWidget {
  const SupportAndLegalMain({Key? key}) : super(key: key);

  @override
  State<SupportAndLegalMain> createState() => SupportAndLegalMainState();
}

class SupportAndLegalMainState extends State<SupportAndLegalMain> {

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: themeOptions.secondaryBackgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VerticalWhiteSpace(height: 30),
            BlockContainer(
              child: Column(
                children: [
                  InkWell(
                    onTap: () async{
                      final Uri url = Uri.parse("https://utusansarawak.com.my/terms-and-conditions/");
                      await _launchUrl(url);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Term & syarat",
                          style: TextStyle(
                            fontSize: user.textSizeScale * themeOptions.textSize2,
                            color: themeOptions.textColor,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                  const VerticalWhiteSpace(height: 5),
                  const CustomDivider(),
                  const VerticalWhiteSpace(height: 5),
                  InkWell(
                    onTap: () async{
                      final Uri url = Uri.parse("https://utusansarawak.com.my/disclaimer/");
                      await _launchUrl(url);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dasar Privasi",
                          style: TextStyle(
                            fontSize: user.textSizeScale * themeOptions.textSize2,
                            color: themeOptions.textColor,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                  const VerticalWhiteSpace(height: 5),
                  const CustomDivider(),
                  const VerticalWhiteSpace(height: 5),
                  InkWell(
                    onTap: () async{
                      final Uri url = Uri(
                        scheme: "mailto",
                        path: 'apps@utusansarawak.com.my',
                        queryParameters: {
                          "subject" : "",
                          "body" : ""
                        },
                      );
                      _launchUrl(url);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hubungi Kami",
                          style: TextStyle(
                            fontSize: user.textSizeScale * themeOptions.textSize2,
                            color: themeOptions.textColor,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
