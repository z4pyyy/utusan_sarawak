import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/components/popular_page/popular_article_list.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/scroll_position_state.dart';

class PopularMain extends StatefulWidget {
  const PopularMain({Key? key}) : super(key: key);

  @override
  State<PopularMain> createState() => _PopularMainState();
}

class _PopularMainState extends State<PopularMain> {
  late Future<void> future;
  final ArticleStore articleStore = GetIt.I<ArticleStore>();
  late ScrollPositionState scrollPositionState;
  late ScrollController scrollController;
  double scrollOffset = 0.0;
  double initialOffset = 0.0;
  bool hasScroll = false;

  Future<void> myFuture(bool forceRefresh) async{
    await articleStore.getArticles(forceRefresh);
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
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final user = GetIt.I<User>();

    return RefreshIndicator(
      onRefresh: () async{
        setState(() {
          future = myFuture(true);
        });
      },
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

            if(articleStore.articleList.isNotEmpty) {

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if(hasScroll == false){
                  scrollController.animateTo(initialOffset, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
                }
                hasScroll = true;
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalWhiteSpace(height: 20),
                  Text(
                    "Most read",
                    style: TextStyle(
                        fontSize: user.textSizeScale * themeOptions.appBarTextSize,
                        fontWeight: FontWeight.w500),
                  ),
                  const VerticalWhiteSpace(height: 15),
                  PopularArticleList(startIndex: 0, count: 15, scrollPosition: scrollOffset,),
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
        )

      ),
    );
  }
}
