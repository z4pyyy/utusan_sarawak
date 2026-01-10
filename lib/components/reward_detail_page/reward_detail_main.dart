import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utusan_sarawak/components/common/horizontal_white_space.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/stores/reward_store/reward_store.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class RewardDetailMain extends StatefulWidget {
  const RewardDetailMain({
    Key? key,
    required this.rewardId,
  }) : super(key: key);

  final int rewardId;

  @override
  State<RewardDetailMain> createState() => RewardDetailMainState();
}

class RewardDetailMainState extends State<RewardDetailMain> {
  late Map<String, dynamic> reward;

  List<dynamic> tncList = [];

  String formatOfferPeriod(String start, String end) {
    try {
      DateTime startDate = DateTime.parse(start);
      DateTime endDate = DateTime.parse(end);

      final formatter = DateFormat('d MMMM yyyy');
      return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
    } catch (e) {
      return ''; // fallback in case of parse failure
    }
  }

  @override
  void initState(){
    super.initState();
    RewardStore rewardStore = GetIt.I<RewardStore>();
    List<Map<String, dynamic>> rewardList = rewardStore.rewardList;
    reward = rewardList.firstWhere(
      (e) => e.containsKey("id") && e["id"].toString() == widget.rewardId.toString(),
      orElse: (){
        return {};
      }
    );

    if (reward["tnc"] != null) {
      try {
        tncList = json.decode(reward["tnc"]);
      } catch (e) {
        print("Failed to parse T&C JSON: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();
    const imageUrl = "https://utusansarawak.com.my/ads-cms/public/";

    Widget paddingText(String txt, double bottomPadding, {TextStyle style = const TextStyle()}){
      return Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Text(
          txt,
          style: style,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            height: 300,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    "$imageUrl${reward["cover_image"].substring(reward["cover_image"].indexOf('uploads'))}",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 275,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  ),
                ),


              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                paddingText(
                  reward["title"] ?? "",
                  5,
                  style: TextStyle(
                    fontSize: user.textSizeScale * themeOptions.textSize1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                paddingText(
                  "Offer by: ${reward["company"] ?? ""}",
                  20,
                  style: TextStyle(
                    fontSize: user.textSizeScale * themeOptions.textSize5,
                    color: const Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.network(
                    "$imageUrl${reward["company_logo"].substring(reward["company_logo"].indexOf('uploads'))}",
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const VerticalWhiteSpace(height: 30),
                paddingText(
                  reward["description"] ?? "",
                  30,
                  style: TextStyle(
                    fontSize: user.textSizeScale * themeOptions.textSize3,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.network(
                    "$imageUrl${reward["banner_image"].substring(reward["banner_image"].indexOf('uploads'))}",
                    fit: BoxFit.cover,
                  ),
                ),
                const VerticalWhiteSpace(height: 30),
                paddingText(
                  reward["how_to_redeem"] ?? "",
                  20,
                  style: TextStyle(
                    fontSize: user.textSizeScale * themeOptions.textSize3,
                  ),
                ),
                paddingText(
                  "Offer Period: ${formatOfferPeriod(reward["start_date"], reward["end_date"])}",
                  20,
                  style: TextStyle(
                    fontSize: user.textSizeScale * themeOptions.textSize3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 40),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(210, 210, 210, 0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: themeOptions.primaryColorLight.withOpacity(0.35),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Terms & Conditions", style: TextStyle(
                          fontSize: user.textSizeScale * themeOptions.textSize3,
                          fontWeight: FontWeight.w500,
                        )),
                        const VerticalWhiteSpace(height: 10),
                        ...tncList.map<Widget>((txt) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("• "),
                            Expanded(child: Text(txt,
                                style: TextStyle(
                                  fontSize: user.textSizeScale * themeOptions.textSize4,
                                )
                            )),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(210, 210, 210, 0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reward["company"], style: TextStyle(
                        fontSize: user.textSizeScale * themeOptions.textSize3,
                        fontWeight: FontWeight.w500,
                      )),
                      const VerticalWhiteSpace(height: 5),
                      Text(reward["company_desc"], style: TextStyle(
                        fontSize: user.textSizeScale * themeOptions.textSize4,
                      )),
                      const VerticalWhiteSpace(height: 25),
                      Text("Address", style: TextStyle(
                        fontSize: user.textSizeScale * themeOptions.textSize3,
                        fontWeight: FontWeight.w500,
                      )),
                      const VerticalWhiteSpace(height: 5),
                      Text(reward["company_address"], style: TextStyle(
                        fontSize: user.textSizeScale * themeOptions.textSize4,
                      )),
                      const VerticalWhiteSpace(height: 15),
                      Row(
                        children: [
                          if(reward.containsKey("company_phone"))
                            if(reward["company_phone"] != null && reward["company_phone"] != "" )...[
                              InkWell(
                                onTap: () async {
                                  final Uri phoneUri = Uri(scheme: 'tel', path: reward["company_phone"]);
                                  if (await canLaunchUrl(phoneUri)) {
                                    await launchUrl(phoneUri, mode: LaunchMode.externalApplication,);
                                  } else {
                                    print('Could not launch dialer');
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text(
                                    "Call",
                                    style: TextStyle(
                                      fontSize: user.textSizeScale * themeOptions.textSize5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const HorizontalWhiteSpace(width: 10),
                            ],

                          if(reward.containsKey("company_email"))
                            if(reward["company_email"] != null && reward["company_email"] != "" )...[
                              InkWell(
                                onTap: () async {
                                  final Uri emailUri = Uri(
                                    scheme: 'mailto',
                                    path: reward["company_email"],
                                  );
                                  if (await canLaunchUrl(emailUri)) {
                                    await launchUrl(emailUri, mode: LaunchMode.externalApplication,);
                                  } else {
                                    print('Could not launch email');
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text(
                                    "E-mail",
                                    style: TextStyle(
                                      fontSize: user.textSizeScale * themeOptions.textSize5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const HorizontalWhiteSpace(width: 10),
                            ],

                          if(reward.containsKey("company_website"))
                            if(reward["company_website"] != null && reward["company_website"] != "" )...[
                              InkWell(
                                onTap: () async {
                                  final Uri webUri = Uri.parse(reward["company_website"]);
                                  if (await canLaunchUrl(webUri)) {
                                    await launchUrl(webUri, mode: LaunchMode.externalApplication,);
                                  } else {
                                    print('Could not launch website');
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text(
                                    "Website",
                                    style: TextStyle(
                                      fontSize: user.textSizeScale * themeOptions.textSize5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const HorizontalWhiteSpace(width: 10),
                            ],

                        ],
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),

        ],
      )
    );


  }
}
