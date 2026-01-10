import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:utusan_sarawak/models/article/article.dart';
import 'package:utusan_sarawak/models/user/user.dart';
import 'package:utusan_sarawak/stores/article_store/article_store.dart';
import 'package:utusan_sarawak/themes/theme_options.dart';
import 'package:utusan_sarawak/utils/common_functions.dart';
import 'package:utusan_sarawak/utils/search_cache.dart';

class SearchPageMain extends StatefulWidget {
  const SearchPageMain({Key? key}) : super(key: key);

  @override
  State<SearchPageMain> createState() => SearchPageMainState();
}

class SearchPageMainState extends State<SearchPageMain>{
  final TextEditingController _controller = TextEditingController();

  void handleSearch(String query, ArticleStore articleStore, SearchCache searchCache) {
    if (query.trim().isEmpty) return;

    searchCache.lastQuery = query;
    searchCache.lastSearchFuture = articleStore.loadSearchArticles(query);
    setState(() {});
  }

  Widget _buildArticleTile(Article article, User user, ThemeOptions themeOptions) {
    return InkWell(
      onTap: (){
        customBeamToNamed(
          context, 0, "/article/${encodeString(article.title)}",
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: TextStyle(fontSize: user.textSizeScale * themeOptions.textSize1, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 60,
                      child: Html(
                        data: article.content[0]["summary"] ?? article.content[0]["paragraph"],
                        style: {
                          '#': Style(
                            fontSize: FontSize(user.textSizeScale * themeOptions.textSize4),
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            margin: Margins.all(0),
                          ),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  article.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final articleStore = GetIt.I<ArticleStore>();
    final searchCache = GetIt.I<SearchCache>();
    final user = GetIt.I<User>();

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (query) {
                    handleSearch(query, articleStore, searchCache);
                  },
                  textInputAction: TextInputAction.search,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: themeOptions.textTitleSize2,
                    color: themeOptions.textColor,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: "Cari",
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.search, size: 32),
            ],
          ),
        ),

        if (searchCache.lastSearchFuture != null)
          FutureBuilder<List<Article>>(
            future: searchCache.lastSearchFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Tiada carian dijumpai'),
                );
              }

              final articles = snapshot.data!;
              if (articles.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Tiada carian dijumpai'),
                );
              }

              return Column(
                children: articles
                  .map((article) => _buildArticleTile(article, user, themeOptions))
                  .toList(),
              );
            },
          )
        else
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 20),
            child: Text(
              'Masukkan kata kunci di atas untuk mula mencari',
              style: TextStyle(
                fontSize:  user.textSizeScale * themeOptions.textSize4,
              ),
            ),
          ),

      ],
    );


  }
}
