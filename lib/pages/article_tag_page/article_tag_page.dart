import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/article_tag_page/article_tag_page_main.dart';
import 'package:utusan_sarawak/components/common/bottom_nav_bar.dart';
import 'package:utusan_sarawak/components/common/top_app_bar.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class ArticleTagPage extends StatefulWidget {
  const ArticleTagPage({Key? key,
    required this.tagId,
    required this.tagName
  }) : super(key: key);

  final int tagId;
  final String tagName;

  @override
  State<ArticleTagPage> createState() => ArticleTagPageState();
}

class ArticleTagPageState extends State<ArticleTagPage> {

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    return Scaffold(
      backgroundColor: themeOptions.backgroundColor,
      appBar: TopAppBar(
        width: MediaQuery.of(context).size.width,
        isCategory: true,
        category: widget.tagName,
      ),
      body: ArticleTagPageMain(tagId: widget.tagId),
      bottomNavigationBar: const BottomNavBar(index: 0, showAllUnselected: true,),
    );
  }
}
