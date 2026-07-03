import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:utusan_sarawak/components/common/tab_generator.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/components/common/horizontal_white_space.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/models/article/article.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/image_settings.dart';
import 'package:utusan_sarawak/utils/time_display_formatter.dart';

class SingleArticle extends StatefulWidget{
  const SingleArticle({
    Key? key,
    required this.article,
    required this.isSingleArticle,
    required this.scrollPosition,
    required this.isTab,
    this.isSubTab = false,
    this.parentTabController,
    this.subTabController,
  }) : super(key: key);

  final Article article;
  final bool isSingleArticle;
  final double scrollPosition;
  final bool isTab;
  final bool isSubTab;
  final TabController? parentTabController;
  final TabController? subTabController;

  @override
  State<SingleArticle> createState() => SingleArticleState();
}

class SingleArticleState extends State<SingleArticle> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();
    return InkWell(
      onTap: (){
        if(widget.article.isTagLink){
          List<dynamic> tagDetails = getTagDetails(widget.article);
          var tagId = tagDetails[0];
          var tagName = tagDetails[1];
          customBeamToNamed(context, widget.scrollPosition, "/tag/$tagId/$tagName");
        }else{
          if(widget.isTab){
            TabController tabController = DefaultTabController.of(context);

            if(widget.isSubTab && widget.parentTabController != null){
              customBeamToNamed(
                context, widget.scrollPosition, "/article/${encodeString(widget.article.title)}",
                tabIndex: widget.parentTabController!.index,
                subTabIndex: tabController.index
              );
            }else{
              customBeamToNamed(
                context, widget.scrollPosition, "/article/${encodeString(widget.article.title)}",
                tabIndex: tabController.index
              );
            }

          }else{
            customBeamToNamed(context, widget.scrollPosition, "/article/${encodeString(widget.article.title)}");
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(widget.isSingleArticle)
            Stack(
              children: [
                Image.network(
                  widget.article.imagePath,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Image.asset('assets/image/grey_background.jpg');
                  },
                ),
                if(extractYoutubeUrl(widget.article.content[0]["paragraph"] ?? "") != null)
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white, size: 16),
                          Text("YT", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          if(!widget.isSingleArticle)
            Center(
              child: Stack(
                children: [
                  Image.network(
                    widget.article.imagePath,
                    fit: BoxFit.scaleDown,
                    height: ImageSettings.twoImageHeight,
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return Image.asset('assets/image/grey_background.jpg');
                    },
                  ),
                  if(extractYoutubeUrl(widget.article.content[0]["paragraph"] ?? "") != null)
                    Positioned(
                      top: 4, right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.play_arrow, color: Colors.white, size: 14),
                      ),
                    ),
                ],
              ),
            ),
          const VerticalWhiteSpace(height: 10),
          Text(
            widget.article.title,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: widget.isSingleArticle
                    ? user.textSizeScale * themeOptions.textTitleSize1
                    : user.textSizeScale * themeOptions.textSize1
            ),
          ),
          const VerticalWhiteSpace(height: 10),
          if(widget.isSingleArticle)
            // Text(
            //   "${widget.article.content[0]["paragraph"]}",
            //   style: TextStyle(
            //     fontSize: user.textSizeScale * themeOptions.textSize3,
            //     color: themeOptions.textColor,
            //   ),
            //   textAlign: TextAlign.start,
            //   maxLines: 3,
            //   overflow: TextOverflow.ellipsis,
            // ),
            Html(
              data: widget.article.content[0]["summary"] ?? widget.article.content[0]["paragraph"],
              style: {
                '#': Style(
                  fontSize: FontSize(user.textSizeScale * themeOptions.textSize3),
                  maxLines: 3,
                  textOverflow: TextOverflow.ellipsis,
                  margin: Margins.all(0),
                ),
              },
            ),
          if(widget.isSingleArticle)
            const VerticalWhiteSpace(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: InkWell(
                  onTap: (){
                    if(widget.isTab){
                      TabController tabController = DefaultTabController.of(context);
                      int index = currentTabOrder.indexOf(widget.article.category.toUpperCase());
                      if(index != -1){
                        tabController.animateTo(index);
                      }
                    }else {
                      customBeamToNamed(context, widget.scrollPosition,
                          "/category/${widget.article.category}");
                    }
                  },
                  child: Text(
                    widget.article.category,
                    style: TextStyle(
                        color: themeOptions.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: user.textSizeScale * themeOptions.textSize3
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const HorizontalWhiteSpace(width: 10),
              const Center(child: Icon(Icons.square, size: 4,)),
              const HorizontalWhiteSpace(width: 10),
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  toDisplayString(widget.article.published, true),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
