import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class RewardCard extends StatefulWidget {
  const RewardCard({
    Key? key,
    required this.reward,
  }) : super(key: key);

  final Map<String, dynamic> reward;

  @override
  State<RewardCard> createState() => RewardCardState();
}

class RewardCardState extends State<RewardCard> {

  @override
  void initState(){
    super.initState();
    String fromWritable = widget.reward["banner_image"].substring(widget.reward["banner_image"].indexOf('uploads'));
    widget.reward["banner_image"] = fromWritable;
  }


  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();
    final beamer = Beamer.of(context);
    const imageUrl = "https://utusansarawak.com.my/ads-cms";

    return InkWell(
      onTap: (){
        beamer.beamToNamed("/reward-detail/${widget.reward["id"]}");
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                "$imageUrl/public/${widget.reward["banner_image"]}" ?? "assets/image/grey_background.jpg",
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                widget.reward["title"] ?? "",
                style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize2, fontWeight: FontWeight.w500,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 15),
              child: Text(
                widget.reward["company"] ?? "",
                style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize5, color: const Color.fromRGBO(0, 0, 0, 0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


