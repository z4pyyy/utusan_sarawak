import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utusan_sarawak/components/common/custom_divider.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/services/api_service.dart';
import 'package:utusan_sarawak/stores/ads_store/ads_store.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';

class AdsCard extends StatefulWidget{
  const AdsCard({Key? key, this.dividerAbove = false, required this.marginTop}) : super(key: key);

  final bool dividerAbove;
  final double marginTop;

  @override
  State<AdsCard> createState() => AdsCardState();
}

class AdsCardState extends State<AdsCard>{
  final adsStore = GetIt.I<AdsStore>();
  var _currentCarouselIndex = 0;

  late Future<List<Map<String, String>>> future;

  Future<void> _launchUrl(String stringUrl) async {
    final Uri url = Uri.parse(stringUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget blankAds(User user, ThemeOptions themeOptions){
    return Column(
      children: [
        if(widget.dividerAbove)
          const CustomDivider(),
        VerticalWhiteSpace(height: widget.marginTop),
        Text(
          "[ Advertisement ]",
          style: TextStyle(
              fontSize: user.textSizeScale * themeOptions.textSize3,
              color: themeOptions.secondaryColor),
        ),
        const VerticalWhiteSpace(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: null,
            child: Image.asset("assets/image/grey_background.jpg", fit: BoxFit.fill),
          ),
        ),
        const VerticalWhiteSpace(height: 20),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    future = adsStore.getAdsListPartial();
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
          return const SizedBox(
            height: 400,
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            List<Map<String, String>> data = snapshot.data!;
            if(data.isNotEmpty) {
              return Column(
                children: [
                  if(widget.dividerAbove)
                    const CustomDivider(),
                  VerticalWhiteSpace(height: widget.marginTop),
                  Text(
                    "[ Advertisement ]",
                    style: TextStyle(
                        fontSize: user.textSizeScale * themeOptions.textSize3,
                        color: themeOptions.secondaryColor),
                  ),
                  const VerticalWhiteSpace(height: 5),
                  CarouselSlider(
                    items: List.generate(data.length, (index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () async {
                            final data = snapshot.data!;
                            apiService.adsClick({"ads_id": data[index]["id"]});
                            await _launchUrl(data[index]["url"]!);
                          },
                          child: Image.memory(
                            base64Decode(data[index]["image"]!),
                            fit: BoxFit.fill,
                            gaplessPlayback: true,
                          ),
                        ),
                      );
                    }),
                    options: CarouselOptions(
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentCarouselIndex = index;
                        });
                      },
                      autoPlay: true,
                      autoPlayInterval: const Duration(milliseconds: 8000),
                      autoPlayAnimationDuration: const Duration(
                          milliseconds: 1500),
                      clipBehavior: Clip.antiAlias,
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(data.length, (index) {
                        return Container(
                          width: 10.0,
                          height: 10.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentCarouselIndex == index
                                ? const Color.fromRGBO(0, 0, 0, 0.6)
                                : const Color.fromRGBO(0, 0, 0, 0.2),
                          ),
                        );
                      })
                  ),
                  const VerticalWhiteSpace(height: 20),
                ],
              );
            }else{
              return blankAds(user, themeOptions);
            }
          }else{
            return blankAds(user, themeOptions);
          }
        }

        if(snapshot.hasError){
          // print("----------- SNAPSHOT HAS ERROR: ${snapshot.error}");
        }

        return blankAds(user, themeOptions);
      }
    );
    
  }
}
