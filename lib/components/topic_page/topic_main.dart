import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:utusan_sarawak/components/common/vertical_white_space.dart';
import 'package:utusan_sarawak/components/topic_page/topic_article_list.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/scroll_position_state.dart';

class TopicMain extends StatefulWidget {
  const TopicMain({Key? key}) : super(key: key);

  @override
  State<TopicMain> createState() => _TopicMainState();
}

class _TopicMainState extends State<TopicMain> {
  final articleStore = GetIt.I<ArticleStore>();
  late List<String> categoryList;
  final user = GetIt.I<User>();
  late Future<void> future;
  late ScrollPositionState scrollPositionState;
  late ScrollController scrollController;
  double scrollOffset = 0.0;
  double initialOffset = 0.0;
  bool hasScroll = false;

  Future<void> myFuture(bool forceRefresh) async{
    await articleStore.loadCategories();
    await articleStore.getArticles(forceRefresh).then((value) {
      categoryList = articleStore.allCategoryList;
      List<String> categoryToExclude = ["hari-mengundi", "hiburan", "iklan", "pru-15", "umum", "wacana-pengarang"];
      List<int> toRemove = [];
      // print("LENGTH ---- ${categoryList.length}");
      for(int i = 0; i < categoryList.length; i++){
        // print("CATEGORY : ${categoryList[i].toLowerCase()}");
        if(categoryToExclude.contains(categoryList[i].toLowerCase())){
          // print("IS INSIDE --- INDEX $i");
          toRemove.add(i);
        }
      }

      for(int j = toRemove.length - 1; j >= 0; j--){
        // print("REMOVING INDEX ${toRemove[j]} --- ${categoryList[toRemove[j]]}");
        categoryList.removeAt(toRemove[j]);
      }

    });
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

    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async{
        setState(() {
          future = myFuture(true);
        });
      },
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const VerticalWhiteSpace(height: 20),
            FutureBuilder(
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

                if(categoryList.isNotEmpty) {

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if(hasScroll == false){
                      scrollController.animateTo(initialOffset, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
                    }
                    hasScroll = true;
                  });

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categoryList.length,
                    itemBuilder: (context, index){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(index != 0)
                            const VerticalWhiteSpace(height: 30),
                          InkWell(
                            onTap: (){
                              customBeamToNamed(context, scrollOffset, "/category/${categoryList[index]}");
                            },
                            child: Row(
                              children: [
                                Text(
                                  categoryList[index].toUpperCase(),
                                  style: TextStyle(
                                      fontSize: user.textSizeScale * themeOptions.appBarTextSize,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Icon(Icons.keyboard_arrow_right, size: 30,),
                              ],
                            ),
                          ),
                          TopicArticleList(
                            count: 2,
                            category: categoryList[index],
                            scrollPosition: scrollOffset,
                          ),
                        ],
                      );
                    }
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

            const VerticalWhiteSpace(height: 50),
          ],
        ),
      ),
    );

  }
}
