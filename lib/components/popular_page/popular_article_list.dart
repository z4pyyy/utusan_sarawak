import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/components/common/horizontal_white_space.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:utusan_sarawak/utils/image_settings.dart';
import 'package:utusan_sarawak/utils/time_display_formatter.dart';

class PopularArticleList extends StatefulWidget{
  const PopularArticleList({
    Key? key,
    required this.startIndex,
    required this.count,
    required this.scrollPosition,
  }) : super(key: key);

  final int startIndex;
  final int count;
  final double scrollPosition;

  @override
  State<PopularArticleList> createState() => PopularArticleListState();
}

class PopularArticleListState extends State<PopularArticleList> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final articleStore = GetIt.I<ArticleStore>();
    final articles = articleStore.articleList;
    final user = GetIt.I<User>();
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: articles.length - widget.startIndex >= widget.count
          ? widget.count
          : articles.length - widget.startIndex,
        itemBuilder: ((context, listIndex) {
          return InkWell(
            onTap: (){
              if(articles[listIndex + widget.startIndex].isTagLink){
                List<dynamic> tagDetails = getTagDetails(articles[listIndex + widget.startIndex]);
                var tagId = tagDetails[0];
                var tagName = tagDetails[1];
                customBeamToNamed(context, widget.scrollPosition, "/tag/$tagId/$tagName");
              }else{
                customBeamToNamed(context, widget.scrollPosition, "/article/${encodeString(articles[listIndex + widget.startIndex].title)}");
              }
            },
            child: Column(
              children: [
                if(listIndex != 0)
                  const VerticalWhiteSpace(height: 35),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Image.network(
                        articles[listIndex + widget.startIndex].imagePath,
                        fit: BoxFit.scaleDown,
                        height: ImageSettings.listImageHeight,
                        alignment: Alignment.topCenter,
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Image.asset('assets/image/grey_background.jpg'); // Fallback to a local image
                        },
                      ),
                    ),
                    const HorizontalWhiteSpace(width: 15),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            articles[listIndex + widget.startIndex].title,
                            style: TextStyle(
                              color: themeOptions.textColor,
                              fontSize: user.textSizeScale * themeOptions.textSize2,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const VerticalWhiteSpace(height: 10),
                          Text(toDisplayString(articles[listIndex + widget.startIndex].published, true), style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize3),),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        })
    );
  }
}
