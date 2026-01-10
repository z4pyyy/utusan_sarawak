import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:utusan_sarawak/components/reward_page/reward_tab.dart';
import 'package:utusan_sarawak/components/top_story_page/category_tab.dart';
import 'package:utusan_sarawak/components/top_story_page/subcategory_tab.dart';
import 'package:utusan_sarawak/components/top_story_page/subcategory_tab_view.dart';
import 'package:utusan_sarawak/components/top_story_page/top_story_main.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/stores/reward_store/reward_store.dart';

Widget paddingText(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Text(text),
  );
}

List<String> currentTabOrder = [];

List<Widget> getTabs(){
  List<Widget> tabs = [];
  currentTabOrder.clear();

  final ArticleStore articleStore = GetIt.I<ArticleStore>();
  List<String> categoryList = articleStore.allCategoryList;
  List<String> categoryFilter = articleStore.categoryFilter;

  // First one in tabs is 'home'
  tabs.add(paddingText("TERKINI"));
  currentTabOrder.add("TERKINI");
  for(String category in categoryList){
    if(categoryFilter.contains(category.toUpperCase())) {
      tabs.add(paddingText(category.toUpperCase()));
      currentTabOrder.add(category.toUpperCase());
    }
  }

  if(tabs.length - 1 == categoryFilter.length){
    tabs.clear();
    tabs.add(paddingText("TERKINI"));
    for(String category in categoryFilter){
      tabs.add(paddingText(category.toUpperCase()));
    }

    currentTabOrder.clear();
    currentTabOrder.add("TERKINI");
    currentTabOrder.addAll(categoryFilter);
  }


  return tabs;
}

List<Widget> getTabViews(){
  List<Widget> tabViews = [];

  // First tab is 'home' which is TopStoryMain()
  tabViews.add(const TopStoryMain());

  final ArticleStore articleStore = GetIt.I<ArticleStore>();
  List<String> categoryWithSubcategory = articleStore.subCategories.keys.map((e) => e.toUpperCase()).toList();

  List<String> categoryList = articleStore.allCategoryList;
  List<String> categoryFilter = articleStore.categoryFilter;

  for(String category in categoryList){
    if(categoryFilter.contains(category.toUpperCase())){
      if(categoryWithSubcategory.contains(category.toUpperCase())){
        tabViews.add(SubcategoryTab(category: category));
      }else{
        tabViews.add(CategoryTab(category: category));
      }
    }
  }

  if(tabViews.length - 1 == categoryFilter.length){
    tabViews.clear();
    tabViews.add(const TopStoryMain());
    for(String category in categoryFilter){
      if(categoryWithSubcategory.contains(category.toUpperCase())){
        tabViews.add(SubcategoryTab(category: category));
      }else{
        tabViews.add(CategoryTab(category: category));
      }
    }
  }

  return tabViews;
}

List<Widget> getSubTabs(String category){
  List<Widget> tabs = [];
  final ArticleStore articleStore = GetIt.I<ArticleStore>();

  List<String> tabsText = [];

  if(category.toUpperCase() == "WILAYAH"){
    tabsText.add("Terkini");
  }

  for(var subCatId in articleStore.subCategories[category]!){
    tabsText.add(articleStore.subCategoryIdToName[subCatId]!);
  }

  for(String text in tabsText){
    tabs.add(paddingText(text));
  }

  return tabs;
}

List<Widget> getSubTabViews(String category, TabController parentTabController){
  List<Widget> tabViews = [];

  final ArticleStore articleStore = GetIt.I<ArticleStore>();

  if(category.toUpperCase() == "WILAYAH"){
    int id = articleStore.categoryIdToName.keys.firstWhere((element) => articleStore.categoryIdToName[element] == category );
    tabViews.add(SubcategoryTabView(categoryId: id, parentTabController: parentTabController,));
  }

  for(var subCatId in articleStore.subCategories[category]!){
    tabViews.add(SubcategoryTabView(categoryId: subCatId, parentTabController: parentTabController,));
  }

  return tabViews;
}


List<Widget> getRewardTabs(){
  RewardStore rewardStore = GetIt.I<RewardStore>();
  List<Map<String, dynamic>> rewards = rewardStore.rewardList;

  return rewards.map((r) => r['category'] ?? "")
      .toSet()
      .map((c) => paddingText(c))
      .toList();
}

List<Widget> getRewardTabViews(){
  RewardStore rewardStore = GetIt.I<RewardStore>();
  List<Map<String, dynamic>> rewards = rewardStore.rewardList;

  return rewards
      .map((r) => r['category'] ?? "")
      .toSet()
      .map((c) => RewardTab(category: c))
      .toList();
}