import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utusan_sarawak/components/article_detail_page/static_ads_card.dart';
import 'package:utusan_sarawak/components/common/horizontal_white_space.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/components/top_story_page/ads_card.dart';
import 'package:utusan_sarawak/models/article/article.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:utusan_sarawak/utils/image_settings.dart';
import 'package:utusan_sarawak/utils/scroll_position_state.dart';
import 'package:utusan_sarawak/utils/time_display_formatter.dart';

class ArticleDetailMain extends StatefulWidget {
  const ArticleDetailMain({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ArticleDetailMain> createState() => _ArticleDetailMainState();
}

class _ArticleDetailMainState extends State<ArticleDetailMain> {
  final user = GetIt.I<User>();
  final articleStore = GetIt.I<ArticleStore>();
  late List<Article> articles;
  late Map<String, List<Article>> articlesByCategory;
  late Map<int, List<Article>> articlesByTag;
  late Map<int, List<Article>> articlesBySubcategory;
  late List<Article> stickyArticles;
  late List<Article> articleByTitle;
  late List<Article> searchArticles;
  late Article article;
  late List<Article> relatedArticle;
  late ScrollPositionState scrollPositionState;
  late ScrollController scrollController;
  double scrollOffset = 0.0;
  double initialOffset = 0.0;
  bool hasScroll = false;

  late Future<void> future;

  @override
  void initState(){
    super.initState();
    scrollPositionState = Provider.of<ScrollPositionState>(context, listen: false);
    articles = List.from(articleStore.articleList);
    articlesByCategory = Map.from(articleStore.articleByCategory);
    articlesByTag = Map.from(articleStore.articleByTag);
    articlesBySubcategory = Map.from(articleStore.articleBySubcategory);
    stickyArticles = List.from(articleStore.stickyArticleList);
    articleByTitle = List.from(articleStore.articleByTitle);
    searchArticles = List.from(articleStore.searchArticles);
    article = articles.firstWhere(
          (element) {
        return element.title.compareTo(widget.title) == 0;
      },
      orElse: (){
        for(var articles in articlesByCategory.values){
          for(var article in articles){
            if(article.title.compareTo(widget.title) == 0){
              return article;
            }
          }
        }

        for(var articles in articlesByTag.values){
          for(var article in articles){
            if(article.title.compareTo(widget.title) == 0){
              return article;
            }
          }
        }

        for(var article in stickyArticles){
          if(article.title.compareTo(widget.title) == 0){
            return article;
          }
        }

        for(var article in articleByTitle){
          if(article.title.compareTo(widget.title) == 0){
            return article;
          }
        }

        for(var article in searchArticles){
          if(article.title.compareTo(widget.title) == 0){
            return article;
          }
        }

        for(var articles in articlesBySubcategory.values){
          for(var article in articles){
            if(article.title.compareTo(widget.title) == 0){
              return article;
            }
          }
        }

        return articles.firstWhere((element) =>
          element.title.compareTo(widget.title.substring(0, widget.title.length -1)) != 0);
      });

    if(articlesByCategory.containsKey(article.category)){
      relatedArticle = List.from(articlesByCategory[article.category]!);
      relatedArticle.removeWhere((element) => element.title == article.title);
    }else{
      relatedArticle = [];
    }

    initialOffset = 0.0;
    if(scrollPositionState.needConsume){
      initialOffset = scrollPositionState.consumeScrollPosition();
    }

    if(scrollPositionState.tabNeedConsume){
      scrollPositionState.consumeIndex();
    }

    scrollPositionState = Provider.of<ScrollPositionState>(context, listen: false);
    scrollController = ScrollController(
      initialScrollOffset: initialOffset,
      keepScrollOffset: false,
    );

    scrollOffset = initialOffset;
    scrollController.addListener(() {
      setState(() {
        scrollOffset = scrollController.offset;
      });
    });

    future = loadRelatedArticles(article.category);
  }

  Future<void> loadRelatedArticles(String category) async{
    await articleStore.loadArticleByCategory(category);
    if(articleStore.articleByCategory.containsKey(article.category)){
      relatedArticle = List.from(articleStore.articleByCategory[article.category]!);
      relatedArticle.removeWhere((element) => element.title == article.title);
    }else{
      relatedArticle = [];
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return SingleChildScrollView(
      controller: scrollController,
      child: Container(
        padding: const EdgeInsets.only(bottom: 50),
        color: themeOptions.secondaryBackgroundColor,
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                final youtubeUrl = extractYoutubeUrl(article.content[0]["paragraph"] ?? "");
                if (youtubeUrl != null) {
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Open In Youtube", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              launchUrl(Uri.parse(youtubeUrl), mode: LaunchMode.externalApplication);
                            },
                            child: const Text("OPEN"),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  customBeamToNamed(context, scrollOffset, "/image/${encodeString(article.imagePath)}");
                }
              },
              child: Image.network(
                article.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Image.asset('assets/image/grey_background.jpg');
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        color: themeOptions.whiteBackground,
                        // child: InkWell(
                        //   onTap: (){
                        //     customBeamToNamed(context, scrollOffset, "/category/${article.category}");
                        //   },
                        child: Text(
                          article.category,
                          style: TextStyle(
                            color: themeOptions.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: user.textSizeScale * themeOptions.textSize3,
                          ),
                        ),
                        // ),
                      ),
                      const HorizontalWhiteSpace(width: 20),
                      Text(
                        "${article.minRead} min read",
                        style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize3),
                      ),
                    ],
                  ),
                  const VerticalWhiteSpace(height: 15),
                  Text(
                    article.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: user.textSizeScale * themeOptions.textTitleSize1),
                  ),
                  const VerticalWhiteSpace(height: 15),
                  Text(
                    toDisplayString(article.published, false),
                    style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize3),
                  ),
                  const VerticalWhiteSpace(height: 15),
                  Text(
                    "By Utusan Sarawak",
                    style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize3),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: article.content.length,
                      itemBuilder: ((context, listIndex) {

                        String content = article.content[listIndex]["paragraph"]!;
                        int index = content.indexOf("\n", (content.length * 0.65).round());

                        String htmlOne = content.substring(0, index);
                        String htmlTwo = content.substring(index, content.length - 1);

                        return Column(
                          children: [
                            const VerticalWhiteSpace(height: 25),
                            if(article.content[listIndex].containsKey("location"))...[
                              RichText(
                                text: TextSpan(
                                  text: "${article.content[listIndex]["location"]!}: ",
                                  style: TextStyle(
                                    color: themeOptions.textColor,
                                    fontSize: user.textSizeScale * themeOptions.textSize2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: article.content[listIndex]["paragraph"]!,
                                      style: TextStyle(
                                        color: themeOptions.textColor,
                                        fontSize: user.textSizeScale * themeOptions.textSize2,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]else if(article.content[listIndex].containsKey("paragraph"))...[
                              HtmlWidget(
                                htmlOne,
                                textStyle: TextStyle(
                                  color: themeOptions.textColor,
                                  fontSize: user.textSizeScale * themeOptions.textSize2,
                                ),
                                onTapImage: (imageMetadata) {
                                  final url = imageMetadata.sources.first.url;
                                  customBeamToNamed(context, scrollOffset, "/image/${encodeString(url)}");
                                },
                              ),

                              const AdsCard(marginTop: 40),

                              HtmlWidget(
                                htmlTwo,
                                textStyle: TextStyle(
                                  color: themeOptions.textColor,
                                  fontSize: user.textSizeScale * themeOptions.textSize2,
                                ),
                                onTapImage: (imageMetadata) {
                                  final url = imageMetadata.sources.first.url;
                                  customBeamToNamed(context, scrollOffset, "/image/${encodeString(url)}");
                                },
                              ),

                            ],
                            if(listIndex == article.content.length - 5)...[
                              const AdsCard(marginTop: 40,),
                            ],
                          ],
                        );
                      })),
                  const VerticalWhiteSpace(height: 65),
                  const StaticAdsCard(),
                  const VerticalWhiteSpace(height: 65),
                  Text(
                    "Related Stories",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: user.textSizeScale * themeOptions.textTitleSize2),
                  ),
                  FutureBuilder(
                    future: future,
                    builder: (context, snapshot){

                      if(relatedArticle.isEmpty && snapshot.connectionState == ConnectionState.waiting){
                        return const SizedBox(
                          height: 400,
                          width: double.infinity,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if(relatedArticle.isNotEmpty){
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: relatedArticle.length >= 3
                                ? 3
                                : relatedArticle.length,
                            itemBuilder: ((context, listIndex2) {
                              return Column(
                                children: [
                                  const VerticalWhiteSpace(height: 20),
                                  InkWell(
                                    onTap: (){
                                      if(relatedArticle[listIndex2].isTagLink){
                                        List<dynamic> tagDetails = getTagDetails(relatedArticle[listIndex2]);
                                        var tagId = tagDetails[0];
                                        var tagName = tagDetails[1];
                                        customBeamToNamed(context, scrollOffset, "/tag/$tagId/$tagName");
                                      }else{
                                        customBeamToNamed(context, scrollOffset, "/article/${encodeString(relatedArticle[listIndex2].title)}");
                                      }
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Image.network(
                                            relatedArticle[listIndex2].imagePath,
                                            fit: BoxFit.scaleDown,
                                            height: ImageSettings.listImageHeight,
                                            alignment: Alignment.topCenter,
                                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                              return Image.asset('assets/image/grey_background.jpg');
                                            },
                                          ),
                                        ),
                                        const HorizontalWhiteSpace(width: 15),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                relatedArticle[listIndex2].title,
                                                style: TextStyle(
                                                  color: themeOptions.textColor,
                                                  fontSize: user.textSizeScale * themeOptions.textSize2,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const VerticalWhiteSpace(height: 10),
                                              Text(toDisplayString(relatedArticle[listIndex2].published, false)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const VerticalWhiteSpace(height: 15),
                                ],
                              );
                            })
                        );
                      }

                      return const SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: Center(
                          child: Text("No Related Articles Found"),
                        ),
                      );

                    }
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
