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

class CategoryPageMain extends StatefulWidget {
  const CategoryPageMain({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  State<CategoryPageMain> createState() => CategoryPageMainState();
}

class CategoryPageMainState extends State<CategoryPageMain> {

  late ScrollPositionState scrollPositionState;
  late ScrollController scrollController;
  double scrollOffset = 0.0;
  double initialOffset = 0.0;
  bool hasScroll = false;

  @override
  void initState(){
    super.initState();
    scrollPositionState = Provider.of<ScrollPositionState>(context, listen: false);

    initialOffset = 0.0;
    if(scrollPositionState.needConsume){
      initialOffset = scrollPositionState.consumeScrollPosition();
    }

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
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ArticleStore articleStore = GetIt.I<ArticleStore>();
    final List<Article> articles = articleStore.getArticleByCategory(widget.category);

    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
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
            ),
          ),
        ],
      ),
    );
  }
}
