import 'package:beamer/beamer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:utusan_sarawak/components/common/custom_icon_button.dart';
import 'package:utusan_sarawak/components/common/logo_image.dart';
import 'package:utusan_sarawak/components/setting_page/setting_main.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:utusan_sarawak/models/article/article.dart';
import 'package:utusan_sarawak/services/utusan_link_service.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/utils/scroll_position_state.dart';

class TopAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TopAppBar({
    Key? key,
    required this.width,
    this.isMain = false,
    this.isArticle = false,
    this.isCategory = false,
    this.showShareButton = false,
    this.shadow = true,
    this.category = "",
    this.articleId = "",
  }) : super(key: key);

  final double height = 70;
  final double width;
  final bool isMain;
  final bool isArticle;
  final bool isCategory;
  final bool showShareButton;
  final bool shadow;
  final String category;
  final String articleId;

  @override
  State<TopAppBar> createState() => TopAppBarState();

  @override
  Size get preferredSize => Size(width, height);
}

class TopAppBarState extends State<TopAppBar> {
  Article? _findArticle(ArticleStore store, String title) {
    for (final article in store.articleList) {
      if (article.title == title) return article;
    }
    for (final article in store.stickyArticleList) {
      if (article.title == title) return article;
    }
    for (final article in store.articleByTitle) {
      if (article.title == title) return article;
    }
    for (final article in store.searchArticles) {
      if (article.title == title) return article;
    }
    for (final list in store.articleByCategory.values) {
      for (final article in list) {
        if (article.title == title) return article;
      }
    }
    for (final list in store.articleByTag.values) {
      for (final article in list) {
        if (article.title == title) return article;
      }
    }
    for (final list in store.articleBySubcategory.values) {
      for (final article in list) {
        if (article.title == title) return article;
      }
    }
    return null;
  }

  Future<Article?> _loadArticleByTitle(ArticleStore store, String title) async {
    final articles = await store.loadArticleByTitle(title);
    if (articles.isEmpty) return null;
    return articles.first;
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final beamer = Beamer.of(context);
    final user = GetIt.I<User>();
    final scrollPositionState = Provider.of<ScrollPositionState>(context, listen: false);
    return SafeArea(
      child: PreferredSize(
        preferredSize: Size.fromHeight(widget.height),
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            boxShadow: (widget.isMain || widget.isCategory) && widget.shadow
                ? const [
                    BoxShadow(
                      color: Color.fromRGBO(210, 210, 210, 0.4),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0.0, 5),
                    ),
                  ]
                : const [],
            color: themeOptions.whiteBackground,
          ),
          child: widget.isMain
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      icon: Icons.settings_outlined,
                      size: 30,
                      onPressed: (){
                        showModalBottomSheet<dynamic>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: themeOptions.secondaryBackgroundColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0)
                            ),
                          ),
                          builder: (BuildContext context){
                            return const SettingMain();
                          });
                      }
                    ),
                    LogoImage(
                      width: widget.width*0.5
                    ),
                    CustomIconButton(
                      icon: Icons.settings_outlined,
                      size: 30,
                      onPressed: (){},
                      hide: true,
                    ),
                  ]
                )
              : widget.isCategory
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          String previousUri = Beamer.of(context).currentBeamLocation.history.last.routeInformation.uri.toString();
                          if(checkUriNeedConsume(previousUri)){
                            scrollPositionState.needConsume = true;
                            scrollPositionState.tabNeedConsume = true;
                            scrollPositionState.subTabNeedConsume = true;
                          }
                          beamer.beamBack();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomIconButton(
                              icon: Icons.arrow_back_ios_new,
                              size: 24,
                              onPressed: (){
                                String previousUri = Beamer.of(context).currentBeamLocation.history.last.routeInformation.uri.toString();
                                if(checkUriNeedConsume(previousUri)){
                                  scrollPositionState.needConsume = true;
                                  scrollPositionState.tabNeedConsume = true;
                                  scrollPositionState.subTabNeedConsume = true;
                                }
                                beamer.beamBack();
                              }
                          ),
                            Text("Back", style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize1),),
                          ]
                        ),
                      ),
                      Text(widget.category, style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize1, fontWeight: FontWeight.w500),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomIconButton(
                            icon: Icons.arrow_back_ios_new,
                            size: 24,
                            hide: true,
                            onPressed: (){},
                          ),
                          Text("Back", style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize1, color: Colors.white.withOpacity(0)),),
                        ]
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          String previousUri = Beamer.of(context).currentBeamLocation.history.last.routeInformation.uri.toString();
                          if(checkUriNeedConsume(previousUri)){
                            scrollPositionState.needConsume = true;
                            scrollPositionState.tabNeedConsume = true;
                            scrollPositionState.subTabNeedConsume = true;
                          }
                          beamer.beamBack();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomIconButton(
                              icon: Icons.arrow_back_ios_new,
                              size: 26,
                              onPressed: (){
                                String previousUri = Beamer.of(context).currentBeamLocation.history.last.routeInformation.uri.toString();
                                if(checkUriNeedConsume(previousUri)){
                                  scrollPositionState.needConsume = true;
                                  scrollPositionState.tabNeedConsume = true;
                                  scrollPositionState.subTabNeedConsume = true;
                                }
                                beamer.beamBack();
                              }
                            ),
                            Text("Back", style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize1),),
                          ]
                        ),
                      ),
                      if(widget.showShareButton)
                        CustomIconButton(
                          icon: Icons.share,
                          size: 28,
                          onPressed: () async{
                            final articleStore = GetIt.I<ArticleStore>();
                            final title = decodeString(widget.articleId);
                            Article? article = _findArticle(articleStore, title);
                            article ??= await _loadArticleByTitle(articleStore, title);
                            if (article == null) {
                              debugPrint('TopAppBar: article not found for share: $title');
                              return;
                            }
                            final url = await UtusanLinkService.createArticleLink(article);
                            if (url != null) {
                              await Share.share(url);
                            } else {
                              debugPrint('TopAppBar: failed to create FlowLinks URL');
                            }
                          }
                        ),
                      // if(widget.showShareButton)
                      // CustomIconButton(
                      //     size: 24,
                      //     icon: Icons.water_drop,
                      //     onPressed: (){
                      //       FirebaseCrashlytics.instance.crash();
                      //     }
                      // ),
                    ],
                  ),
        ),
      ),
    );
  }
}




