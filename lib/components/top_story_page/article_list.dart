import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:utusan_sarawak/components/common/tab_generator.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/components/common/custom_divider.dart';
import 'package:utusan_sarawak/components/common/horizontal_white_space.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/models/article/article.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/image_settings.dart';
import 'package:utusan_sarawak/utils/time_display_formatter.dart';

class ArticleList extends StatefulWidget{
  const ArticleList({
    Key? key,
    required this.articles,
    required this.startIndex,
    required this.count,
    required this.scrollPosition,
    required this.isTab,
    this.isSubTab = false,
    this.parentTabController,
    this.subTabController,
  }) : super(key: key);

  final List<Article> articles;
  final int startIndex;
  final int count;
  final double scrollPosition;
  final bool isTab;
  final bool isSubTab;
  final TabController? parentTabController;
  final TabController? subTabController;

  @override
  State<ArticleList> createState() => ArticleListState();
}

class ArticleListState extends State<ArticleList> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final articles = widget.articles;
    final user = GetIt.I<User>();

    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: articles.length - widget.startIndex >= widget.count
          ? widget.count
          : articles.length - widget.startIndex > 0
            ? articles.length - widget.startIndex
            : 0,
        itemBuilder: ((context, listIndex) {
          return InkWell(
            onTap: (){
              if(articles[listIndex + widget.startIndex].isTagLink){
                List<dynamic> tagDetails = getTagDetails(articles[listIndex + widget.startIndex]);
                var tagId = tagDetails[0];
                var tagName = tagDetails[1];
                customBeamToNamed(context, widget.scrollPosition, "/tag/$tagId/$tagName");
              }else{
                if(widget.isTab){
                  TabController tabController = DefaultTabController.of(context);

                  if(widget.isSubTab && widget.parentTabController != null){
                    customBeamToNamed(
                      context, widget.scrollPosition, "/article/${encodeString(articles[listIndex + widget.startIndex].title)}",
                      tabIndex: widget.parentTabController!.index,
                      subTabIndex: tabController.index
                    );
                  }else{
                    customBeamToNamed(
                      context, widget.scrollPosition, "/article/${encodeString(articles[listIndex + widget.startIndex].title)}",
                      tabIndex: tabController.index
                    );
                  }

                }else{
                  customBeamToNamed(context, widget.scrollPosition, "/article/${encodeString(articles[listIndex + widget.startIndex].title)}");
                }
              }

            },
            child: Column(
              children: [
                const CustomDivider(),
                const VerticalWhiteSpace(height: 10),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: (){
                                    if(widget.isTab){
                                      TabController tabController = DefaultTabController.of(context);
                                      int index = currentTabOrder.indexOf(articles[listIndex + widget.startIndex].category.toUpperCase());
                                      if(index != -1){
                                        tabController.animateTo(index);
                                      }
                                    }else{
                                      customBeamToNamed(context, widget.scrollPosition, "/category/${articles[listIndex + widget.startIndex].category}");
                                    }
                                  },
                                  child: Text(
                                    articles[listIndex + widget.startIndex].category,
                                    style: TextStyle(
                                        color: themeOptions.primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize:user.textSizeScale *  themeOptions.textSize3
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
                                child: Text(
                                  toDisplayString(articles[listIndex + widget.startIndex].published, true),
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
              ],
            ),
          );
        })
    );
  }
}
