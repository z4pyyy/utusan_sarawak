import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/components/top_story_page/article_list.dart';
import 'package:utusan_sarawak/components/top_story_page/single_article.dart';
import 'package:utusan_sarawak/components/top_story_page/two_articles_row.dart';
import 'package:utusan_sarawak/models/article/article.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/utils/scroll_position_state.dart';

class ArticleTagPageMain extends StatefulWidget {
  const ArticleTagPageMain({Key? key, required this.tagId}) : super(key: key);

  final int tagId;

  @override
  State<ArticleTagPageMain> createState() => ArticleTagPageMainState();
}

class ArticleTagPageMainState extends State<ArticleTagPageMain> {
  final articleStore = GetIt.I<ArticleStore>();
  late List<Article> articles;
  late Future<void> future;
  late ScrollPositionState scrollPositionState;
  late ScrollController scrollController;
  double scrollOffset = 0.0;
  double initialOffset = 0.0;
  bool hasScroll = false;

  Future<void> myFuture(bool forceRefresh) async{
    articles = await articleStore.loadArticleByTag(widget.tagId);
  }

  @override
  void initState(){
    super.initState();
    future = myFuture(false);
    scrollPositionState = Provider.of<ScrollPositionState>(context, listen: false);

    initialOffset = 0.0;
    if(scrollPositionState.needConsume){
      initialOffset = scrollPositionState.consumeScrollPosition();
    }

    if(scrollPositionState.tabNeedConsume){
      scrollPositionState.consumeIndex();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: FutureBuilder(
              future: future,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if(snapshot.connectionState == ConnectionState.done && articles.isNotEmpty){

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if(hasScroll == false){
                      scrollController.animateTo(initialOffset, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
                    }
                    hasScroll = true;
                  });

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SingleArticle(article: articles[0], isSingleArticle: true, scrollPosition: scrollOffset, isTab: false,),
                      const VerticalWhiteSpace(height: 20),
                      TwoArticlesRow(articles: articles, startIndex: 1, scrollPosition: scrollOffset, isTab: false,),
                      const VerticalWhiteSpace(height: 10),
                      ArticleList(articles: articles, startIndex: 3, count: 2, scrollPosition: scrollOffset, isTab: false,),
                      const VerticalWhiteSpace(height: 50),
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

              },
            ),

            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     SingleArticle(article: articles[0], isSingleArticle: true,),
            //     const VerticalWhiteSpace(height: 20),
            //     TwoArticlesRow(articles: articles, startIndex: 1),
            //     const VerticalWhiteSpace(height: 10),
            //     ArticleList(articles: articles, startIndex: 3, count: 2),
            //     const VerticalWhiteSpace(height: 50),
            //   ],
            // ),


          ),
        ],
      ),
    );
  }
}
