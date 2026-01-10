import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/components/common/tab_generator.dart';
import 'package:utusan_sarawak/models/article/article.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:utusan_sarawak/utils/scroll_position_state.dart';

class SubcategoryTab extends StatefulWidget {
  const SubcategoryTab({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  State<SubcategoryTab> createState() => SubcategoryTabState();
}

class SubcategoryTabState extends State<SubcategoryTab> {

  late ScrollPositionState scrollPositionState;
  late ScrollController scrollController;
  double scrollOffset = 0.0;
  double initialOffset = 0.0;
  bool hasScroll = false;

  final ArticleStore articleStore = GetIt.I<ArticleStore>();
  List<Article> articles = [];
  late Future<bool> future;

  Future<bool> loadArticle() async{
    articles = articleStore.getArticleByCategory(widget.category);

    if(articles.isEmpty){
      await articleStore.loadArticleByCategory(widget.category).then((value) {
        articles = articleStore.getArticleByCategory(widget.category);
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
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final parentTabController = DefaultTabController.of(context);
    int tabLength = getSubTabs(widget.category).length;
    return DefaultTabController(
      length: tabLength,
      child: Scaffold(
        backgroundColor: themeOptions.backgroundColor,
        appBar: AppBar(
          backgroundColor: themeOptions.primaryColorLight.withOpacity(0.2),
          automaticallyImplyLeading: false, // No back button
          toolbarHeight: 0,
          bottom: TabBar(
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: const EdgeInsets.only(left: 0),
            tabs: getSubTabs(widget.category),
            indicatorColor: themeOptions.primaryColor,
            labelColor: themeOptions.primaryColor,
            unselectedLabelColor: themeOptions.primaryColorUnselect,
            indicatorSize: TabBarIndicatorSize.label,
          ),
        ),
        body: TabBarView(
          children: getSubTabViews(widget.category, parentTabController),
        ),
      ),
    );

  }
}
