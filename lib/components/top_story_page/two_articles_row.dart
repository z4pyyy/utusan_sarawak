import 'package:flutter/material.dart';
import 'package:utusan_sarawak/components/common/horizontal_white_space.dart';
import 'package:utusan_sarawak/components/top_story_page/single_article.dart';
import 'package:utusan_sarawak/models/article/article.dart';

class TwoArticlesRow extends StatefulWidget{
  const TwoArticlesRow({
    Key? key,
    required this.articles,
    required this.startIndex,
    required this.scrollPosition,
    required this.isTab,
    this.isSubTab = false,
    this.parentTabController,
    this.subTabController,
  }) : super(key: key);

  final List<Article> articles;
  final int startIndex;
  final double scrollPosition;
  final bool isTab;
  final bool isSubTab;
  final TabController? parentTabController;
  final TabController? subTabController;

  @override
  State<TwoArticlesRow> createState() => TwoArticlesRowState();
}

class TwoArticlesRowState extends State<TwoArticlesRow> {

  @override
  Widget build(BuildContext context) {
    final articles = widget.articles;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(articles.length >= widget.startIndex + 1)
          Expanded(
            child: SingleArticle(
              article: articles[widget.startIndex],
              isSingleArticle: false,
              scrollPosition: widget.scrollPosition,
              isTab: widget.isTab,
              isSubTab: widget.isSubTab,
              parentTabController: widget.parentTabController,
              subTabController: widget.subTabController,
            ),
          ),
        const HorizontalWhiteSpace(width: 20),
        if(articles.length >= widget.startIndex + 2)...[
          Expanded(
            child: SingleArticle(
              article: articles[widget.startIndex + 1],
              isSingleArticle: false,
              scrollPosition: widget.scrollPosition,
              isTab: widget.isTab,
              isSubTab: widget.isSubTab,
              parentTabController: widget.parentTabController,
              subTabController: widget.subTabController,
            ),
          ),
        ]else...[
          const Expanded(
            child: Text(""),
          )
        ]
      ],
    );
  }
}
