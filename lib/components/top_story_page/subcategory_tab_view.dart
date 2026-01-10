import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/components/top_story_page/ads_card.dart';
import 'package:utusan_sarawak/components/top_story_page/article_list.dart';
import 'package:utusan_sarawak/components/top_story_page/single_article.dart';
import 'package:utusan_sarawak/components/top_story_page/two_articles_row.dart';
import 'package:utusan_sarawak/models/article/article.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/utils/scroll_position_state.dart';

class SubcategoryTabView extends StatefulWidget {
  const SubcategoryTabView({Key? key, required this.categoryId, required this.parentTabController}) : super(key: key);

  final int categoryId;
  final TabController parentTabController;

  @override
  State<SubcategoryTabView> createState() => SubcategoryTabViewState();
}

class SubcategoryTabViewState extends State<SubcategoryTabView> {

  late ScrollPositionState scrollPositionState;
  late ScrollController scrollController;
  double scrollOffset = 0.0;
  double initialOffset = 0.0;
  bool hasScroll = false;
  int subTabIndex = 0;

  final ArticleStore articleStore = GetIt.I<ArticleStore>();
  List<Article> articles = [];
  late Future<bool> future;

  Future<bool> loadArticle() async{
    articles = articleStore.getArticleBySubcategory(widget.categoryId);

    if(articles.isEmpty){
      bool isTag = articleStore.subCategories["KOLUM"]!.contains(widget.categoryId);
      await articleStore.loadArticleBySubCategory(widget.categoryId, isTag).then((value) {
        articles = articleStore.getArticleBySubcategory(widget.categoryId);
      });
    }

    return true;
  }

  @override
  void initState(){
    super.initState();

    future = loadArticle();

    scrollPositionState = Provider.of<ScrollPositionState>(context, listen: false);

    initialOffset = 0.0;

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

    if(scrollPositionState.subTabNeedConsume){
      subTabIndex = scrollPositionState.consumeSubIndex();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabController subTabController = DefaultTabController.of(context);
    return RefreshIndicator(
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder(
            future: future,
            builder: (buildContext, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if(articles.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if(hasScroll == false){
                    if(subTabIndex != 0){
                      TabController tabController = DefaultTabController.of(context);
                      tabController.animateTo(subTabIndex);
                    }else{
                      if(scrollPositionState.needConsume){
                        initialOffset = scrollPositionState.consumeScrollPosition();
                      }
                      scrollController.animateTo(initialOffset, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
                    }
                  }
                  hasScroll = true;
                });

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SingleArticle(
                            article: articles[0], isSingleArticle: true, scrollPosition: scrollOffset, isTab: true, isSubTab: true, parentTabController: widget.parentTabController, subTabController: subTabController,),
                          const VerticalWhiteSpace(height: 20),
                          TwoArticlesRow(articles: articles, startIndex: 1, scrollPosition: scrollOffset, isTab: true, isSubTab: true, parentTabController: widget.parentTabController,subTabController: subTabController,),
                          const VerticalWhiteSpace(height: 10),
                          const AdsCard(dividerAbove: true, marginTop: 10,),
                          ArticleList(articles: articles, startIndex: 3, count: 5, scrollPosition: scrollOffset, isTab: true, isSubTab: true, parentTabController: widget.parentTabController, subTabController: subTabController,),
                          const AdsCard(dividerAbove: true, marginTop: 10,),
                          ArticleList(articles: articles, startIndex: 8, count: 7, scrollPosition: scrollOffset, isTab: true, isSubTab: true, parentTabController: widget.parentTabController, subTabController: subTabController,),
                          const AdsCard(dividerAbove: true, marginTop: 10,),
                          ArticleList(articles: articles, startIndex: 16, count: 5, scrollPosition: scrollOffset, isTab: true, isSubTab: true, parentTabController: widget.parentTabController, subTabController: subTabController,),
                          const VerticalWhiteSpace(height: 50),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox(
                height: 400,
                width: double.infinity,
                child: Center(
                  child: Text("No News Article Found, Please try Again"),
                ),
              );

            }
        ),

      ),
      onRefresh: () async{
        setState(() {
          future = loadArticle();
        });
      },
    );

  }
}
