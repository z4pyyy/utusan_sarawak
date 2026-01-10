import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/common/bottom_nav_bar.dart';
import 'package:utusan_sarawak/components/common/top_app_bar.dart';
import 'package:utusan_sarawak/components/article_detail_page/article_detail_main.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';

class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return Scaffold(
      backgroundColor: themeOptions.backgroundColor,
      appBar: TopAppBar(width: MediaQuery.of(context).size.width, isArticle: true, articleId: widget.title, showShareButton: true,),
      body: ArticleDetailMain(title: decodeString(widget.title),),
      bottomNavigationBar: const BottomNavBar(index: 0, showAllUnselected: true,),
    );
  }
}
