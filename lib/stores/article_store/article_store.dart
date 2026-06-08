import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:utusan_sarawak/models/article/article.dart';

class ArticleStore{
  DateTime refreshTime = DateTime.now().subtract(const Duration(minutes: 10));
  List<Article> articleList = [];
  List<Article> stickyArticleList = [];
  List<Article> articleByTitle = [];
  List<Article> searchArticles = [];
  Map<String, List<Article>> articleByCategory = {};
  Map<int, List<Article>> articleByTag = {};
  List<String> allCategoryList = [];
  List<int> allCategoryId = [];
  Map<int, String> categoryIdToName = {};
  List<Map<String, dynamic>> allTags = [];

  Map<String, List<int>> defaultSubCategories = {
    // "KOLUM" : [19,22,30,32,66],
    // "WILAYAH" : [77,78,90,91,92],
    "KOLUM" : [19,22,32,66],
    // "NASIONAL" : [79,80,81,82,83,84,85,86,87,88,89]
  };
  Map<String, List<int>> subCategories = {
  };

  Map<int, String> defaultSubCategoryIdToName = {
    19 : "Dr Awang Azman",
    22 : "Dr Suffian Mansor",
    // 30 : "Adi Badiozaman Tuah",
    32 : "Kadir Dikoh",
    66 : "Mohamad Fadillah Sabali",
    // 77 : "Sabah",
    // 78 : "Sarawak",
    // 79 : "Kedah",
    // 80 : "Perak",
    // 81 : "Negeri Sembilan",
    // 82 : "Kelantan",
    // 83 : "Johor",
    // 84 : "Terengganu",
    // 85 : "Pahang",
    // 86 : "Selangor",
    // 87 : "Perlis",
    // 88 : "Pulau Pinang",
    // 89 : "Melaka",
    // 90 : "Putrajaya",
    // 91 : "Kuala Lumpur",
    // 92 : "Labuan",
  };
  Map<int, String> subCategoryIdToName = {
  };

  Map<int, List<Article>> articleBySubcategory = {};

  final List<String> categoryFilter = [
    "IKLAN",
    "SEMASA",
    "WILAYAH",
    "TEMPATAN",
    "NASIONAL",
    "ADVERTORIAL",
    "RENCANA",
    "TEKNOLOGI",
    "PENDIDIKAN",
    "BISNES",
    "KOLUM",
    "GLOBAL",
    "SUKAN"
    // "WBS",
    // "STAIL",
    // "SADA IBAN"
  ];

  final int refreshInterval = 30;
  final Dio client;
  final String apiUrl = "https://utusansarawak.com.my/wp-json/wp/v2";

  ArticleStore({required this.client});

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }

  Future<void> loadCategories() async {
    try {
      Response response = await client.get("$apiUrl/categories?_fields=name,id,parent&per_page=99");
      List<dynamic> data = response.data;

      allCategoryList.clear();
      allCategoryId.clear();
      categoryIdToName.clear();
      subCategories.clear();
      subCategories.addAll(defaultSubCategories);
      subCategoryIdToName.clear();
      subCategoryIdToName.addAll(defaultSubCategoryIdToName);
      for (var e in data) {
        String categoryName = parse(e["name"]).body!.text;
        allCategoryList.add(categoryName);
        allCategoryId.add(e["id"]);
        categoryIdToName[e["id"]] = categoryName;
      }

      for(var e in data){
        if(e["parent"] != 0){
          String categoryName = parse(e["name"]).body!.text;
          String parentCategory = categoryIdToName[e["parent"]]!.toUpperCase();
          subCategoryIdToName[e["id"]] = categoryName;
          if(subCategories.containsKey(parentCategory)){
            subCategories[parentCategory]!.add(e["id"]);
          }else{
            subCategories[parentCategory] = [e["id"]];
          }
        }
      }


    } on DioException catch (e) {
      if (e.response?.data['message'] != null) {
        // showToast(message: "Error while getting Ads data ${e.response!.data['message']}", status: Status.error);
      }
      // showToast(message: "Unable to get Ads data $e", status: Status.error);
    }
  }

  Future<void> getArticles(bool forceRefresh) async {
    DateTime now = DateTime.now();
    if(now.difference(refreshTime).inMinutes >= refreshInterval || forceRefresh || articleList.isEmpty) {
      refreshTime = now;

      try {
        articleList.clear();
        Response response = await client.get("$apiUrl/posts?_fields=id,title,date,yoast_head_json,content,categories,tags,link&per_page=23");
        List<dynamic> data = response.data;

        for (var e in data){
          Article article = processWordpressApiResponse(e);
          articleList.add(article);
        }

        await loadStickyArticle();
        await loadTags();

      } on DioException catch (e) {
        if (e.response?.data['message'] != null) {
          // showToast(message: "Error while getting Ads data ${e.response!.data['message']}", status: Status.error);
          // print("ERROR GETTING ARTICLE ${e.response!.data['message']}");
        }
        // showToast(message: "Unable to get Ads data $e", status: Status.error);
        // print("ERROR GETTING ARTICLE $e");
      }

    }
  }

  Future<void> loadArticleByCategory(String category) async{
    int id = categoryIdToName.keys.firstWhere((element) => categoryIdToName[element] == category );
    for(var categoryId in allCategoryId){
      if(categoryId == id){
        Response response = await client.get("$apiUrl/posts?_fields=id,title,date,yoast_head_json,content,categories,tags,link&per_page=20&categories=$categoryId");
        List<dynamic> data = response.data;

        List<Article> articles = [];
        for (var e in data){
          Article article = processWordpressApiResponse(e);
          articles.add(article);
        }

        articleByCategory[categoryIdToName[categoryId]!] = articles;
      }
    }
  }

  Future<void> loadArticleBySubCategory(int subCategory, bool isTag) async{
    late Response response;
    if(isTag){
      response = await client.get("$apiUrl/posts?_fields=id,title,date,yoast_head_json,content,categories,tags,link&per_page=20&tags=$subCategory");
    }else{
      response = await client.get("$apiUrl/posts?_fields=id,title,date,yoast_head_json,content,categories,tags,link&per_page=20&categories=$subCategory");
    }

    List<dynamic> data = response.data;

    List<Article> articles = [];
    for (var e in data){
      Article article = processWordpressApiResponse(e);
      articles.add(article);
    }

    articleBySubcategory[subCategory] = articles;
  }

  Future<void> loadTags() async{
    allTags.clear();
    Response response = await client.get("$apiUrl/tags?_fields=id,name&per_page=99");
    final data = response.data;

    for(var e in data){
      Map<String, dynamic> singleTag = {};
      singleTag["id"] = e["id"];
      singleTag["name"] = e["name"];

      allTags.add(singleTag);
    }

  }

  Future<void> loadStickyArticle() async{
    Response response = await client.get("$apiUrl/posts?_fields=id,title,date,yoast_head_json,content,categories,tags,link&per_page=5&sticky=true");
    List<dynamic> data = response.data;

    stickyArticleList.clear();
    for (var e in data){
      Article article = processWordpressApiResponse(e);
      stickyArticleList.add(article);
    }

  }

  Future<List<Article>> loadArticleByTag(int tagId) async{
    Response response = await client.get("$apiUrl/posts?_fields=id,title,date,yoast_head_json,content,categories,tags,link&per_page=5&tags=$tagId");
    List<dynamic> data = response.data;

    List<Article> articles = [];
    for (var e in data){
      Article article = processWordpressApiResponse(e);
      articles.add(article);
    }

    articleByTag.addAll({
      tagId : articles,
    });
    return articles;
  }

  Future<Article> loadSingleArticleById(int id) async{
    Response response = await client.get("$apiUrl/posts/$id?_fields=id,title,date,yoast_head_json,content,categories,tags,link");
    final data = response.data;

    Article article = processWordpressApiResponse(data);
    return article;
  }

  Future<List<Article>> loadArticleByTitle(String title) async{
    String safeTitle = title.replaceAll(RegExp(r"""[:??????!?.,'"@#$&()/]"""), '');
    String encodedTitle = Uri.encodeQueryComponent(safeTitle);

    Response response = await client.get("$apiUrl/posts?search=$encodedTitle&_fields=id,title,date,yoast_head_json,content,categories,tags,link");
    List<dynamic> data = response.data;

    List<Article> articles = [];
    for(var e in data){
      Article article = processWordpressApiResponse(e);
      articles.add(article);
      articleByTitle.add(article);
    }

    return articles;
  }

  Future<List<Article>> loadSearchArticles(String title) async{
    String safeTitle = title.replaceAll(RegExp(r"""[:??????!?.,"@#$&()/]"""), '');
    String encodedTitle = Uri.encodeQueryComponent(safeTitle);
    int searchCountToShow = 10;
    int count = 0;

    Response response = await client.get("$apiUrl/posts?search=\"$encodedTitle\"&_fields=id,title,date,yoast_head_json,content,categories,tags,link&per_page=99");
    List<dynamic> data = response.data;

    List<Article> articles = [];
    searchArticles.clear();

    final regex = RegExp(r'\b' + RegExp.escape(safeTitle) + r'\b', caseSensitive: false);
    for(var e in data){
      if(count < searchCountToShow){
        final content = e["content"]["rendered"];
        final title = e["title"]["rendered"];

        if (regex.hasMatch(title) || regex.hasMatch(content)) {
          Article article = processWordpressApiResponse(e);
          articles.add(article);
          searchArticles.add(article);
          count++;
        }
      }
    }

    return articles;
  }

  List<Article> getArticleByCategory(String category){
    if(articleByCategory[category] == null){
      return [];
    }
    return articleByCategory[category]!;
  }

  List<Article> getArticleBySubcategory(int subcategory){
    if(articleBySubcategory[subcategory] == null){
      return [];
    }
    return articleBySubcategory[subcategory]!;
  }

  Article processWordpressApiResponse(dynamic wpPost){
    var document = parse(wpPost["title"]["rendered"]);
    String title = removeAllHtmlTags(document.body!.text);

    final rawId = wpPost["id"];
    final int id = rawId is int ? rawId : int.parse(rawId.toString());


    String paragraph = wpPost["content"]["rendered"];
    List<Map<String, String>> content = [{
      "paragraph" : paragraph,
    }];

    int startIndex = paragraph.indexOf("<p");
    int endIndex = paragraph.indexOf("</p>") + 4;
    if(startIndex != -1){
      content[0]["summary"] = paragraph.substring(startIndex, endIndex);
    }else{
      content[0]["summary"] = "";
    }

    String date = wpPost["date"];
    int index = date.indexOf("T");
    String formattedDate = "${date.substring(0, index)} ${date.substring(index + 1)}";
    DateTime published = DateTime.parse(formattedDate);

    var categoryId = wpPost["categories"][0];

    String category = categoryIdToName[categoryId]!;

    String imagePath = wpPost["yoast_head_json"]["og_image"][0]["url"];

    int articleMinRead = (paragraph.length/1500).round();

    List<int> tags = [];
    if(wpPost["tags"] != null){
      List<dynamic> tagsRawData = wpPost["tags"];
      for(var e in tagsRawData){
        tags.add(int.parse(e.toString()));
      }
    }

    bool isTagLink = false;
    String link = wpPost["link"]?.toString() ?? "";
    int linkStartIndex = link.indexOf("utusansarawak.com.my/") + 21;
    int linkEndIndex = link.length;
    String subStr = link.substring(linkStartIndex, linkEndIndex);
    if(subStr.contains("?tag=")){
      isTagLink = true;
    }

    Article article = Article(
      id: id,
      title: title,
      shortTitle: title,
      content: content,
      imagePath: imagePath,
      category: category,
      minRead: articleMinRead,
      published: published,
      tags: tags,
      isTagLink: isTagLink,
      link: link,
    );

    return article;
  }

}


