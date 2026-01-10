import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/components/common/custom_divider.dart';
import 'package:utusan_sarawak/components/common/horizontal_white_space.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/image_settings.dart';
import 'package:utusan_sarawak/utils/time_display_formatter.dart';

class TopicArticleList extends StatefulWidget{
  const TopicArticleList({
    Key? key,
    required this.count,
    required this.category,
    required this.scrollPosition,
  }) : super(key: key);

  final int count;
  final String category;
  final double scrollPosition;

  @override
  State<TopicArticleList> createState() => TopicArticleListState();
}

class TopicArticleListState extends State<TopicArticleList> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final articleStore = GetIt.I<ArticleStore>();
    final articles = articleStore.getArticleByCategory(widget.category);
    final user = GetIt.I<User>();
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: articles.length > widget.count
            ? widget.count
            : articles.length,
        itemBuilder: ((context, listIndex) {
          return InkWell(
            onTap: (){
              if(articles[listIndex].isTagLink){
                List<dynamic> tagDetails = getTagDetails(articles[listIndex]);
                var tagId = tagDetails[0];
                var tagName = tagDetails[1];
                customBeamToNamed(context, widget.scrollPosition, "/tag/$tagId/$tagName");
              }else{
                customBeamToNamed(context, widget.scrollPosition, "/article/${encodeString(articles[listIndex].title)}");
              }
            },
            child: Column(
              children: [
                const VerticalWhiteSpace(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Image.network(
                        articles[listIndex].imagePath,
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
                            articles[listIndex].title,
                            style: TextStyle(
                              color: themeOptions.textColor,
                              fontSize: user.textSizeScale * themeOptions.textSize2,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const VerticalWhiteSpace(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                  customBeamToNamed(context, widget.scrollPosition, "/category/${articles[listIndex].category}");
                                },
                                child: Text(
                                  articles[listIndex].category,
                                  style: TextStyle(
                                      color: themeOptions.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: user.textSizeScale * themeOptions.textSize3
                                  ),
                                ),
                              ),
                              const HorizontalWhiteSpace(width: 10),
                              const Center(child: Icon(Icons.square, size: 4,)),
                              const HorizontalWhiteSpace(width: 10),
                              Expanded(
                                child: Text(
                                  toDisplayString(articles[listIndex].published, true),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const VerticalWhiteSpace(height: 10),
                if(listIndex == 0)
                  const CustomDivider(),
              ],
            ),
          );
        })
    );
  }
}
