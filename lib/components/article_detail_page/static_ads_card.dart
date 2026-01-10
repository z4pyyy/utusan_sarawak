import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/services/api_service.dart';
import 'package:utusan_sarawak/stores/ads_store/ads_store.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';

class StaticAdsCard extends StatefulWidget{
  const StaticAdsCard({Key? key, this.dividerAbove = false}) : super(key: key);

  final bool dividerAbove;

  @override
  State<StaticAdsCard> createState() => StaticAdsCardState();
}

class StaticAdsCardState extends State<StaticAdsCard>{
  final adsStore = GetIt.I<AdsStore>();

  late Future<Map<String, String>> future;

  Future<void> _launchUrl(String stringUrl) async {
    final Uri url = Uri.parse(stringUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    super.initState();
    future = adsStore.getNextStaticAds();
  }

  @override
  Widget build(BuildContext context) {
    final user = GetIt.I<User>();
    final apiService = GetIt.I<ApiService>();
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return FutureBuilder(
        future: future,
        builder: (context, snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){
            return const SizedBox();
            // return const SizedBox(
            //   height: 400,
            //   width: double.infinity,
            //   child: Center(
            //     child: CircularProgressIndicator(),
            //   ),
            // );
          }

          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              Map<String, String> data = snapshot.data!;
              if(data.isNotEmpty) {
                return Column(
                  children: [
                    Text(
                      "[ Sponsored Content ]",
                      style: TextStyle(
                          fontSize: user.textSizeScale * themeOptions.textSize3,
                          color: themeOptions.secondaryColor),
                    ),
                    const VerticalWhiteSpace(height: 5),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(210, 210, 210, 0.5),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(data["image"] != null)
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.memory(
                                base64Decode(data["image"]!),
                                width: double.infinity,
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                              ),
                            ),
                          const VerticalWhiteSpace(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              data["title"]!,
                              style: TextStyle(
                                fontSize: themeOptions.textSize2 * user.textSizeScale,
                                fontWeight: FontWeight.w500,
                                color: themeOptions.textColor,
                              ),
                            ),
                          ),
                          const VerticalWhiteSpace(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              data["description"]!,
                              style: TextStyle(
                                fontSize: themeOptions.textSize4 * user.textSizeScale,
                                color: themeOptions.textColor,
                              ),
                            ),
                          ),
                          const VerticalWhiteSpace(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextButton(
                              onPressed: () async {
                                apiService.staticAdsClick({"ads_id": data["id"]});
                                await _launchUrl(data["url"]!);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                "Read More",
                                style: TextStyle(
                                  color: themeOptions.urlTextColor,
                                  fontSize: themeOptions.textSize4 * user.textSizeScale,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }else{
                return const SizedBox();
              }
            }else{
              return const SizedBox();
            }
          }

          if(snapshot.hasError){
            // print("----------- SNAPSHOT HAS ERROR: ${snapshot.error}");
          }

          return const SizedBox();
        }
    );

  }
}
