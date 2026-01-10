import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/components/common/horizontal_white_space.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/components/top_story_page/ads_card.dart';
import 'package:utusan_sarawak/components/top_story_page/article_list.dart';
import 'package:utusan_sarawak/components/top_story_page/single_article.dart';
import 'package:utusan_sarawak/components/top_story_page/two_articles_row.dart';
import 'package:utusan_sarawak/models/article/article.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/stores/ads_store/ads_store.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:utusan_sarawak/utils/scroll_position_state.dart';

class TopStoryMain extends StatefulWidget {
  const TopStoryMain({Key? key}) : super(key: key);

  @override
  State<TopStoryMain> createState() => _TopStoryMainState();
}

class _TopStoryMainState extends State<TopStoryMain> {
  final AdsStore adsStore = GetIt.I<AdsStore>();
  final ArticleStore articleStore = GetIt.I<ArticleStore>();
  List<Article> articles = [];
  List<Article> stickyArticles = [];
  double scrollOffset = 0.0;
  double initialOffset = 0.0;
  bool hasScroll = false;
  int tabIndex = 0;

  late ScrollPositionState scrollPositionState;
  late ScrollController scrollController;
  late Future<bool> future;

  @override
  void initState(){
    super.initState();
    future = myFuture(false);
    scrollPositionState = Provider.of<ScrollPositionState>(context, listen: false);

    initialOffset = 0.0;
    if(scrollPositionState.tabNeedConsume){
      tabIndex = scrollPositionState.consumeIndex();
    }

    scrollController = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: false,
    );
    scrollController.addListener(() {
      setState(() {
        scrollOffset = scrollController.offset;
      });
    });

  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<bool> myFuture(bool forceRefresh) async{
    await articleStore.loadCategories();
    await articleStore.getArticles(forceRefresh).then((value) {
      articles = List.from(articleStore.articleList);
      stickyArticles = List.from(articleStore.stickyArticleList);
    });

    return true;
  }

  Widget topStoryArticleDisplay(bool filterOutSticky){
    List<Article> localArticles = List.from(articles);
    List<String> toRemoveTitle = [];
    if(filterOutSticky){
      for(Article sa in stickyArticles){
        for(Article article in localArticles){
          if(article.title == sa.title){
            toRemoveTitle.add(article.title);
          }
        }
      }
    }

    for(String title in toRemoveTitle){
      localArticles.removeWhere((article) => article.title == title);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SingleArticle(article: localArticles[0], isSingleArticle: true, scrollPosition: scrollOffset, isTab: true,),
          const VerticalWhiteSpace(height: 20),
          TwoArticlesRow(articles: localArticles, startIndex: 1, scrollPosition: scrollOffset, isTab: true,),
          const VerticalWhiteSpace(height: 10),
          const AdsCard(dividerAbove: true, marginTop: 10,),
          ArticleList(articles: localArticles, startIndex: 3, count: 5, scrollPosition: scrollOffset, isTab: true,),
          const AdsCard(dividerAbove: true, marginTop: 10,),
          ArticleList(articles: localArticles, startIndex: 8, count: 7, scrollPosition: scrollOffset, isTab: true,),
          const AdsCard(dividerAbove: true, marginTop: 10,),
          ArticleList(articles: localArticles, startIndex: 16, count: 5, scrollPosition: scrollOffset, isTab: true,),
          const VerticalWhiteSpace(height: 50),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = GetIt.I<User>();
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return RefreshIndicator(
      onRefresh: () async{
        setState(() {
          future = myFuture(true);
        });
      },
      child: SingleChildScrollView(
        controller: scrollController,
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            FutureBuilder(
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
                  if(articles.isNotEmpty) {

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if(hasScroll == false){
                        if(tabIndex != 0){
                          TabController tabController = DefaultTabController.of(context);
                          tabController.animateTo(tabIndex);
                        }else{
                          if(scrollPositionState.needConsume){
                            initialOffset = scrollPositionState.consumeScrollPosition();
                          }
                          scrollController.animateTo(initialOffset, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
                        }
                      }
                      hasScroll = true;
                    });

                    if(stickyArticles.isNotEmpty) {

                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: themeOptions.primaryColorLight.withOpacity(0.35),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6D0000).withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.bookmark_border_rounded,
                                          color: Colors.white,
                                        ),
                                        const HorizontalWhiteSpace(width: 10),
                                        Text(
                                          "Penting",
                                          style: TextStyle(
                                            color: themeOptions.textColorOnPrimary,
                                            fontSize: user.textSizeScale * themeOptions.textSize1,
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                                const VerticalWhiteSpace(height: 15),
                                SingleArticle(article: stickyArticles[0], isSingleArticle: true, scrollPosition: scrollOffset, isTab: true,),
                                if(stickyArticles.length > 1)
                                  const VerticalWhiteSpace(height: 20),
                                if(stickyArticles.length > 1)
                                  TwoArticlesRow(articles: stickyArticles, startIndex: 1, scrollPosition: scrollOffset, isTab: true,),
                              ],
                            ),
                          ),
                          const VerticalWhiteSpace(height: 30),
                          topStoryArticleDisplay(true),
                        ],
                      );


                    }else{
                      return topStoryArticleDisplay(false);
                    }

                  }
                }


                return RefreshIndicator(
                  child: const SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: Center(
                      child: Text("No News Article Found, Please try Again"),
                    ),
                  ),
                  onRefresh: () async{
                    setState(() {
                      future = myFuture(true);
                    });
                  },
                );

              },
            ),
          ],
        ),
      ),
    );
  }
}
